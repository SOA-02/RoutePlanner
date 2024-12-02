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
      attribute :video_duration, String.optional
      attribute :for_skill, Strict::String

      def to_attr_hash
        to_hash.except(:id)
      end

      def self.iso8601_duration_to_hours(video_duration)
        match = /PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?/.match(video_duration)
        hours = match[1].to_i
        minutes = match[2].to_i / 60.0
        seconds = match[3].to_i / 3600.0
        hours + minutes + seconds
      end
    end
  end
end
