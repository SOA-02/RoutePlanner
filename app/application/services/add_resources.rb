# frozen_string_literal: true

require 'dry/monads'

module RoutePlanner
  module Service
    # The AddResources class is responsible for managing and adding resources
    # within the RoutePlanner service. It is composed of two services, AddOnlineResource and AddPhysicalResource.
    class AddResources
      include Dry::Monads::Result::Mixin

      def initialize(online_service: default_online_service, physical_service: default_physical_service)
        @online_service = online_service
        @physical_service = physical_service
      end

      def call(online_skill:, physical_skill:)
        results = [
          @online_service.call(online_skill),
          @physical_service.call(physical_skill)
        ]

        failures = results.compact.select(&:failure?)
        return Failure(failures.map(&:failure).join(', ')) if failures.any?

        Success(
          online_resources: results[0].value!,
          physical_resources: results[1].value!
        )
      end

      private

      def default_online_service
        @default_online_service ||= Service::AddOnlineResource.new
      end

      def default_physical_service
        @default_physical_service ||= Service::AddPhysicalResource.new
      end
    end
  end
end
