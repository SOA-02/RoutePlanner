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

    route do |routing|
      routing.root do
        view 'home_text'
      end

      routing.post 'analyze' do
        syllabus_text = routing.params['syllabus_text']
        
        # Initialize and call ChatService
        result = RoutePlanner::OpenAPI::SkillMapper.new(
          input: syllabus_text,
          openai_key: App.config.OPENAI_KEY
        ).call
    
        # Render results view with analyzed skills
        view 'analyze', locals: { skills: result }
      end
    end
    # route do |routing| # rubocop:disable Metrics/BlockLength
    #   routing.public
    #   routing.assets # Load CSS and JS
    #   response['Content-Type'] = 'text/html; charset=utf-8'
    #   # GET /
    #   routing.root do
    #     # Get cookie viewer's previously seen videos
    #     session[:watching] ||= []
    #     result = Service::FetchViewedRoadmap.new.call(session[:watching])
    #     # watchout
    #     if result.failure?
    #       flash[:error] = result.failure
    #       viewable_resource = []
    #     else
    #       resourcelist = result.value!
    #       flash.now[:notice] = MSG_GET_STARTED if resourcelist.none?
    #       session[:watching] = resourcelist.map(&:original_id)
    #       viewable_resource = Views::RoadmapsList.new(resourcelist)
    #     end
    #     view 'home', locals: { roadmaps: viewable_resource }
    #   end
      # routing.on 'search' do
      #   routing.is do
      #     # POST /search/
      #     routing.post do
      #       key_word_request = Forms::NewSearch.new.call(routing.params)
      #       if key_word_request.errors.empty?
      #         key_word = key_word_request[:search_key_word]
      #         routing.redirect "search/#{key_word}"
      #       else
      #         flash[:error] = key_word_request.errors[:search_key_word].first
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

      # routing.on 'RoutePlanner' do
      #   routing.is do
      #     routing.post do
      #       routing.redirect "RoutePlanner/#{original_id}"
      #     end
      #   end

      #   routing.on String do |original_id|
      #     session[:watching].insert(0, original_id).uniq!
      #     # DELETE /RoutePlanner/{video_id}
      #     routing.delete do
      #       session[:watching].delete(original_id)
      #       routing.redirect '/'
      #     end

      #     # GET /RoutePlanner/video_id
      #     routing.get do

      #     end
      #   end
      # end
    #end
  end
end
