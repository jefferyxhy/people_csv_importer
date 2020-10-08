# frozen_string_literal: true

require 'csv'

class PersonCsvImporter
  def initialize(csv)
    @csv = csv
  end

  def call
    # invalid data found
    if person_rows.blank?
      @errors_exist = true
      @full_messages = 'invalid data, please upload valid csv file'
      return
    end

    # loop person rows and create records
    person_rows.each do |row|
      attributes = Person.new(row.except(:location, :affiliations)).attributes.with_indifferent_access
      Person.find_or_initialize_by(attributes.slice(:first_name, :last_name)).tap do |person|
        person.assign_attributes(attributes.slice(:species, :gender, :weapon, :vehicle))
        person.build_locations_by_names(row[:location])
        person.build_affiliations_by_name(row[:affiliations])
        person.save ? imported_people << person : ignored_people << person
      end
    end
    imported_people
  end

  def errors_exist?
    @errors_exist ||= ignored_people.present?
  end

  def full_messages
    @full_messages ||= @ignored_people.present? ? @ignored_people.map { |person| "<strong>#{person.name}</strong>: #{person.errors.full_messages.join(', ')}" }.join('<br />') : 'csv successfully imported!'
  end

  private

  attr_accessor :csv

  def imported_people
    @imported_people ||= []
  end

  def ignored_people
    @ignored_people ||= []
  end

  # extract person rows from csv file
  def person_rows
    @person_rows ||= begin
      rows = ::CSV.read(csv.path)
      column_names = rows[0].map(&:downcase)
      rows[1..-1].map { |row| row.each_with_index.map { |column_value, i| Hash[column_names[i], column_value] }.reduce({}, :merge).with_indifferent_access }
    end
  rescue StandardError => e
    []
  end
end
