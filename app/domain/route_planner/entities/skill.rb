# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

require_relative 'physical'
require_relative 'online'
module RoutePlanner
  module Entity
    # Domain entity for team members
    class Skill < Dry::Struct
      include Dry.Types()

      attribute :id, Integer.optional
      attribute :skill_name, Strict::String
      attribute :challenge_score, Strict::Integer
      # attribute? :loot_resources, Strict::Array.of(Strict::Hash).optional.default([])

      def to_attr_hash
        to_hash.except(:id)
      end

      def self.compute_total_physical_time(resources)
        # Implement the logic to compute total physical time
        Entity::Physical.compute_minimum_time(resources)
      end

      def self.compute_total_online_time(resources)
        # Implement the logic to compute total online time
        Entity::Online.compute_minimum_time(resources)
      end

      def self.compute_minimum_time(resources)
        total_physical_time = compute_total_physical_time(resources)
        total_online_time = compute_total_online_time(resources)

        total_physical_time + total_online_time
      end
    end
  end
end

# skill = RoutePlanner::Entity::Skill.new(skill_name: 'Ruby', challenge_level: 30)
# puts skill.skill_name
# puts skill.challenge_level
