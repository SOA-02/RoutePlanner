# frozen_string_literal: true

module Views
  # View for a single map entity
  class Map
    def initialize(map)
      @map = map
    end

    def entity
      @map
    end

    def index_str
      "map[#{@index}]"
    end

    def map_name
      @map.map_name
    end

    def map_description
      @map.map_description
    end

    def map_evaluation
      @map.map_evaluation
    end

    def map_ai
      @map.map_ai
    end
  end
end
