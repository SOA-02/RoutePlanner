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

      def self.compute_minimum_time(resources)
        online_video_duration = resources.flat_map { |resource| resource[:online_resources].map(&:video_duration) }
        compute_online_resource(online_video_duration)
      end

      def self.compute_online_resource(online_video_duration)
        total_hours = online_video_duration.sum do |video_duration|
          Mixins::DurationConverter.iso8601_duration_to_hours(video_duration)
        end
        total_hours.ceil
      end
      # def self.iso8601_duration_to_hours(video_duration)
      #   match = /PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?/.match(video_duration)
      #   return 0 unless match

      #   hours = match[1].to_i
      #   minutes = match[2].to_i / 60.0
      #   seconds = match[3].to_i / 3600.0
      #   hours + minutes + seconds
      # end
    end
  end
end
