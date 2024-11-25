# frozen_string_literal: true

module RoutePlanner
  module OpenAPI
    # map main quest to entity
    class SideQuestMapper
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
    end
  end
end
