# frozen_string_literal: true

require 'sequel'

module RoutePlanner
  module Database
    # Object Relational Mapper for Online Entities
    class NeverlandOrm < Sequel::Model(:neverlands)
      one_to_many :routeplanners,
                  class: :'RoutePlanner::Database::RouteplannerOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
