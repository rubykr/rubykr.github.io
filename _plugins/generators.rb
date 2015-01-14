module Jekyll
  class RSSGenerator < Generator
    def generate(site)
      @index_page = site.pages.find { |page| page.name == "index.md" }
      @feed_page = site.pages.find { |page| page.name == "feed.xml" }
      @feed_page.data['articles'] = articles
    end

    private
    def articles
      unless @articles
        @articles = []
        rows = @index_page.content.split(/#articles\s*}\n\n/).last.split(/## \[동영상\]/).first.split(/\n/)
        rows.each do |row|
          @articles << {}
          m = row.match(/^-\s*\[(?<title>[^\]]+)\]\((?<url>[^)]+)\){:\s*.article(?<data>(\s*data-\w+="[^"]+")+)\s*}\s*$/)
          @articles.last["title"] = m[:title]
          @articles.last["url"] = m[:url]
          m[:data].scan(/data-(?<key>\w+)="(?<value>[^"]+)"/) do |key, value|
            @articles.last[key] = value
          end
          if articles.last["tags"].include?("translated")
            @articles.last["title"] = "[번역] #{m[:title]}"
          end
        end
      end
      @articles
    end
  end
end
