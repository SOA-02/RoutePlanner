# frozen_string_literal: true

module RoutePlanner
  module OpenAPI
    # Map subject name and difficulty score to entity
    class MapMapper
      def initialize(input, openai_key, prompt = summarize_prompt, gateway_class = ChatService)
        @input = input
        @openai_key = openai_key
        @prompt = prompt
        @gateway_class = gateway_class
        @gateway = build_gateway
      end

      def call
        @gateway.call
        # parse_response(skillset)
        # build_entity(skill)
      end

      def summarize_prompt
        RoutePlanner::Entity::Map.new.summarize_prompt
      end

      def build_gateway
        @gateway_class.new(
          input: @input,
          prompt: @prompt,
          api_key: @openai_key
        )
      end
    end
  end
end
