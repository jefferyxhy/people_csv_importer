# frozen_string_literal: true

class Location < ApplicationRecord
  has_many :people_locations, inverse_of: :person
  has_many :people, through: :people_locations

  validates :name, presence: true, uniqueness: { allow_blank: false, case_sensitive: false }

  # find or create multiple locations from names (string || Array)
  def self.find_or_create_by_names(names)
    names = (names.try(:to_s) || '').split(',').map(&:strip).map(&:titleize) unless names.is_a? Array
    names.reject(&:blank?).map { |name| Location.find_or_create_by!(name: name) }
  end

  def name=(value)
    write_attribute :name, value.try(:to_s).try(:strip).try(:titleize)
  end
end
