# frozen_string_literal: true

require 'dry/monads'

module RoutePlanner
  module Service
    # logic of fetching viewed resources
    class AddOnlineResource
      include Dry::Monads::Result::Mixin
      MSG_ONLINE_NOT_FOUND = 'Could not find any Online resource'
      MSG_ONLINEINFO_NOT_FOUND = 'Sorry, could not find that Online resource information.'

      def call(key_word)
        online_resources = online_resource_from_youtube(key_word)
        online_resources.each do |entity|
          result = online_resource_find_original_id(entity.original_id)

          store_online_resource_find_original_id(entity) if result.nil?
        end
        Success(online_resources)
      rescue StandardError
        Failure(MSG_SERVER_ERROR)
        puts 'Could not access database'
      end

      def online_resource_from_youtube(input)
        Youtube::VideoRecommendMapper.new(App.config.API_KEY).find(input)
      rescue StandardError => e
        LOGGER.error("Error in online_resource_from_youtube: Could not find that video on Youtube - #{e.message}")
        Failure(MSG_ONLINE_NOT_FOUND)
      end

      def online_resource_find_original_id(original_id)
        Repository::For.klass(RoutePlanner::Entity::Online).find_original_id(original_id)
      rescue StandardError => e
        LOGGER.error("Error in online_resource_from_youtube: Could not find that video on Youtube - #{e.message}")
        Failure(MSG_ONLINE_NOT_FOUND)
      end

      def store_online_resource_find_original_id(entity)
        Repository::For.entity(entity).build_online_resource(entity)
      rescue StandardError => e
        LOGGER.error("Error in online_resource_from_youtube: Could not find that video on Youtube - #{e.message}")
        Failure(MSG_ONLINE_NOT_FOUND)
      end
    end
  end
end
