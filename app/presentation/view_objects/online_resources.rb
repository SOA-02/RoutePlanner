# frozen_string_literal: true

module Views
  # View for a single online_resource entity
  class OnlineResources
    def initialize(online_resource, index = nil)
      @online_resource = online_resource
      @index = index
    end

    def entity
      @online_resource
    end

    def index_str
      "online_resource[#{@index}]"
    end

    def original_id
      @online_resource.original_id
    end

    def topic
      @online_resource.topic
    end

    def url
      @online_resource.url
    end

    def platform
      @online_resource.platform
    end

    def for_skill
      @online_resource.for_skill
    end
  end
end
