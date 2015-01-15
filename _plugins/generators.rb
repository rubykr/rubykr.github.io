module RSS
  class Generator < Jekyll::Generator
    ROW_MATCHER = /^-\s*\[(?<title>[^\]]+)\]\((?<url>[^)]+)\){:\s*.article(?<data>(\s*data-\w+="[^"]+")+)\s*}\s*$/
    DATA_MATCHER = /data-(?<key>\w+)="(?<value>[^"]+)"/
    def generate(site)
      @index_page = site.pages.find { |page| page.name == "index.md" }
      @feed_page = site.pages.find { |page| page.name == "feed.xml" }
      @rss_page = site.pages.find { |page| page.name == "rss.xml" }
      @feed_page.data['articles'] = articles
      @rss_page.data['articles'] = articles
    end

    private
    def articles
      unless @articles
        @articles = []
        rows.each do |row|
          article = {}
          m = row.match(ROW_MATCHER)
          m[:data].scan(DATA_MATCHER) do |key, value|
            article[key] = value
          end
          if article["tags"].include?("translated")
            article["title"] = "[번역] #{m[:title]}"
          else
            article["title"] = m[:title]
          end
          article["url"] = m[:url]
          @articles << article
        end
      end
      @articles
    end

    def rows
      @index_page.content.split(/#articles\s*}\n\n/).last.split(/## \[동영상\]/).first.split(/\n/)
    end
  end
end
