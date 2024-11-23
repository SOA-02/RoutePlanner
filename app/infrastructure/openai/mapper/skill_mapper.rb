# frozen_string_literal: true

module RoutePlanner
  module OpenAPI
    # map main quest to entity
    class SkillMapper
      def initialize(input, openai_key, prompt = skill_prompt, gateway_class = ChatService)
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

      def skill_prompt
        RoutePlanner::Entity::Skill.new.skill_prompt
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
          # RoutePlanner::Entity::Skill.new(
          #   skill_name: @parsed_response['prerequisite_subjects'][0]['subject_name'],
          #   challenge_level: @parsed_response['prerequisite_subjects'][0]['difficulty_level']
          # )
        end

        # private

        # def skill_name
        #   @parsed_response['prerequisite_subjects'][0]['subject_name']
        # end

        # def challenge_level
        #   @parsed_response['prerequisite_subjects'][0]['difficulty_level']
        # end
      end
    end
  end
end
