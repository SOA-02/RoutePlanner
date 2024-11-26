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
        # Get cookie viewer's previously seen videos
        session[:watching] ||= []
        result = Service::FetchViewedRoadmap.new.call(session[:watching])
        # watchout
        if result.failure?
          flash[:error] = result.failure
          viewable_resource = []
        else
          resourcelist = result.value!
          flash.now[:notice] = MSG_GET_STARTED if resourcelist.none?
          session[:watching] = resourcelist.map(&:original_id)
          viewable_resource = Views::RoadmapsList.new(resourcelist)
        end
        view 'home', locals: { roadmaps: viewable_resource }
      end
      routing.on 'search' do
        routing.is do
          # POST /search/
          routing.post do
            key_word_request = Forms::NewSearch.new.call(routing.params)
            if key_word_request.errors.empty?
              key_word = key_word_request[:search_key_word]
              routing.redirect "search/#{key_word}"
            else
              flash[:error] = key_word_request.errors[:search_key_word].first
              routing.redirect '/'
            end
          end
        end

        routing.on String do |key_word|
          # GET /search/key_word
          routing.get do
            results = Service::SearchService.new.video_from_youtube(key_word)
            if results.failure?
              flash[:error] = results.failure
              routing.redirect '/'
            else
              @search_results = results.value!
              view 'search', locals: { search_results: @search_results }
            end
          end
        end
      end

      routing.on 'LevelEvaluation' do
        routing.is do
          map_name = 'sorry'
          skill_name = 'statistical'
          result = Service::FetchMapWithEvalSkill.new.call(map_name)

          resulta = Service::FetchSkillListWithEvalSkill.new.call(map_name)
          # b = Database::MapSkillsOrm.where(map_id:map_id).select(:skill_id).all
          # a = Repository::For.klass(RoutePlanner::Entity::Map).find_map_name('sorry')
          # a = Repository::For.klass(RoutePlanner::Entity::Map).all
          if result.failure? || resulta.failure?
            flash[:error] = result.failure
          else
            skills = Views::SkillList.new(resulta.value!)
            map = Views::Map.new(result.value!)
            view 'level_eval', locals: { map: map, skills: skills }
          end
        end
      end
      routing.on 'RoutePlanner' do
        routing.is do
          # POST /RoutePlanner
          routing.post do
            puts 'RoutePlanner POST matched'
            skills = routing.params['skills']
      
            # 重定向到 GET 路徑，將關鍵字合併成用逗號分隔的參數
            redirect_skills = skills.keys.join(',')
            routing.redirect "RoutePlanner/#{redirect_skills}"
          end
        end
      
        routing.on String do |skills_str|
          # GET /RoutePlanner/:skills
          routing.get do
            # 解析逗號分隔的關鍵字
            skills = skills_str.split(',')
      
            results = []
            errors = []
      
            skills.each do |key_word|
              result = Service::AddResources.new.call(key_word: key_word, pre_req: key_word)
      
              if result.success?
                results << result.value!
              else
                errors << result.failure
              end
            end
      
            if results.any?
              online_resources = Views::OnlineResourceList.new(results.map { |res| res[:online_resources] }.flatten)
              physical_resources = Views::PhyicalResourcesList.new(results.map { |res| res[:physical_resources] }.flatten)
      
              # 渲染結果頁面
              view 'ability_recs',
                   locals: { online_resources: online_resources, physical_resources: physical_resources }
            else
              flash[:error] = "Some errors occurred: #{errors.join(', ')}" if errors.any?
              routing.redirect '/'
            end
          end
        end
      end
      # routing.on 'RoutePlanner' do
      #   routing.is do
      #     # temp for test
      #     routing.post do
      #       puts 'RoutePlanner POST matched'
      #       a= routing.params['skills']
      #       binding.irb
      #       results = []
      #       errors = []
      #       routing.params['skills'].each_key do |key_word|
      #         result = Service::AddResources.new.call(key_word: key_word, pre_req: key_word)

      #         if result.success?
      #           results << result.value!
      #         else
      #           errors << result.failure
      #         end
      #       end
      #       binding.irb
      #       # binding
      #       # # result = Service::AddOnlineResource.new.call(key_word: 'C++')
      #       # binding.irb
      #       if results.any?
      #         online_resources = Views::OnlineResourceList.new(results.map { |res| res[:online_resources] }.flatten)
      #         physical_resources = Views::PhyicalResourcesList.new(results.map do |res|
      #           res[:physical_resources]
      #         end.flatten)
      #         binding.irb
      #         view 'ability_recs',
      #              locals: { online_resources: online_resources, physical_resources: physical_resources }
      #       end

      #       flash[:error] = "Some errors occurred: #{errors.join(', ')}" if errors.any?
      #     end
      #   end
      # end
    end
  end
end
