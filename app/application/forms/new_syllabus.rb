# frozen_string_literal: true

require 'dry-validation'

module RoutePlanner
  module Forms
    # Validation for new search form
    class NewSyllabus < Dry::Validation::Contract
      INPUTS_REGEX = /\A(?!.*<script>|.*javascript:)[\p{L}\p{N}\p{P}]*\p{L}[\p{L}\p{N}\p{P}]*\z/
      MSG_INVALID_INPUT = 'Please enter a non-empty syllabus text.'

      params do
        required(:syllabus_text).filled(:string)
      end

      rule(:syllabus_text) do
        key.failure(MSG_INVALID_INPUT) unless INPUTS_REGEX.match?(value)
      end
    end
  end
end
