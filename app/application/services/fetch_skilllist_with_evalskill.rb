# frozen_string_literal: true

require 'dry/monads'

module RoutePlanner
  module Service
    # logic of fetching viewed resources
    class FetchSkillListWithEvalSkill
      include Dry::Monads::Result::Mixin
      MSG_COURSE_NOT_FOUND = 'Could not find any Physical resource'
      MSG_OURSE_NOT_FOUND = 'Sorry, could not find that Physical resource information.'
      MSG_SERVER_ERROR = 'An unexpected error occurred on the server. Please try again later.'

      def call(map_name)
        map_id= fetch_map_id(map_name)
        find_by_map_id = Repository::For.klass(RoutePlanner::Entity::MapSkill).find_by_map_id(map_id)
        b=[]
        find_by_map_id.each do |skill_id|
          result = Repository::For.klass(Entity::Skill).find_skillid(skill_id)
          p result  # 查看返回的結果
          b += result.is_a?(Array) ? result : [result]  # 如果不是陣列，則將其轉為陣列
        end

        Success(b)
      rescue StandardError
        Failure(MSG_SERVER_ERROR)
        puts 'Could not access database'
      end

      def fetch_map_id(map_name)
        Repository::For.klass(RoutePlanner::Entity::Map).find_map(map_name)
      rescue StandardError => e
        LOGGER.error("Error in phyiscal_resource_from_nthusa: Could not find that video on NTHUSA - #{e.message}")
        Failure(MSG_COURSE_NOT_FOUND)
      end

      def fetch_skill_id(map_id)
        Repository::For.klass(RoutePlanner::Entity::MapSkill).find_by_map_id(map_id)
      rescue StandardError => e
        LOGGER.error("Error in physical_resource_from_nthusa: Could not find that video on Youtube - #{e.message}")
        Failure(MSG_OURSE_NOT_FOUND)
      end

      def find_skillid(skill_id)
        Repository::For.klass(RoutePlanner::Entity::MapSkill).find_by_map_id(entity)
      rescue StandardError => e
        LOGGER.error("Error in physical_resource_from_nthusa: Could not find that video on Youtube - #{e.message}")
        Failure(MSG_OURSE_NOT_FOUND)
      end
    end
  end
end
