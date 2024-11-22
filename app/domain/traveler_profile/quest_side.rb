# frozen_string_literal: true

module RoutePlanner
  module Entity
    # Domain entity for team members
    class SideQuest
      attr_reader :skill, :location_name, :governer, :coordinates, :distance

      def initialize(skill:, location_name:, governer:, coordinates:, distance:)
        @skill = skill
        @location_name = location_name
        @governer = governer
        @coordinates = coordinates
        @distance = distance
      end

      def side_quest_prompt
        [
          'suggests 3 important prerequisites keywords suitable for the syllabus in json format'
        ]
      end

      def side_quest_time
        return 'long' if distance * 16 > 48
        return 'medium' if distance * 16 > 32

        'short'
      end
    end
  end
end
