# frozen_string_literal: true

require 'openai'

module RoutePlanner
  module OpenAPI
    # Service for interacting with the OpenAI API
    class ChatService
      attr_reader :input, :prompt, :api_key

      def initialize(input:, prompt:, api_key:)
        @input = input
        @prompt = prompt
        @api_key = api_key
      end

      def call
        messages = generate_messages

        response = client.chat(
          parameters: {
            model: 'gpt-3.5-turbo',
            response_format: { type: 'json_object' },
            messages: messages,
            temperature: 0.7
          }
        )

        response.dig('choices', 0, 'message', 'content')
      end

      private

      def generate_messages
        # prompts = send(prompt.to_s)
        @prompt.map { |p| { role: 'system', content: p } } << { role: 'user', content: @input }
      end

      def client
        @client ||= OpenAI::Client.new(access_token: api_key)
      end
    end
  end
end
