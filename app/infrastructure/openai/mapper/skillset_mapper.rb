# frozen_string_literal: true

module RoutePlanner
  module OpenAPI
    # map main quest to entity
    class SkillSetMapper
      def initialize(input, prompt, openai_key, gateway_class = ChatService)
        @input = input
        @prompt = prompt
        @openai_key = openai_key
        @gateway_class = gateway_class
        @gateway = gateway_class.new(
          input: @input,
          prompt: @prompt,
          api_key: @openai_key
        )
      end

      def call
        @gateway.call
        #parse_response(skill)
        # build_entity(parsed)
      end

      def parse_response(response)
        JSON.parse(response)
        # puts parsed['prerequisites'][0]
      end

      def build_entity(response)
        DataMapper.new(response)
      end

      # map entities to domain object
      class DataMapper
        def initialize(parsed_response)
          @parsed_response = parsed_response
        end
      end
    end
  end
end
