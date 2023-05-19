class SortableTableComponent < ViewComponent::Base
  attr_reader :headers, :attributes, :data, :sortable, :sort_column, :sort_direction

  def initialize(headers:, attributes:, data:, sortable: true, sort_column:, sort_direction:)
    super
    @headers = headers
    @attributes = attributes
    @data = data
    @sortable = sortable
    @sort_column = sort_column
    @sort_direction = sort_direction
  end

  def sortable_header(column, index)
    if sortable
      link_to sortable_column_path(attributes[index], index), class: sortable_header_classes do
        concat column
        concat sort_indicator(attributes[index])
      end
    else
      column
    end
  end

  def call
    tag.table(class: 'min-w-full bg-white border border-gray-200 divide-y divide-gray-200') do
      tag.thead(class: 'bg-gray-50') do
        tag.tr do
          headers.each_with_index.map do |header, index|
            tag.th(class: 'py-3 px-6 font-bold text-gray-700 text-left') do
              sortable_header(header, index)
            end
          end.join.html_safe
        end
      end +
        tag.tbody(class: 'divide-y divide-gray-200') do
          data.map { |record| tag.tr(record_row(record), class: alternating_row_class) }.join.html_safe
        end
    end
  end

  private

  def sortable_column_path(column, index)
    next_direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    "/?sort_column=#{attributes[index]}&sort_direction=#{next_direction}"
  end

  def sort_indicator(column)
    return '' unless sort_column == column

    tag.span(class: 'sort-indicator') do
      sort_direction == 'asc' ? '▲'.html_safe : '▼'.html_safe
    end
  end

  def sortable_header_classes
    sortable ? 'cursor-pointer' : ''
  end

  def alternating_row_class
    cycle('bg-gray-100', 'bg-white')
  end

  def record_row(record)
    attributes.map { |attribute| content_tag :td, record[attribute], class: 'py-4 px-6' }.join.html_safe
  end
end
