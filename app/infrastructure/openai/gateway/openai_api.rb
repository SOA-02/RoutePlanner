# frozen_string_literal: true


require 'yaml'
require 'openai'

# Load API key from secrets.yml
# config = YAML.load_file('../../../../config/secrets.yml')
# api_key = config['development']['OPENAI_KEY']
# test_key = RoutePlanner::App.config.OPENAI_KEY
# puts "Loaded API Key: #{api_key}"
# test_key cannot be loaded
# puts "Loaded env API Key: #{test_key}"


module RoutePlanner
  module Mixins
    # Service for interacting with the OpenAI API
    class ChatService
      attr_reader :message, :prompt, :api_key

      def initialize(message:, prompt:, api_key:)
        @message = message
        @prompt = prompt
        @api_key = api_key
      end

      def call
        messages = generate_messages

        response = client.chat(
          parameters: {
            model: 'gpt-3.5-turbo',
            messages: messages,
            temperature: 0.7
          }
        )

        response.dig('choices', 0, 'message', 'content')
      end

      private

      # Syllabus summary: course_name, course_description, course_evaluation, AI_use_policy
      # Prerequisite: skill_name and value of difficulty from 1~100

      def generate_messages
        prompts = send("#{prompt}_prompts")
        prompts.map { |p| { role: 'system', content: p } } << { role: 'user', content: message }
      end

      def physical_training_prompts
        [
          'suggests prerequisites keywords suitable for youtube search in json format'
        ]
      end

      def online_training_prompts
        [
          'suggests prerequisites keywords suitable for youtube search in json format'
        ]
      end

      def client
        @client ||= OpenAI::Client.new(access_token: api_key)
      end
    end
  end
end


# Example Usage
# prompt = :physical_training
# service = RoutePlanner::Mixins::ChatService.new(message: 'machine learning', prompt: prompt, api_key: api_key)
# response = service.call

# puts 'OpenAI Response:'
# puts response
