# frozen_string_literal: true

require 'rack' # for Rack::MethodOverride
require 'roda'
require 'slim'
require 'slim/include'
module RoutePlanner
  # Web App
  class App < Roda
    css_files = [
      'style.css'
    ]
    plugin :halt
    plugin :flash
    plugin :all_verbs # allows HTTP verbs beyond GET/POST (e.g., DELETE)
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets',
                    css: css_files
    plugin :common_logger, $stderr

    use Rack::MethodOverride # allows HTTP verbs beyond GET/POST (e.g., DELETE)
    MSG_GET_STARTED = 'Please enter the keywords you are interested in to get started.'
    MSG_SERVER_ERROR = 'Internal Server Error'

    route do |routing| # rubocop:disable Metrics/BlockLength
      routing.public
      routing.assets # Load CSS and JS
      response['Content-Type'] = 'text/html; charset=utf-8'
      # GET /
      routing.root do
        session[:watching] ||= []
        # maps = Repository::For.klass(Entity::Map).all
        result = Service::FetchViewedRoadmap.new.call(session[:watching])
        if result.failure?
          flash[:error] = result.failure
          maps = []
        else
          maps = result.value!
          flash.now[:notice] = MSG_GET_STARTED if maps.none?
          session[:watching] = maps.map(&:map_name)
        end
        view 'home_text', locals: { maps: maps }


        # Get cookie viewer's previously seen videos
        # session[:watching] ||= []
        # result = Service::FetchViewedRoadmap.new.call(session[:watching])
        # watchout
        # if result.failure?
        #   flash[:error] = result.failure
        #   viewable_resource = []
        # else
        #   resourcelist = result.value!
        #   flash.now[:notice] = MSG_GET_STARTED if resourcelist.none?
        #   session[:watching] = resourcelist.map(&:original_id)
        #   viewable_resource = Views::RoadmapsList.new(resourcelist)
        # end
        # view 'home', locals: { roadmaps: viewable_resource }
      end

      routing.on 'analyze' do
        form = RoutePlanner::Forms::NewSyllabus.new.call(routing.params)
        if form.failure?
          flash[:error] = form.errors[:syllabus_text].first
          routing.redirect '/'
        else
          syllabus_text = form[:syllabus_text]

          map = RoutePlanner::Service::MapService
            .new(syllabus_text, App.config.OPENAI_KEY)
            .call

          skillset = RoutePlanner::Service::SkillService
            .new(syllabus_text, App.config.OPENAI_KEY)
            .call
          
          view 'analyze', locals: { map: map, skills: skillset }
        end
      end
      # routing.on 'search' do
      #   routing.is do
      #     # POST /search/
      #     routing.post do
      #       key_word_request = Forms::NewSearch.new.call(routing.params)
      #       if key_word_request.errors.empty?
      #         key_word = key_word_request[:syllabus]
      #         routing.redirect "search/#{key_word}"
      #       else
      #         flash[:error] = key_word_request.errors[:syllabus].first
      #         routing.redirect '/'
      #       end
      #     end
      #   end

      #   routing.on String do |key_word|
      #     # GET /search/key_word
      #     routing.get do
      #       results = Service::SearchService.new.video_from_youtube(key_word)
      #       if results.failure?
      #         flash[:error] = results.failure
      #         routing.redirect '/'
      #       else
      #         @search_results = results.value!
      #         view 'search', locals: { search_results: @search_results }
      #       end
      #     end
      #   end
      # end

      routing.on 'LevelEvaluation' do
        routing.is do
          map_name = 'sorry'
          session[:skills] ||= []
          result_map = Service::FetchMapInfo.new.call(map_name)

          result_skill = Service::FetchSkillListInfo.new.call(map_name)
          binding.irb
          if result_map.failure? || result_skill.failure?
            flash[:error] = result.failure
          else
            skills = Views::SkillList.new(result_skill.value!)
            map = Views::Map.new(result_map.value!)
            view 'level_eval', locals: { map: map, skills: skills }
          end
        end
      end
      routing.on 'RoutePlanner' do # rubocop:disable Metrics/BlockLength
        routing.is do
          # POST /RoutePlanner
          routing.post do
            response = Forms::SkillsFormValidation.new.call(routing.params)
            routing.redirect '/' if response.failure?
            map = routing.params.keys.first.split('_').first
            session[:skills] = routing.params.values.first
            routing.redirect "RoutePlanner/#{map}"
          end
        end

        routing.on String do |map|
          # GET /RoutePlanner/:skills
          routing.get do # rubocop:disable Metrics/BlockLength
            results = []
            errors = []
            session[:skills].each_key do |skill|
              result = Service::AddResources.new.call(online_skill: skill, physical_skill: skill)
              if result.success?
                results << result.value!
              else
                errors << result.failure
              end
            end

            if errors.any?
              flash[:error] = "Error processing skill: #{errors.join(', ')}"
              routing.redirect '/'
            else
              results = []
              desired_skill = session[:skills].reject { |_key, value| value == 'familiar' }
              desired_skill.each_key do |skill|
                viewable_resource = Service::FetchViewedResources.new.call(skill)
                if viewable_resource.success?
                  results << viewable_resource.value!
                else
                  errors << viewable_resource.failure
                end
              end
            end

            if results.any?
              online_resources = Views::OnlineResourceList.new(results.map { |res| res[:online_resources] }.flatten)
              physical_resources = Views::PhyicalResourcesList.new(results.map do |res|
                res[:physical_resources]
              end.flatten)

              view 'ability_recs',
                   locals: { online_resources: online_resources, physical_resources: physical_resources }
            else
              flash[:error] = "Some errors occurred: #{errors.join(', ')}" if errors.any?
              routing.redirect '/'
            end
          end
        end
      end
    end
  end
end
