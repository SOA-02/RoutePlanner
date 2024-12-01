# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module RoutePlanner
  module Entity
    # Domain entity for team members
    class MapSkill < Dry::Struct
      include Dry.Types

      attribute :id, Integer.optional
      attribute :map_id, Strict::Integer
      attribute :skill_id, Strict::Integer

    end
  end
end
