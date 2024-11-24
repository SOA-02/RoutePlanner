# frozen_string_literal: true

module RoutePlanner
  module Entity
    # Domain entity for map
    class Map < Dry::Struct
      include Dry.Types()

      attribute :id, Integer.optional
      attribute :map_name, Strict::String
      attribute :map_description, Strict::String
      attribute :map_evaluation, Strict::Hash
      attribute :map_ai, Strict::String
    end
  end
end
