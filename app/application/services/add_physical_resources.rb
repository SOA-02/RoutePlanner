# frozen_string_literal: true

require 'dry/transaction'

module RoutePlanner
  module Service
    # The AddPhysicalResource class is responsible for managing and adding physical resources
    # within the RoutePlanner service.
    class AddPhysicalResource
      include Dry::Transaction
      MSG_PHYSICAL_RESOURCE_NOT_FOUND = 'Could not find any physical resource in NTHUSA.'
      MSG_SERVER_ERROR = 'An unexpected error occurred on the server. Please try again later.'
      MSG_PHYSICAL_RESOURCE_SAVE_SUCCESS = 'Physical resource saved successfully.'
      MSG_PHYSICAL_RESOURCE_SAVE_FAIL = 'Physical resource could not be saved.'

      step :find_physical_resources
      step :store_physical_resources

      private

      # Step 1: Find physical resources
      def find_physical_resources(skill)
        physical_resources = physical_resource_in_database(skill)
        physical_resources = physical_resource_from_nthusa(skill) if physical_resources.empty?
        Success(physical_resources)
      rescue StandardError
        Failure(MSG_SERVER_ERROR)
      end

      # Step 2: Store resources that are not already in the database
      def store_physical_resources(physical_resources)
        physical_resources.each do |entity|
          store_physical_resource(entity) unless physical_resource_find_course_id(entity.course_id)
        end
        Success(MSG_PHYSICAL_RESOURCE_SAVE_SUCCESS)
      rescue StandardError
        Failure(MSG_PHYSICAL_RESOURCE_SAVE_FAIL)
      end

      # Helper methods
      def physical_resource_in_database(skill)
        Repository::For.klass(Entity::Physical).find_all_resource_of_skills(skill)
      end

      def physical_resource_from_nthusa(skill)
        Nthusa::PhysicalRecommendMapper.new.find(skill)
      rescue StandardError => error
        LOGGER.error("Error in phyiscal_resource_from_nthusa: #{error.message}")
        Failure(MSG_PHYSICAL_RESOURCE_NOT_FOUND)
      end

      def physical_resource_find_course_id(course_id)
        Repository::For.klass(Entity::Physical).find_id(course_id)
      end

      def store_physical_resource(entity)
        Repository::For.entity(entity).build_physical_resource(entity)
      rescue StandardError => error
        LOGGER.error("Error - #{error.message}")
        Failure(MSG_PHYSICAL_RESOURCE_SAVE_FAIL)
      end
    end
  end
end
