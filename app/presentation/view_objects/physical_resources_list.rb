# frozen_string_literal: true

require_relative 'physical_resource'

module Views
  # View for a a list of video entities
  class PhyicalResourcesList
    def initialize(physical_resources)
      @physical_resources = physical_resources.map.with_index { |vid, i| PhyicalResource.new(vid, i) }
    end

    def each(&show)
      @physical_resources.each do |vid|
        show.call vid
      end
    end

    def any?
      @physical_resources.any?
    end
  end
end
