# frozen_string_literal: true

require 'dry/monads'

module RoutePlanner
  module Service
    # Service to map the syllabus to a list of skills
    class MapService
      include Dry::Monads::Result::Mixin
      MSG_NO_MAP = 'Unable to find a destination for you.'

      def initialize(syllabus_text, openai_key)
        @syllabus_text = syllabus_text
        @openai_key = openai_key
      end

      def call
        map = create_map
        save_map(map)
      end

      def create_map
        RoutePlanner::OpenAPI::MapMapper
          .new(@syllabus_text, @openai_key)
          .call
      end

      def save_map(map)
        Repository::For.entity(map).build_map(map)
      end
    end
  end
end
