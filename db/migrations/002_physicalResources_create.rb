# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:physicals) do
      primary_key :id

      String :course_id, unique: true
      String :course_name
      String :credit
      String :language
      String :provider
      String :timeloc

      DateTime :created_at
      DateTime :updated_at
      index :id
    end
  end
end
