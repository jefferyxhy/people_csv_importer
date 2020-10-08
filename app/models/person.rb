# frozen_string_literal: true

class Person < ApplicationRecord
  has_many :people_locations
  has_many :people_affiliations
  has_many :locations, through: :people_locations
  has_many :affiliations, through: :people_affiliations

  validates :first_name, presence: true
  validates :last_name, uniqueness: { scope: :first_name, case_sensitive: false, message: 'conflict, user with same first name and last name already exists' }
  validates :gender, :species, presence: true
  validate :check_affiliations_exist

  accepts_nested_attributes_for :locations, :affiliations

  enum gender: %i[Male Female Other]

  attr_accessor :name

  def build_locations_by_names(names)
    Location.find_or_create_by_names(names).each { |location| self.people_locations.find_or_initialize_by(location: location) }
  end

  def build_affiliations_by_name(names)
    Affiliation.find_or_create_by_names(names).each { |affiliation| self.people_affiliations.find_or_initialize_by(affiliation: affiliation) }
  end

  def location_names
    locations.map(&:name).join(', ')
  end

  def affiliation_names
    affiliations.map(&:name).join(', ')
  end

  def name
    [first_name, last_name].join(' ')
  end

  def name=(value)
    names = (value.try(:to_s) || '').split(' ', 2)
    self.first_name = names[0]
    self.last_name = names[1]
  end

  def first_name=(value)
    write_attribute :first_name, value.try(:strip).try(:titleize)
  end

  def last_name=(value)
    write_attribute :last_name, value.try(:strip).try(:titleize)
  end

  def gender=(value)
    value = (value.try(:to_s) || '')[0].try(:upcase)
    write_attribute :gender, value === 'M' ? 'Male' : (value === 'F' ? 'Female' : 'Other')
  end

  def weapon=(value)
    write_attribute :weapon, value.try(:gsub, /[^a-zA-Z0-9]/, '')
  end

  private

  def check_affiliations_exist
    if people_affiliations.blank?
      errors.add(:affiliations, 'should have at least one record')
    end
  end
end
