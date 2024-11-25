# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module RoutePlanner
  module Entity
    # Domain entity for team members
    class Youtubevideo < Dry::Struct
      include Dry.Types

      attribute :id, Integer.optional
      attribute :video_id, Strict::String
      attribute :video_duration, Strict::String

    end
  end
end
