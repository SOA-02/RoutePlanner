# frozen_string_literal: true

require 'rake/testtask'
require_relative 'require_app'
task :default do
  puts `rake -T`
end

desc 'Run the unit and integration tests'
task spec: ['spec:default']

namespace :spec do
  desc 'Run unit and integration tests'
  Rake::TestTask.new(:default) do |t|
    t.pattern = 'spec/tests/{integration,unit}/**/*_spec.rb'
    t.warning = false
  end

  # NOTE: make sure you have run `rake run:test` in another process
  desc 'Run acceptance tests'
  Rake::TestTask.new(:acceptance) do |t|
    t.pattern = 'spec/tests/acceptance/*_spec.rb'
    t.warning = false
  end

  desc 'Run unit, integration, and acceptance tests'
  Rake::TestTask.new(:all) do |t|
    t.pattern = 'spec/tests/**/*_spec.rb'
    t.warning = false
  end
end

desc 'Keep rerunning unit/integration tests upon changes'
task :respec do
  sh "rerun -c 'rake spec' --ignore 'coverage/*' --ignore 'repostore/*'"
end

desc 'Run web app in default mode'
task run: ['run:default']

namespace :run do
  desc 'Run web app in development or production'
  task :default do
    sh 'bundle exec puma'
  end

  desc 'Run web app for acceptance tests'
  task :test do
    sh 'RACK_ENV=test puma -p 9000'
  end
end

desc 'Keep rerunning web app upon changes'
task :rerun do
  sh "rerun -c --ignore 'coverage/*' --ignore 'repostore/*' -- bundle exec puma"
end

desc 'Generates a 64-byte secret for Rack::Session'
task :new_session_secret do
  require 'base64'
  require 'securerandom' # Corrected capitalization here
  secret = SecureRandom.random_bytes(64).then { Base64.urlsafe_encode64(_1) }
  puts "SESSION_SECRET: #{secret}"
end

desc 'Run application console'
task :console do
  sh 'pry -r ./load_all'
end

namespace :vcr do
  desc 'delete cassette fixtures'
  task :wipe do
    sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
      puts(ok ? 'Cassettes deleted' : 'No cassettes found')
    end
  end
end

namespace :quality do
  only_app = 'config/ app/'

  desc 'run all static-analysis quality checks'
  task all: %i[rubocop reek flog]

  desc 'code style linter'
  task :rubocop do
    sh 'rubocop'
  end

  desc 'code smell detector'
  task :reek do
    sh 'reek'
  end

  desc 'complexiy analysis'
  task :flog do
    sh "flog -m #{only_app}"
  end
end
