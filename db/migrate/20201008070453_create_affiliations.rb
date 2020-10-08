# frozen_string_literal: true

class CreateAffiliations < ActiveRecord::Migration[5.2]
  def change
    create_table :affiliations do |t|
      t.string :name, null: false
      t.index :name, unique: true
    end

    create_table :people_affiliations do |t|
      t.integer :person_id, null: false
      t.integer :affiliation_id, null: false
      t.index :person_id
      t.index %i[person_id affiliation_id], unique: true
    end
  end
end
