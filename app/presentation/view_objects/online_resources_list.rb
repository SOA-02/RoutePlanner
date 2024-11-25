# frozen_string_literal: true

require_relative 'online_resource'

module Views
  # View for a a list of video entities
  class OnlineResourceList
    def initialize(online_resources)
      @online_resources = online_resources.map.with_index { |vid, i| OnlineResource.new(vid, i) }
    end

    def each(&show)
      @online_resources.each do |vid|
        show.call vid
      end
    end

    def any?
      @online_resources.any?
    end
  end
end
