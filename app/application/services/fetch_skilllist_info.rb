# frozen_string_literal: true

require 'dry/transaction'

module RoutePlanner
  module Service
    # Transaction to fetch skill list information
    class FetchSkillListInfo
      include Dry::Transaction
      MSG_MAP_NOT_FOUND = 'Sorry, could not find that map information.'
      MSG_MAPSKILL_NOT_FOUND = 'Sorry, could not find that map skill information.'
      MSG_SKILL_NOT_FOUND = 'Sorry, could not find that skill information.'
      MSG_SERVER_ERROR = 'An unexpected error occurred on the server. Please try again later.'

      step :find_map_id
      step :fetch_skilllist

      private

      # Step 1: Find the map ID based on the map name
      def find_map_id(map_name)
        map_id = fetch_map_id(map_name)
        find_by_map_id = fetch_skill_id(map_id)

        Success(find_by_map_id)
      rescue StandardError
        Failure(MSG_SERVER_ERROR)
      end

      # Step 2: Fetch the skill list based on the map ID
      def fetch_skilllist(find_by_map_id)
        skilllist = find_by_map_id.flat_map { |skill_id| Array(fetch_skill(skill_id)) }
        Success(skilllist)
      rescue StandardError
        Failure(MSG_SERVER_ERROR)
      end

      # Helper methods
      def fetch_map_id(map_name)
        Repository::For.klass(Entity::Map).find_mapid(map_name)
      rescue StandardError
        Failure(MSG_MAP_NOT_FOUND)
      end

      def fetch_skill_id(map_id)
        Repository::For.klass(RoutePlanner::Entity::MapSkill).find_by_mapid(map_id)
      rescue StandardError
        Failure(MSG_MAPSKILL_NOT_FOUND)
      end

      def fetch_skill(skill_id)
        Repository::For.klass(Entity::Skill).find_skillid(skill_id)
      rescue StandardError
        Failure(MSG_SKILL_NOT_FOUND)
      end
    end
  end
end
