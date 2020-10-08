# frozen_string_literal: true

class ApiControl
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :q # search keyword
  attr_accessor :sort_by # combination of sort column & order
  attr_accessor :per_page # per page number of pagination
  attr_accessor :page # target page number of pagination

  def initialize(attributes = {})
    @attributes = {}

    unless attributes.blank?
      attributes.each do |attr, value|
        if self.class.method_defined? "#{attr}="
          send "#{attr}=", value
          @attributes[attr] = value
        end
      end
    end
  end

  def q=(value)
    @q = value.try(:to_s).try(:strip).try(:downcase)
  end

  def per_page
    @per_page ||= 10
  end

  def per_page=(value)
    @per_page = value.try(:to_i) || 10
  end

  def page
    @page ||= 1
  end

  def page=(value)
    @page = value.try(:to_i) || 1
  end

  def sort(collection, sort_by = nil)
    sort_options_generator = ::SortOptionsGenerator.new(collection: collection, sort_by: sort_by || self.sort_by)
    options = sort_options_generator.call
    include_methods = sort_options_generator.include_methods

    if include_methods || collection.is_a?(Array)
      collection.sort do |a, b|
        options.map { |key, val| val == :asc ? a.send(key) : b.send(key) } <=> options.map { |key, val| val == :desc ? a.send(key) : b.send(key) }
      end
    else
      collection.order(options)
    end
  end

  def paginate(collection, page: nil, per_page: nil)
    page = self.page if page.blank?
    per_page = self.per_page if per_page.blank?
    collection.is_a?(Array) ? Kaminari.paginate_array(collection).page(page).per(per_page) : collection.try(:page, page).try(:per, per_page)
  end
end
