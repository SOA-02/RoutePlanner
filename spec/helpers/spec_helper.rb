# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'
require 'minitest/autorun'
require 'minitest/unit'
require 'minitest/rg'

require_relative '../../require_app'

require_app

VIDEO_ID = 'xiWUL3M9D8c'
SKILL = 'Analytic'
SYLLABUS = File.read(File.expand_path('../fixtures/syllabus_example.txt', __dir__))
TITLE = 'Business Analytics using Machine Learning'
SKILL = {
  'Business Analytics Using Forecasting (BAFT)_skills' => {
    'Regression Analysis'     => '60',
    'Time Series Analysis'    => '40',
    'Data Visualization'      => '20',
    'Business Analytics'      => '1',
    'Statistical Forecasting' => '80'
  }
}.freeze
