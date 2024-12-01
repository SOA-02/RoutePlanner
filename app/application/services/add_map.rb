
require 'dry/transaction'

module RoutePlanner
  module Service
    class AddMap
      include Dry::Transaction

      step :validate
      step :find_existing_map
      step :create_entities
      step :store_entities

      def validate(input)
        if input[:syllabus_title] && input[:syllabus_text]
          Success(input)
        else
          Failure('Missing title and text')
        end
      end

      def find_existing_map(input)
        existing_map = Repository::For.klass(Entity::Map)
          .find_map_name(input[:syllabus_title])
        if existing_map
          existing_skills = Repository::For.klass(Entity::Map)
            .find_map_skills(input[:syllabus_title])
          Success(map: existing_map, skills: existing_skills)
        else
          Success(input)
        end
      end

      def create_entities(input)
        return Success(input) if input[:map]

        map = OpenAPI::MapMapper
          .new(input[:syllabus_text], App.config.OPENAI_KEY)
          .call

        skillset = OpenAPI::SkillMapper
          .new(input[:syllabus_text], App.config.OPENAI_KEY)
          .call

        Success(input.merge(map: map, skills: skillset))
      rescue StandardError => e
        Failure("Error creating entities: #{e.message}")
      end

      def store_entities(input)
        return Success(input) if input[:map].id

        db_map = Repository::MapSkills.join_map_skill(input[:map], input[:skills])

        Success(map: db_map, skills: db_map.skills)
      rescue StandardError => e
        Failure("Error storing entities: #{e.message}")
      end
    end
  end
end