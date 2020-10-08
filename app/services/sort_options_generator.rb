# frozen_string_literal: true

class SortOptionsGenerator
  DEFAULT_SORT_ATTRIBUTE = :updated_at
  DEDAULT_SORT_ORDER = :desc

  attr_reader :include_methods

  def initialize(collection:, sort_by: '')
    @options = {}
    @collection = collection
    @sort_by = sort_by
  end

  def call
    sort_attributes.each do |attribute|
      non_symbol_attribute = non_symbol_attribute(attribute)
      symbol = attribute == non_symbol_attribute ? :asc : :desc
      if instance_class_method_defined?(non_symbol_attribute)
        @options[non_symbol_attribute.to_sym] = symbol
        end
      if instance_class_method_defined?(non_symbol_attribute) && !class_attributes.include?(non_symbol_attribute)
        @include_methods = true
        end
    end
    options
  end

  def include_methods
    @include_methods ||= false
  end

    private

  attr_reader :options
  attr_accessor :collection, :sort_by

  def class_attributes
    @class_attributes ||= collection.try(:first).try(:class).try(:column_names) || []
  end

  def sort_attributes
    @sort_attributes ||= begin
      @sort_attributes = sort_by.try(:split, ',') || []
      @sort_attributes = @sort_attributes.map(&:strip)
      @sort_attributes
    end
  end

  def instance_class
    @instance_class ||= collection.try(:first).try(:class)
  end

  def non_symbol_attribute(attribute = '')
    attribute = attribute.to_s
    return '' if attribute.blank?

    attribute[0] === '-' ? attribute[1..-1] : attribute
  end

  def instance_class_method_defined?(attribute = '')
    return false if instance_class.blank?

    instance_class.method_defined?(non_symbol_attribute(attribute)) ? true : false
  end
  end
