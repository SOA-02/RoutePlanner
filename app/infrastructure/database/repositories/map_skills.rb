# frozen_string_literal: true

module RoutePlanner
  module Repository
    # Repository for Join Map and Skills
    class MapSkills
      def self.join_map_skill(map_entity, skillset_entity)
        db_map = Database::MapOrm.db_find_or_create(map_entity.to_attr_hash)
        
        skillset_entity.each do |skill|
          db_skill = Database::SkillOrm.db_find_or_create(skill.to_attr_hash)
          db_map.add_skill(db_skill)
        end
        db_map
      end
    end
  end
end
