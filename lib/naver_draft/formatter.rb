require "time"
require "uri"

module NaverDraft
  class Formatter
    IMAGE = /!\[([^\]]*)\]\(([^)\s]+)(?:\s+"[^"]*")?\)/
    LINK = /\[([^\]]+)\]\(([^)\s]+)(?:\s+"[^"]*")?\)/

    def initialize(site_url:, base_url:)
      @site_url = site_url.sub(%r{/+\z}, "")
      @base_url = base_url.to_s.sub(%r{/+\z}, "")
    end

    def render(post, source_commit:, generated_at:)
      source_url = "#{@site_url}#{@base_url}/archive/#{post.slug}/"
      tags = post.tags.filter_map { |tag| hashtag(tag) }.join(" ")
      body = format_body(post.body, source_url).strip

      <<~MARKDOWN
        ---
        source_path: #{post.relative_path.dump}
        source_url: #{source_url.dump}
        source_commit: #{source_commit.dump}
        generated_at: #{generated_at.utc.iso8601.dump}
        naver_status: "draft"
        ---

        # 네이버 블로그 복사 영역

        ## 제목

        #{post.title}

        ## 본문

        #{body}

        원문 보기: #{source_url}

        ## 해시태그

        #{tags}
      MARKDOWN
    end

    private

    def format_body(body, source_url)
      body
        .gsub(IMAGE) { "이미지: #{Regexp.last_match(1)} (#{image_url(Regexp.last_match(2), source_url)})" }
        .gsub(LINK) { "#{Regexp.last_match(1)} (#{Regexp.last_match(2)})" }
        .gsub(/^(\s*#+\s+.*?)\s+\{#[A-Za-z0-9_-]+\}\s*$/, "\\1")
        .gsub(/\*\*([^*\n]+)\*\*/, "\\1")
        .gsub(/__([^_\n]+)__/, "\\1")
        .gsub(/(?<!\*)\*([^*\n]+)\*(?!\*)/, "\\1")
        .gsub(/(?<!\w)_([^_\n]+)_(?!\w)/, "\\1")
        .lines.map(&:rstrip).join("\n")
        .gsub(/\n{3,}/, "\n\n")
    end

    def image_url(path, source_url)
      return path if path.match?(%r{\Ahttps?://})
      return "#{@site_url}#{@base_url}#{path}" if path.start_with?("/")

      URI.join(source_url, path).to_s
    rescue URI::InvalidURIError
      raise Error, "invalid image URL: #{path}"
    end

    def hashtag(tag)
      cleaned = tag.to_s.gsub(/[^\p{L}\p{N}_]/u, "")
      cleaned.empty? ? nil : "##{cleaned}"
    end
  end
end
