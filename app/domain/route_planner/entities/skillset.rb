# frozen_string_literal: true

module RoutePlanner
  module Entity
    # Domain entity for team members
    class SkillSet < Dry::Struct
      include Dry.Types

      # arrtribute skillset , Strict::Array.of(Strict::String)

      # get the skills from skill entity
    end
  end
end
