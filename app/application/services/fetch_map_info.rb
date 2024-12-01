# frozen_string_literal: true

require 'dry/monads'

module RoutePlanner
  module Service
    # logic of fetching viewed map
    class FetchMapInfo
      include Dry::Monads::Result::Mixin
      MSG_SERVER_ERROR = 'An unexpected error occurred on the server. Please try again later.'

      def call(map_name)
        map = Repository::For.klass(Entity::Map).find_by_mapname(map_name)

        Success(map)
      rescue StandardError
        Failure(MSG_SERVER_ERROR)
        puts 'Could not access database'
      end
    end
  end
end
