# frozen_string_literal: true

class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.integer :gender
      t.string :species
      t.string :weapon
      t.string :vehicle
      t.timestamps

      t.index %i[first_name last_name], unique: true
    end
  end
end
