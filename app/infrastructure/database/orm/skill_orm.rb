# frozen_string_literal: true

require 'sequel'

module RoutePlanner
  module Database
    # Object Relational Mapper for Maps
    class SkillOrm < Sequel::Model(:skills)
      one_to_many :map_skills,
                  class: :'RoutePlanner::Database::MapSkillOrm',
                  key: :skill_id

      many_to_many :maps,
                   class: :'RoutePlanner::Database::MapOrm',
                   join_table: :map_skills,
                   left_key: :skill_id, right_key: :map_id
      plugin :timestamps, update_on_create: true

      def self.db_find_or_create(skill)
        first(skill_name: skill[:skill_name]) || create(skill)
      end
    end
  end
end
