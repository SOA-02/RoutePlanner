# frozen_string_literal: true

require 'dry/transaction'

module RoutePlanner
  module Service
    # Transaction to fetch anaylze result and retrieve skill insights and resources
    class FethcAnayzleResult
      include Dry::Transaction

      step :request_anayzle
      step :retrieveSkillInsightsAndResources

      def request_anayzle(input)
<<<<<<< HEAD
        result = Gateway::Api.new(RoutePlanner::App.config)
          .fetch_anaylze_result(input)
=======
        # binding.irb
        result = Gateway::Api.new(RoutePlanner::App.config)
          .fetch_anaylze_result(input)
        # binding.irb
>>>>>>> e20a9db (update main)

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot ayayzle right now; please try again later')
      end

      def retrieveSkillInsightsAndResources(response_json)
        Representer::StudyStressOutput.new(OpenStruct.new)
          .from_json(response_json)
          .then { |project| Success(project) }
      rescue StandardError
        Failure('Error in the project -- please try again')
      end
    end
  end
end
