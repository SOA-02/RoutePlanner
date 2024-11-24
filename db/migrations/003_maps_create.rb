# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:maps) do
      primary_key :id

      String :course_name
      String :course_description
      String :course_evaluation
      String :AI_use_policy

      DateTime :created_at
      DateTime :updated_at
      index :id
    end
  end
end
