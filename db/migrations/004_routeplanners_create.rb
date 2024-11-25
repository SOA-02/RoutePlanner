# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:routeplanners) do
      primary_key :id
      foreign_key :map_id, :maps, null: false
      Integer :resource_id, null: false # e.g., 'physical_id' or 'online_id'
      String :resource_type, null: false, size: 30 # e.g., 'Physical' or 'Online'

      DateTime :created_at
      DateTime :updated_at
      index :id
    end
  end
end
