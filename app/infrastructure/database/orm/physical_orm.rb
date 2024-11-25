# frozen_string_literal: true

require 'sequel'

module RoutePlanner
  module Database
    # Object Relational Mapper for Online Entities
    class PhysicalOrm < Sequel::Model(:physicals)
<<<<<<< HEAD
      # many_to_one :channel,
      #             class: :'RoutePlanner::Database::ChannelOrm'
=======
      one_to_many :routeplanners,
                  key: :resource_id,
                  class: :'RoutePlanner::Database::RouteplannerOrm',
                  conditions: { resource_type: 'Physical' }

>>>>>>> main

      plugin :timestamps, update_on_create: true
    end
  end
end
