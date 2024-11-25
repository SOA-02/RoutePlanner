# frozen_string_literal: true

module Views
  # View for a single physical_resources entity
  class PhyicalResources
    def initialize(physical_resources, index = nil)
      @physical_resources = physical_resources
      @index = index
    end

    def entity
      @physical_resources
    end

    def index_str
      "physical_resources[#{@index}]"
    end

    def course_id
      @physical_resources.course_id
    end

    def course_name
      @physical_resources.course_name
    end

    def credit
      @physical_resources.credit
    end

    def language
      @physical_resources.language
    end

    def provider
      @physical_resources.provider
    end

    def timeloc
      @physical_resources.timeloc
    end

    def for_skill
      @physical_resources.for_skill
    end
  end
end
