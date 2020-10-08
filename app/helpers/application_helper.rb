# frozen_string_literal: true

module ApplicationHelper
  def sortable_column(column_name, label)
    options = {}
    options[:data] = { column_name: column_name }
    options[:class] = "sortable-column"
    content_tag(:div, content_tag(:a, label), options)
  end
end
