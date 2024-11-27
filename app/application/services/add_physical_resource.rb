# frozen_string_literal: true

require 'dry/monads'

module RoutePlanner
  module Service
    # logic of fetching viewed resources
    class AddPhysicalResource
      include Dry::Monads::Result::Mixin
      MSG_PHYSICAL_RESOURCE_NOT_FOUND = 'Could not find any physical resource in NTHUSA.'
      MSG_SERVER_ERROR = 'An unexpected error occurred on the server. Please try again later.'
      MSG_PHYSICAL_RESOURCE_SAVE_SUCCESS = 'Physical resource saved successfully.'
      MSG_PHYSICAL_RESOURCE_SAVE_FAIL = 'Physical resource could not be saved.'

      def call(skill) # rubocop:disable Metrics/MethodLength
        physical_resources = physical_resource_in_database(skill)
        if physical_resources == []
          physical_resources = physical_resource_from_nthusa(skill)
          physical_resources.each do |entity|
            result = physical_resource_find_course_id(entity.course_id)

            store_physical_resource(entity) if result.nil?
          end
        end
        Success(MSG_PHYSICAL_RESOURCE_SAVE_SUCCESS)
      rescue StandardError
        Failure(MSG_SERVER_ERROR)
        puts 'Could not access database'
      end

      def physical_resource_in_database(skill)
        Repository::For.klass(Entity::Physical).find_all_resource_of_skills(skill)
      end

      def physical_resource_from_nthusa(input)
        Nthusa::PhysicalRecommendMapper.new.find(input)
      rescue StandardError => e
        LOGGER.error("Error in phyiscal_resource_from_nthusa: #{e.message}")
        Failure(MSG_PHYSICAL_RESOURCE_NOT_FOUND)
      end

      def physical_resource_find_course_id(course_id)
        Repository::For.klass(Entity::Physical).find_id(course_id)
      end

      def store_physical_resource(entity)
        Repository::For.entity(entity).build_physical_resource(entity)
      rescue StandardError => e
        LOGGER.error("Error - #{e.message}")
        Failure(MSG_PHYSICAL_RESOURCE_SAVE_FAIL)
      end
    end
  end
end
