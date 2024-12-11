# frozen_string_literal: true

require 'http'

module RoutePlanner
  module Gateway
    # Infrastructure to call CodePraise API
    class Api
      def initialize(config)
        @config = config
        @request = Request.new(@config)
      end

      def alive?
        @request.get_root.success?
      end

      def projects_list(list)
        @request.projects_list(list)
      end

      def add_map(syllabus_title, syllabus_text)
        @request.add_map(syllabus_title, syllabus_text)
      end

      def fetch_anaylze_result(skills)
        @request.fetch_anaylze_result(skills)
      end

      # Gets appraisal of a project folder rom API
      # - req: ProjectRequestPath
      #        with #owner_name, #project_name, #folder_name, #project_fullname
      def appraise(req)
        @request.get_appraisal(req)
      end

      # HTTP request transmitter
      class Request
        def initialize(config)
          @api_host = config.API_HOST
          @api_root = config.API_HOST + '/api/v1'
        end

        def get_root # rubocop:disable Naming/AccessorMethodName
          call_api('get')
        end

        def add_map(syllabus_title, syllabus_text)
          body = { syllabus_title: syllabus_title, syllabus_text: syllabus_text }.to_json
          call_api('post', ['maps'], {}, body)
        end

        def fetch_anaylze_result(skills)
          body = skills.to_json
          binding.irb
          call_api('post', ['RoutePlanner'], {}, body)
        end

        private


        def call_api(method, resources = [], params = {},body = nil)
        api_path = resources.empty? ? @api_host : @api_root
        url = [api_path, resources].flatten.join('/')
        binding.irb
        headers = {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json; charset=utf-8' # 加入 charset=utf-8
        }
      
        # 傳送請求時檢查 body 是否存在並使用 JSON 格式
        response = HTTP.headers(headers)
                       .send(method, url, body: body) # 傳送原始 JSON 字串作為 body
        
        Response.new(response)
        rescue StandardError
          raise "Invalid URL request: #{url}"
        end
      end

      # Decorates HTTP responses with success/error
      class Response < SimpleDelegator
        NotFound = Class.new(StandardError)

        SUCCESS_CODES = 200..299

        def success?
          code.between?(SUCCESS_CODES.first, SUCCESS_CODES.last)
        end

        def failure?
          !success?
        end

        def ok?
          code == 200
        end

        def added?
          code == 201
        end

        def processing?
          code == 202
        end

        def message
          JSON.parse(payload)['message']
        end

        def payload
          body.to_s
        end
      end
    end
  end
end