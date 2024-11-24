# frozen_string_literal: true

module RoutePlanner
  module Value
    # Domain value for prompts
    class Prompt
      # Syllabus summary: course_name, course_description, course_evaluation, AI_use_policy
      def summarize_prompt
        [
          'Provide valid JSON Output',
          'Provide a summary of the course syllabi.',
          'Extract the following information:',
          'Provide a column for each information:',
          'Course name, Course description, Course evaluation methods, AI use policy',
          'Keep the summary concise and informative',
          'AI use policy is defined as whether LLM like ChatGPT, Copilot, etc. is allowed to be used'
        ]
      end

      # Prerequisite: skill_name and value of difficulty from 1~100
      def skill_prompt
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