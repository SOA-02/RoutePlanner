# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module RoutePlanner
  module Entity
    # Domain entity for team members
    class Skill < Dry::Struct
      include Dry.Types()

      attribute :skill_name, Strict::String
      attribute :challenge_level, Strict::Integer
      attribute? :loot_resources, Strict::Array.of(Strict::Hash).optional.default([])
    end
  end
end

# skill = RoutePlanner::Entity::Skill.new(skill_name: 'Ruby', challenge_level: 30)
# puts skill.skill_name
# puts skill.challenge_level
