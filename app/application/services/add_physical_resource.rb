# frozen_string_literal: true

require 'dry/monads'

module RoutePlanner
  module Service
    # logic of fetching viewed resources
    class AddPhysicalResource
      include Dry::Monads::Result::Mixin
      MSG_COURSE_NOT_FOUND = 'Could not find any Physical resource'
      MSG_OURSE_NOT_FOUND = 'Sorry, could not find that Physical resource information.'
      MSG_SERVER_ERROR = 'An unexpected error occurred on the server. Please try again later.'

      def call(key_word)
        physical_resources = physical_resource_from_nthusa(key_word)
        physical_resources.each do |entity|
          result = physical_resource_find_course_id(entity.course_id)

          store_physical_resource(entity) if result.nil?
        end
        Success(physical_resources)
      rescue StandardError
        Failure(MSG_SERVER_ERROR)
        puts 'Could not access database'
      end

      def physical_resource_from_nthusa(input)
        Nthusa::PhysicalRecommendMapper.new.find(input)
      rescue StandardError => e
        LOGGER.error("Error in phyiscal_resource_from_nthusa: Could not find that video on NTHUSA - #{e.message}")
        Failure(MSG_COURSE_NOT_FOUND)
      end

      def physical_resource_find_course_id(course_id)
        Repository::For.klass(Entity::Physical).find_id(course_id)
      rescue StandardError => e
        LOGGER.error("Error in physical_resource_from_nthusa: Could not find that video on Youtube - #{e.message}")
        Failure(MSG_OURSE_NOT_FOUND)
      end

      def store_physical_resource(entity)
        Repository::For.entity(entity).build_physical_resource(entity)
      rescue StandardError => e
        LOGGER.error("Error in physical_resource_from_nthusa: Could not find that video on Youtube - #{e.message}")
        Failure(MSG_OURSE_NOT_FOUND)
      end
    end
  end
end
