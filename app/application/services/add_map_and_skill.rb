# frozen_string_literal: true

require 'dry/transaction'

module RoutePlanner
  module Service
    # The AddMapandSkill class is responsible for managing and adding maps and skills
    class AddMapandSkill
      include Dry::Transaction

      step :request_map
      step :reify_mapandskill

      def request_map(input)
        syllabus_title = input[:syllabus_title]
        syllabus_text = input[:syllabus_text]
        result = Gateway::Api.new(RoutePlanner::App.config)
          .add_map(syllabus_title, syllabus_text)

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot ayazle right now; please try again later')
      end

      def reify_mapandskill(response_json)
        Representer::AddMapandSkill.new(OpenStruct.new)
          .from_json(response_json)
          .then { |project| Success(project) }
      rescue StandardError
        Failure('Error in the project -- please try again')
      end
    end
  end
end
