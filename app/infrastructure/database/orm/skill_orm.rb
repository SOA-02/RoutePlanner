# frozen_string_literal: true

require 'sequel'

module RoutePlanner
  module Database
    # Object Relational Mapper for Maps
    class SkillOrm < Sequel::Model(:skills)
      # one_to_many :routeplanners,
      #             class: :'RoutePlanner::Database::RoutePlannerOrm'
      plugin :timestamps, update_on_create: true
    end
  end
end
