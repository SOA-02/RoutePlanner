# frozen_string_literal: true

module RoutePlanner
  module OpenAPI
    # map main quest to entity
    class SkillSetMapper
      def initialize(input, openai_key, prompt = skillset_prompt, gateway_class = ChatService)
        @input = input
        @openai_key = openai_key
        @prompt = prompt
        @gateway_class = gateway_class
        @gateway = build_gateway
      end

      def call
        @gateway.call
      end

      private

      def skillset_prompt
        RoutePlanner::Entity::SkillSet.new.skillset_prompt
      end

      def build_gateway
        @gateway_class.new(
          input: @input,
          prompt: @prompt,
          api_key: @openai_key
        )
      end
      # def parse_response(response)
      #   JSON.parse(response)
      #   # puts parsed['prerequisites'][0]
      # end

      # def build_entity(response)
      #   DataMapper.new(response)
      # end

      # # map entities to domain object
      # class DataMapper
      #   def initialize(parsed_response)
      #     @parsed_response = parsed_response
      #   end
      # end
    end
  end
end
