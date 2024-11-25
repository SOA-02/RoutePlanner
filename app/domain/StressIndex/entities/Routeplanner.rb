# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module RoutePlanner
  module Entity
    # Domain entity for team members
    class Routeplanner < Dry::Struct
      include Dry.Types

      attribute :id, Integer.optional
      attribute :neverland_id, Integer
      attribute :resource_id, Integer
      attribute :resource_type, Integer

      def to_attr_hash
        to_hash.except(:id)
      end
    end
  end
end
