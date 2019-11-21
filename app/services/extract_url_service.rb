# frozen_string_literal: true

class ExtractUrlService
  attr_reader :expression, :links

  def initialize(doc:)
    @doc = doc
    @expression = './/a'
    @links = []
  end

  def call
    fetch_links
  end

  def self.call(doc:)
    new(doc: doc).call
  end

  private

  attr_reader :doc

  def fetch_links
    doc.xpath(expression).each do |element|
      data = { "name": element.text, url: element['href'] }.to_json

      Redis.current.sadd("scraped_links", data)
    end
  end
end
