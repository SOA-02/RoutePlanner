# frozen_string_literal: true

require 'dry-validation'

module RoutePlanner
  module Forms
    # Validation for new search form
    class NewSyllabus < Dry::Validation::Contract
      MSG_INVALID_INPUT = 'Please enter a non-empty syllabus text.'

      params do
        required(:syllabus_text).filled(:string)
      end

      rule(:syllabus_text) do
        key.failure(MSG_INVALID_INPUT) if value.strip.empty?
      end
    end
  end
end
