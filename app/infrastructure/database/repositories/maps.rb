# frozen_string_literal: true

module RoutePlanner
  module Repository
    # Repository for Skills
    class Maps
      def self.all
        Database::MapOrm.all.map { |db_resource| rebuild_entity(db_resource) }
      end

      def self.find_mapid(map_name)
        map = Database::MapOrm.where(map_name:).select(:id).first
        map.id
      end

      def self.find_id(id)
        db_resource = Database::MapOrm.first(id:)
        rebuild_entity(db_resource)
      end

      def self.find_by_mapname(map_name)
        db_resource = Database::MapOrm.where(map_name:).first
        rebuild_entity(db_resource)
      end

      def self.build_map(entity)
        db_resource = Database::MapOrm.create(entity.to_attr_hash)
        rebuild_entity(db_resource)
      end

      def self.rebuild_entity(db_resource)
        return nil unless db_resource

        Entity::Map.new(
          id: db_resource.id,
          map_name: db_resource.map_name,
          map_description: db_resource.map_description,
          map_evaluation: db_resource.map_evaluation,
          map_ai: db_resource.map_ai
        )
      end

      def initialize(entity)
        @entity = entity
      end
    end
  end
end
