# frozen_string_literal: true

module RoutePlanner
  module Entity
    # Domain entity for team members
    class SkillSet < Dry::Struct
      include Dry.Types

      attr_reader :skill, :difficulty

      # Syllabus summary: course_name, course_description, course_evaluation, AI_use_policy
      def summarize_prompt
        [
          'Provide valid JSON Output',
          'Provide a summary of the course syllabi.',
          'Extract the following information:',
          'Provide a column for each information:',
          'Course name, Course description, Course evaluation methods, AI use policy',
          'Keep the summary concise and informative'
        ]
      end

      # Prerequisite: skill_name and value of difficulty from 1~100
      def skillset_prompt
        [
          'Provide valid JSON Output',
          'Provide the top 5 prerequisite subjects for the course suitable for the syllabus',
          'Provide one column prerequisite, subject name, and another column, difficulty level, from 1 to 100',
          'Rank the difficulty from easiest to hardest for an average person'
        ]
      end
    end
  end
end
