# frozen_string_literal: true

require 'sequel'

module RoutePlanner
  module Database
    # Object Relational Mapper for Online Entities
    class PhysicalOrm < Sequel::Model(:physicals)
      one_to_many :routeplanners,
                  key: :resource_id,
                  class: :'RoutePlanner::Database::RouteplannerOrm',
                  conditions: { resource_type: 'Physical' }

      plugin :timestamps, update_on_create: true
    end
  end
end
