# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module RoutePlanner
  module Entity
    # Domain entity for team members
    class Online < Dry::Struct
      include Dry.Types

      attribute :id, Integer.optional
      attribute :original_id, String.optional
      attribute :topic, Strict::String
      attribute :url, Strict::String
      attribute :platform, Strict::String

      def to_attr_hash
        to_hash.except(:id)
      end
    end
  end
end
