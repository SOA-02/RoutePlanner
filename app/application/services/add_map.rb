
require 'dry/transaction'

module RoutePlanner
  module Service
    class AddMap
      include Dry::Transaction

      step :find_existing_map

      def find_existing_map(input)
        if (existing_map = map_in_database(input))
          existing_skills = skill_in_database(input)
        end
      end

      def map_in_database(input)
        Repository::For.klass(Entity::Map).find_map_name(input[:syllabus_title])
      end

      def skill_in_database(input)
        Repository::For.klass(Entity::Skill).find_map_skills(input[:syllabus_title])
      end
    end
  end
end