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
          'Provide a column for each information in this format:',
          '"CourseName:", "CourseDescription:", "CourseEvaluationMethods:", "AIUsePolicy:"',
          'Keep the summary concise and informative',
          'AI use policy is defined as whether LLM like ChatGPT, Copilot, etc. is allowed to be used',
          'Course evaluation methods should be in datatype String'
        ]
      end

      # Prerequisite: skill_name and value of difficulty from 1~100
      def skill_prompt
        [
          'Provide valid JSON Output',
          'Provide the top 5 prerequisite keywords for the course suitable for the syllabus',
          'Provide only the keyword and not "Introduction to..." or "Advanced..." or etc',
          'Provide in this format: "SubjectName:", "DifficultyLevel:"',
          'Example format: {"prerequisite_subjects"=>[{"SubjectName"=>"Statistics", "DifficultyLevel"=>50},...',
          'Rank the difficulty from easiest to hardest for an average person',
          'Please do not recommend none even if the class is easy'
        ]
      end

      def rank_resource_prompt
        [
          'Rank the importance of the learning resources according to the user needs'
        ]
      end
    end
  end
end
