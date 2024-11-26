# frozen_string_literal: true

require 'dry/monads'

module RoutePlanner
  module Service
    class AddResources
      include Dry::Monads::Result::Mixin

      def initialize(online_service: default_online_service, physical_service: default_physical_service)
        @online_service = online_service
        @physical_service = physical_service
      end

      def call(key_word:, pre_req:)
        results = [
          @online_service.call(key_word),
          @physical_service.call(pre_req)
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
