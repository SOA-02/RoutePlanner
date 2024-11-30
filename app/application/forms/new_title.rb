# frozen_string_literal: true

require 'dry-validation'

module RoutePlanner
  module Forms
    # Validation for new search form
    class NewTitle < Dry::Validation::Contract
      MSG_INVALID_INPUT = 'Please enter a non-empty syllabus title.'

      params do
        required(:syllabus_title).filled(:string)
      end

      rule(:syllabus_title) do
        key.failure(MSG_INVALID_INPUT) if value.strip.empty?
      end
    end
  end
end
