# frozen_string_literal: true

class PeopleAffiliation < ApplicationRecord
  belongs_to :person
  belongs_to :affiliation

  validates_presence_of :person, :affiliation
end
