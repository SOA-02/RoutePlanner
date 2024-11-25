# frozen_string_literal: true

require 'sequel'

module RoutePlanner
  module Database
    # Object Relational Mapper for Online Entities
    class PrerequisiteOrm < Sequel::Model(:prerequisites)
      # many_to_one :channel,
      #             class: :'RoutePlanner::Database::ChannelOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
