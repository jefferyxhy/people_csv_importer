# frozen_string_literal: true

class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.index :name, unique: true
    end

    create_table :people_locations do |t|
      t.integer :person_id, null: false
      t.integer :location_id, null: false
      t.index :person_id
      t.index %i[person_id location_id], unique: true
    end
  end
end
