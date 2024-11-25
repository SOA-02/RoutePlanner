# frozen_string_literal: true

require_relative 'roadmap'

module Views
  # View for a a list of video entities
  class RoadmapsList
    def initialize(roadmaps)
      @roadmaps = roadmaps.map.with_index { |vid, i| Roadmap.new(vid, i) }
    end

    def each(&show)
      @roadmaps.each do |vid|
        show.call vid
      end
    end

    def any?
      @roadmaps.any?
    end
  end
end