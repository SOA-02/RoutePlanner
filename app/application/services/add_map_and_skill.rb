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

        # binding.irb
        input[:response] = Gateway::Api.new(RoutePlanner::App.config)
          .add_map(syllabus_title, syllabus_text)
        # binding.irb
        input[:response].success? ? Success(input) : Failure('Cannot analyze right now')
      rescue StandardError
        Failure('Cannot analyze right now; please try again later')
      end

      def reify_mapandskill(input)
        unless input[:response].processing?
          Representer::AddMapandSkill.new(OpenStruct.new) # rubocop:disable Style/OpenStructUse
            .from_json(input[:response].payload).then do |project|
              input[:data] = project
              Success(input)
            end
        end
        Success(input)
      rescue StandardError
        Failure('Error in the analysis -- please try again')
      end
    end
  end
end
