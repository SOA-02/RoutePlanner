# frozen_string_literal: true

require 'dry/monads'

module RoutePlanner
  module Service
    # logic of fetching viewed resources
    class FetchViewedResources
      include Dry::Monads::Result::Mixin
      MSG_SERVER_ERROR = 'An unexpected error occurred on the server. Please try again later.'

      def call(skill)
        resources = {}
        resources[:physical_resources] =
          Repository::For.klass(Entity::Physical).find_all_resource_of_skills(skill) || []
        resources[:online_resources] =
          Repository::For.klass(Entity::Online).find_all_resource_of_skills(skill) || []

        return Success(resources) unless resources[:physical_resources].empty? && resources[:online_resources].empty?

        Failure('No resources found')
      rescue StandardError
        Failure(MSG_SERVER_ERROR)
        puts 'Could not access database'
      end
    end
  end
end
