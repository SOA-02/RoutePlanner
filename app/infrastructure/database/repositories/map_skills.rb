# frozen_string_literal: true

module RoutePlanner
  module Repository
    class MapSkills # rubocop:disable Style/Documentation
      def self.find_by_map_id(map_id)
        db_resources = Database::MapSkillsOrm.where(map_id:map_id).select(:skill_id).all
        db_resources.map { |db_resource| db_resource[:skill_id] }
      end

      def self.add_map_skill(map_id, skill_id)
        Database::MapSkillsOrm.create(map_id: map_id, skill_id: skill_id)
      end

      def self.rebuild_entity(db_resource)
        return nil unless db_resource

        Entity::MapSkill.new(
          id: db_resource.id,
          map_id: db_resource.map_id,
          skill_id: db_resource.skill_id
        )
      end

      def initialize(entity)
        @entity = entity
      end
    end
  end
end
