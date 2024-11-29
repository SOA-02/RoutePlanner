# frozen_string_literal: true

require 'dry/monads'

module RoutePlanner
  module Service
    # logic of fetching viewed resources
    class FetchViewedRoadmap
      include Dry::Monads::Result::Mixin

      def call(_resource_list)
        resources = Repository::For.klass(Entity::Map).all

        Success(resources)
      rescue StandardError
        Failure(MSG_SERVER_ERROR)
        puts 'Could not access database'
      end
    end
  end
end
