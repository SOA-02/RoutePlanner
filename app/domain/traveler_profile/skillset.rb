# frozen_string_literal: true

module RoutePlanner
  module Entity
    # Domain entity for team members
    class SkillSet #< Dry::Struct
      # include Dry.Types

      #attribute :skill_name_1, Strict::String
      #attribute :difficulty_1, Strict::Integer

      attr_reader :skill, :difficulty

      # Syllabus summary: course_name, course_description, course_evaluation, AI_use_policy
      def summarize_prompt
        [
          'You are an AI assistant that summarizes course syllabi.',
          'Extract the following information:',
          'Course name',
          'Course description',
          'Course evaluation methods',
          'AI use policy',
          'Format as JSON'
        ]
      end

      # Prerequisite: skill_name and value of difficulty from 1~100
      def skill_prompt
        [
          'You are a helpful assistant that suggests 3 most important prerequisite subjects with difficulty score',
          'suitable for the syllabus in JSON format'
        ]
      end
    end
  end
end
