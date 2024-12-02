# frozen_string_literal: true

module RoutePlanner
  module Value
    # Calculate time spent on resources
    class ResourceTimeCalculator
      def self.compute_online_resource(online_video_duration)
        total_hours = online_video_duration.sum do |video_duration|
          Entity::Online.iso8601_duration_to_hours(video_duration)
        end
        total_hours.ceil
      end

      def self.compute_total_online_time(resources)
        online_video_duration = resources.flat_map { |resource| resource[:online_resources].map(&:video_duration) }
        compute_online_resource(online_video_duration)
      end

      def self.compute_physical_time(physical_credits)
        physical_credits.map { |credit| Entity::Physical.minimum_time_required(credit) }.sum
      end

      def self.compute_total_physical_time(resources)
        physical_credits = resources.flat_map { |resource| resource[:physical_resources].map(&:credit) }
        compute_physical_time(physical_credits)
      end

      def self.compute_minimum_time(resources)
        total_physical_time = compute_total_physical_time(resources)
        total_online_time = compute_total_online_time(resources)

        total_physical_time + total_online_time
      end

    end
  end
end
