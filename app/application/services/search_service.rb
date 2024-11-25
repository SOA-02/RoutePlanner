# frozen_string_literal: true

require 'dry/monads'
module RoutePlanner
  module Service
    class SearchService
      include Dry::Monads::Result::Mixin
      MSG_NO_RECLIST = 'Unable to recommend a list of related videos for you.'

      def video_from_youtube(key_word)
        @search_results = Youtube::VideoRecommendMapper
          .new(App.config.API_KEY)
          .find(key_word)

        # Handle the case where no results are found
        if @search_results == 'Video data is missing' || @search_results == 'No video items found'
          return Failure(MSG_NO_RECLIST)
        end

        Success(@search_results)
      rescue StandardError
        Failure(MSG_SERVER_ERROR)
      end
    end
  end
end
