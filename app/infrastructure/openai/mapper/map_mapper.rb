# frozen_string_literal: true

module RoutePlanner
  module OpenAPI
    # map main quest to entity
    class MapMapper
      def initialize(input, openai_key, prompt = summarize_prompt, gateway_class = ChatService)
        @input = input
        @openai_key = openai_key
        @prompt = prompt
        @gateway_class = gateway_class
        @gateway = build_gateway
      end

      def call
        summary = @gateway.call
        parsed_summary = parse_response(summary)
        build_entity(parsed_summary)
      end

      def summarize_prompt
        RoutePlanner::Value::Prompt.new.summarize_prompt
      end

      def build_gateway
        @gateway_class.new(
          input: @input,
          prompt: @prompt,
          api_key: @openai_key
        )
      end

      def parse_response(response)
        response.gsub(/^```json\n|```$/m, '')
        JSON.parse(response)
        # puts parsed['prerequisite_subjects'][0]
      end

      def build_entity(response)
        DataMapper.new(response).build_entity
      end

      # map entities to domain object
      class DataMapper
        def initialize(parsed_response)
          @parsed_response = parsed_response
        end

        def build_entity
          RoutePlanner::Entity::Map.new(
            id: nil,
            map_name:,
            map_description:,
            map_evaluation:,
            map_ai:
          )
        end

        private

        def map_name
          @parsed_response['Course name']
        end

        def map_description
          @parsed_response['Course description']
        end

        def map_evaluation
          @parsed_response['Course evaluation methods']
        end

        def map_ai
          @parsed_response['AI use policy']
        end
      end
    end
  end
end
