# frozen_string_literal: true

require "csv"

class UrlsCsvService
  def initialize
    @storage_path = Rails.root.join('public/links/')
  end

  def generate
    _generate
  end

  def self.generate
    new.generate
  end

  private

  attr_reader :links, :storage_path

  def _generate
    link_file = "#{storage_path}links.csv"
    FileUtils.mkdir_p(storage_path) unless File.exist?(storage_path)
    index = 1
    ::CSV.open("#{storage_path}links.csv", 'wb') do |csv|
      csv << %i[No Name Link]
      Redis.current.smembers("scraped_links").each do |member|
        link_info = JSON.parse(member)
        csv << [index, link_info["name"], link_info["url"]]
        index += 1
      rescue JSON::ParserError
        next
      end
    end

    link_file if File.exist?(link_file)
  end
end
