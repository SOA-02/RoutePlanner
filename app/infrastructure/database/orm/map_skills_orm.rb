# frozen_string_literal: true

require 'sequel'

module RoutePlanner
  module Database
    # Object Relational Mapper for Maps_Skills
    class MapSkillsOrm < Sequel::Model(:map_skills)
      many_to_one :maps, class: :'RoutePlanner::Database::MapOrm', key: :map_id
      many_to_one :skills, class: :'RoutePlanner::Database::SkillOrm', key: :skill_id
      
      plugin :timestamps, update_on_create: true
    end
  end
end

