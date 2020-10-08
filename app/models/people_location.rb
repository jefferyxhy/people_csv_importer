# frozen_string_literal: true

class PeopleLocation < ApplicationRecord
  belongs_to :person
  belongs_to :location

  validates_presence_of :person, :location
end
