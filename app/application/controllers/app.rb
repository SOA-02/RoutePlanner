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
        view 'home'
      end

      # GET /LevelEvaluation
      routing.on 'LevelEvaluation' do
        routing.is do
          form_syllabus = Forms::NewSyllabus.new.call(routing.params)
          if form_syllabus.failure?
            errors = form_syllabus.errors.to_h
            flash[:error] = errors[:syllabus_title].first if errors[:syllabus_title]
            flash[:error] = errors[:syllabus_text].first if errors[:syllabus_text]
            routing.redirect '/'
          end
          syllabus_title=form_syllabus[:syllabus_title]
          syllabus_text=form_syllabus[:syllabus_text]
          binding.irb
          result = RoutePlanner::Service::AddMapandSkill.new.call(
            syllabus_title: syllabus_title, syllabus_text: syllabus_text
          )
          binding.irb
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
            binding.irb
            result = Service::FethcAnayzleResult.new.call(routing.params)

            binding.irb
            if result.success?
              binding.irb

              view 'ability_recs',
              locals: {  map_name: result.value![:map],
                            online_resources:  result.value![:online_resources],
                            physical_resources: result.value![:physical_resources],
                            time:  result.value![:time],
                            stress_index: result.value![:stress_index] }
            else
              flash[:error] = result.failure
              routing.redirect '/'
            end

          end
        end

#         routing.on String do |map|
#           # GET /RoutePlanner/:skills
#           routing.get do # rubocop:disable Metrics/BlockLength


#               view 'ability_recs',
#                    locals: { online_resources: online_resources, physical_resources: physical_resources, time: time,
# stress_index: stress_index }

#           end
#         end
      end
    end
  end
end
