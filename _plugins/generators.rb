require 'jekyll'

class RSSGenerator < Jekyll::Generator
  ROW_MATCHER = /^-\s*\[(?<title>[^\]]+)\]\((?<url>[^)]+)\){:\s*.article(?<data>(\s*data-\w+="[^"]+")+)\s*}\s*$/
  DATA_MATCHER = /data-(?<key>\w+)="(?<value>[^"]+)"/
  def generate(site)
    @index_page = site.pages.find { |page| page.name == "index.md" }
    site.pages.each do |page|
      page.data['articles'] = articles if %w(feed.xml rss.xml).include?(page.name)
    end
  end

  def articles
    unless @articles
      @articles = []
      rows.each do |row|
        article = {}
        m = row.match(ROW_MATCHER)
        m[:data].scan(DATA_MATCHER) do |key, value|
          article[key] = value
        end
        set_title(article, m)
        article["url"] = m[:url]
        @articles << article
      end
    end
    @articles
  end

  private
  def rows
    @index_page.content.split(/#articles\s*}\n\n/).last.split(/## \[동영상\]/).first.split(/\n/)
  end

  def set_title(article, m)
    if article["tags"].include?("translated")
      article["title"] = "[번역] #{m[:title]}"
    else
      article["title"] = m[:title]
    end
  end
end
