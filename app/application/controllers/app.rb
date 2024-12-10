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
        maps = Repository::For.klass(Entity::Map).all
        view 'home', locals: { maps: maps }
      end

      routing.on 'analyze' do
        form_syllabus = Forms::NewSyllabus.new.call(routing.params)

        if form_syllabus.failure?
          errors = form_syllabus.errors.to_h
          flash[:error] = errors[:syllabus_title].first if errors[:syllabus_title]
          flash[:error] = errors[:syllabus_text].first if errors[:syllabus_text]
          routing.redirect '/'
        end

        result = Service::AddMap.new.call(
          syllabus_title: form_syllabus[:syllabus_title],
          syllabus_text: form_syllabus[:syllabus_text]
        )

        if result.success?
          view 'analyze', locals: {
            map: result.value![:map],
            skills: result.value![:skills]
          }
        else
          flash[:error] = result.failure
          routing.redirect '/'
        end
      end

      routing.on 'LevelEvaluation' do
        routing.is do
          form_syllabus = Forms::NewSyllabus.new.call(routing.params)

          if form_syllabus.failure?
            errors = form_syllabus.errors.to_h
            flash[:error] = errors[:syllabus_title].first if errors[:syllabus_title]
            flash[:error] = errors[:syllabus_text].first if errors[:syllabus_text]
            routing.redirect '/'
          end

          result = Service::AddMap.new.call(
            syllabus_title: form_syllabus[:syllabus_title],
            syllabus_text: form_syllabus[:syllabus_text]
          )

          if result.success?
            view 'level_eval', locals: {
              map: result.value![:map],
              skills: result.value![:skills]
            }
          else
            flash[:error] = result.failure
            routing.redirect '/'
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
            binding.irb
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
            binding.irb
            if results.any?
              results = []
              desired_resource = RoutePlanner::Mixins::Recommendations.desired_resource(session[:skills])

              desired_resource.each_key do |skill|
                viewable_resource = Service::FetchViewedResources.new.call(skill)
                if viewable_resource.success?
                  results << viewable_resource.value!
                else
                  errors << viewable_resource.failure
                end
              end
            elsif errors.any?
              flash[:error] = "Error processing skill: #{errors.join(', ')}"
              routing.redirect '/'
            else
              flash[:notice] = 'No resources found.'
              routing.redirect '/'
            end

            if results.any?
              time = Value::ResourceTimeCalculator.compute_minimum_time(results)
              stress_index = Value::EvaluateStudyStress.evaluate_stress_level(desired_resource, time)
              binding.irb
              online_resources = Views::OnlineResourceList.new(results.map { |res| res[:online_resources] }.flatten)
              physical_resources = Views::PhyicalResourcesList.new(results.map do |res|
                res[:physical_resources]
              end.flatten)

              view 'ability_recs',
                   locals: { online_resources: online_resources, physical_resources: physical_resources, time: time,
stress_index: stress_index }
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
