class TableComponent < ViewComponent::Base
  attr_reader :headers, :attributes, :data

  def initialize(headers:, attributes:, data:)
    @headers = headers
    @attributes = attributes
    @data = data
  end
end
