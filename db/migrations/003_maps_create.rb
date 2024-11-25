# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:maps) do
      primary_key :id

      String :map_name
      String :map_description
      String :map_evaluation
      String :map_ai

      DateTime :created_at
      DateTime :updated_at
      index :id
    end
  end
end
