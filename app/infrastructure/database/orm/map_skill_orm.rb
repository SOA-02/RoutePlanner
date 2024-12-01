# app/infrastructure/database/orms/map_skill_orm.rb
require 'sequel'

module RoutePlanner
  module Database
    # Object Relational Mapper for MapSkills
    class MapSkillOrm < Sequel::Model(:map_skills)
      many_to_one :map,
                  class: :'RoutePlanner::Database::MapOrm',
                  key: :map_id

      many_to_one :skill,
                  class: :'RoutePlanner::Database::SkillOrm',
                  key: :skill_id

      plugin :timestamps, update_on_create: true
    end
  end
end
