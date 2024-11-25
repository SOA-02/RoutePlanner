# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module RoutePlanner
  module Entity
    # Domain entity for team members
    class Physical < Dry::Struct
      include Dry.Types

      attribute :id, Integer.optional
      attribute :course_id, Strict::String
      attribute :course_name, Strict::String
      attribute :credit, Strict::String
      attribute :language, Strict::String
      attribute :provider, Strict::String
      attribute :timeloc, Strict::String

      def to_attr_hash
        to_hash.except(:id)
      end
    end
  end
end
