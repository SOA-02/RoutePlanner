# frozen_string_literal: true

module RoutePlanner
  module Entity
    # Domain entity for team members
    class Planner
      
      # 
      def rank_resource_prompt
        [
          'Rank the importance of the learning resources according to the user needs'
        ]
      end
    end
  end
end
