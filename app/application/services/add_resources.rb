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

      def call(online_skill:, physical_skill:) # rubocop:disable Metrics/MethodLength
        online_result = @online_service.call(online_skill)
        physical_result = @physical_service.call(physical_skill)
        failures = [online_result, physical_result].compact.select(&:failure?)

        if failures.any?
          partial_results = {
            online_resources: online_result.success? ? online_result.value! : nil,
            physical_resources: physical_result.success? ? physical_result.value! : nil
          }

          return Success(partial_results) if online_result.success? || physical_result.success?

          return Failure(
            message: failures.map(&:failure).join(', '),
            partial_results: partial_results
          )
        end

        Success(
          online_resources: online_result.success? ? online_result.value! : nil,
          physical_resources: physical_result.success? ? physical_result.value! : nil
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
