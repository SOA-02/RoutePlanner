# frozen_string_literal: true

require 'http'
require 'yaml'

module RoutePlanner
  # Represents interactions with the Nthusa .
  module Nthusa
    # Library for Nthusa Web API
    class NthusaApi
      def nthusa_search_recommend(pre_req)
        Request.new.nthusa_search_recommend_path(pre_req).parse
      end

      # Sends out HTTP requests to Nthusa
      class Request
        NTHUSA_API_ROOT = 'https://api.nthusa.tw'
        MAX_RESULTS = 5
        # MAX = 'Analytic'
        def nthusa_search_recommend_path(pre_req)
          get(NTHUSA_API_ROOT + "/courses/searches?field=english_title&value=#{pre_req}&limits=#{MAX_RESULTS}")
        end

        def get(url)
          # puts("先確認URL是否正確#{url}")
          http_response = HTTP.headers('Accept' => 'application/json').get(url)
          Response.new(http_response).tap do |response|
            raise(response.error) unless response.successful?
          end
        end
      end

      # Decorates HTTP responses from Nthusa with success/error

      class Response < SimpleDelegator # rubocop:disable Style/Documentation
        NotFound = Class.new(StandardError)
        HTTP_ERROR = {
          404 => NotFound
        }.freeze

        def successful?
          HTTP_ERROR.keys.none?(code)
        end

        def error
          HTTP_ERROR[code]
        end
      end
    end
  end
end
