require 'jekyll'

class RSSGenerator < Jekyll::Generator
  def generate(site)
    @content = site.pages.find { |page| page.name == "index.md" }.content
    site.pages.each do |page|
      page.data['articles'] = articles if %w(feed.xml rss.xml).include?(page.name)
    end
  end

  private
  def articles
    @articles ||= Article.all(@content)
  end
end

class Article
  ROW_MATCHER = /^-\s*\[(?<title>[^\]]+)\]\((?<url>[^)]+)\){:\s*.article(?<data>(\s*data-\w+="[^"]+")+)\s*}\s*$/
  DATA_MATCHER = /data-(?<key>\w+)="(?<value>[^"]+)"/
  CONTEXT_MATCHER = /#articles\s*}\n+(?<rows>(#{ROW_MATCHER}\n)+)\n*## \[동영상\]/m
  InvalidRow = Class.new(RuntimeError)
  InvalidContent = Class.new(RuntimeError)

  attr_reader :info

  def self.all(content)
    m = content.match(CONTEXT_MATCHER)
    raise InvalidContent, "invalid content: #{content}" unless m
    rows = m[:rows].split("\n")
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
    info
  end

  private
  def set_title(m)
    if info["tags"].include?("translated")
      info["title"] = "[번역] #{m[:title]}"
    else
      info["title"] = m[:title]
    end
  end

  def set_data(m)
    m[:data].scan(DATA_MATCHER) do |key, value|
      info[key] = value
    end
  end
end
