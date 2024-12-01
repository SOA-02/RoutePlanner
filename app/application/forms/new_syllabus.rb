# frozen_string_literal: true

require 'dry-validation'

module RoutePlanner
  module Forms
    # Validation for new search form
    class NewSyllabus < Dry::Validation::Contract
      MSG_INVALID_TITLE = 'Course Title must be filled.'
      MSG_INVALID_TEXT = 'Course Syllabus must be filled.'

      params do
        required(:syllabus_title).value(:string)
        required(:syllabus_text).value(:string)
      end

      rule(:syllabus_title) do
        key.failure(MSG_INVALID_TITLE) if value.strip.empty?
      end

      rule(:syllabus_text) do
        key.failure(MSG_INVALID_TEXT) if value.strip.empty?
      end
    end
  end
end
