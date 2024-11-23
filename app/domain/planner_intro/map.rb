# frozen_string_literal: true

module RoutePlanner
  module Entity
    # Domain entity for team members
    class Map
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
    end
  end
end
