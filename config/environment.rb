# frozen_string_literal: true

require 'figaro'
require 'rack/session'
require 'roda'
require 'yaml'

module RoutePlanner
  # Configuration for the App
  class App < Roda
    plugin :environments

    # Environment variables setup
    Figaro.application = Figaro::Application.new(
      environment:,
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config = Figaro.env

    use Rack::Session::Cookie, secret: config.SESSION_SECRET
  end
end
