# frozen_string_literal: true

module RoutePlanner
  module Value
    # Domain value for search
    class YoutubeSearch
      def self.max_results
        5
      end

      def self.modified_keyword(keyword)
        "#{keyword} one hour lectures tutorials"
      end

      def self.resource_type
        'youtube#video'
      end

      def self.platform
        'youtube'
      end
    end
  end
end
