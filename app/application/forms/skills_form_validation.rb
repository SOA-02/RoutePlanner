# frozen_string_literal: true

require 'dry-validation'

module RoutePlanner
  module Forms
    # Validation for Skills Form Input
    class SkillsFormValidation < Dry::Validation::Contract
      VALID_SKILL_VALUES = (1..100).map(&:to_s).freeze
      MSG_INVALID_SKILL_VALUE = "Skill value must be one of: #{VALID_SKILL_VALUES.join(', ')}.".freeze

      params do
        hash do
          array do
            hash do
              array do
                required(:key).filled(:string)
                required(:value).filled(:string, included_in?: VALID_SKILL_VALUES)
              end
            end
          end
        end
      end
    end
  end
end
