# frozen_string_literal: true

require 'sequel'

module RoutePlanner
  module Database
    # Object Relational Mapper for Routeplanner
    class RouteplannerOrm < Sequel::Model(:routeplanners)
      many_to_one :neverland,
                  class: :'RoutePlanner::Database::NeverlandOrm'

      def resource
        case resource_type
        when 'Physical'
          PhysicalOrm[resource_id]
        when 'Online'
          OnlineOrm[resource_id]
        end
      end

      plugin :timestamps, update_on_create: true
    end
  end
end
