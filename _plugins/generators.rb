require 'jekyll'

class RSSGenerator < Jekyll::Generator
  def generate(site)
    @index_page = site.pages.find { |page| page.name == "index.md" }
    site.pages.each do |page|
      page.data['articles'] = articles if %w(feed.xml rss.xml).include?(page.name)
    end
  end

  private
  def articles
    @articles ||= Article.all(rows)
  end

  def rows
    @index_page.content.split(/#articles\s*}\n\n/).last.split(/## \[동영상\]/).first.split(/\n/)
  end
end

class Article
  ROW_MATCHER = /^-\s*\[(?<title>[^\]]+)\]\((?<url>[^)]+)\){:\s*.article(?<data>(\s*data-\w+="[^"]+")+)\s*}\s*$/
  DATA_MATCHER = /data-(?<key>\w+)="(?<value>[^"]+)"/
  InvalidRow = Class.new(RuntimeError)
  attr_reader :info

  def self.all(rows)
    rows.map { |row| new(row).to_h }
  end

  def initialize(row)
    m = row.match(ROW_MATCHER)
    raise InvalidRow, "invalid row: #{row}" unless m
    @info = { "url" => m[:url] }
    set_data(m)
    set_title(m)
  end

  def to_h
    @info
  end

  private
  def set_title(m)
    if @info["tags"].include?("translated")
      @info["title"] = "[번역] #{m[:title]}"
    else
      @info["title"] = m[:title]
    end
  end

  def set_data(m)
    m[:data].scan(DATA_MATCHER) do |key, value|
      @info[key] = value
    end
  end
end
