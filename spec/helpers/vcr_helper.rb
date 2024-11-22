# frozen_string_literal: true

require 'vcr'
require 'webmock'

# Setting up VCR
module VcrHelper
  CASSETTES_FOLDER = 'spec/fixtures/cassettes'
  YOUTUBE_CASSETTE = 'youtube_api'
  OPENAI_CASSETTE = 'openai_api'

  def self.setup_vcr
    VCR.configure do |c|
      c.cassette_library_dir = CASSETTES_FOLDER
      c.hook_into :webmock
    end
  end

  def self.configure_vcr_for_youtube
    VCR.configure do |c|
      c.filter_sensitive_data('<API_KEY>') { API_KEY }
      c.filter_sensitive_data('<API_KEY_ESC>') { CGI.escape(API_KEY) }
    end

    VCR.insert_cassette(
      YOUTUBE_CASSETTE,
      record: :new_episodes,
      match_requests_on: %i[method uri headers]
    )
  end

  def self.configure_vcr_for_openai
    VCR.configure do |c|
      c.filter_sensitive_data('<OPENAI_KEY>') { OPENAI_KEY}
      c.filter_sensitive_data('<OPENAI_KEY_ESC>') { CGI.escape(OPENAI_KEY) }
    end

    VCR.insert_cassette(
      OPENAI_CASSETTE,
      record: :new_episodes,
      match_requests_on: %i[method uri headers]
    )
  end

  def self.eject_vcr
    VCR.eject_cassette
  end
end
