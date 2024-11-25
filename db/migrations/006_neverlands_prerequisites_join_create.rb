# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:neverlands_prerequisites) do
      primary_key :id
      foreign_key :neverland_id, :neverlands
      foreign_key :prerequisite_id, :prerequisites

      DateTime :created_at
      DateTime :updated_at
      index :id
    end
  end
end
