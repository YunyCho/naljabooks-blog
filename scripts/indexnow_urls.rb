#!/usr/bin/env ruby

require "cgi"
require "date"
require "open-uri"
require "open3"
require "pathname"
require "yaml"

module IndexNowUrls
  class Error < StandardError; end

  class Selector
    GLOBAL_PATHS = %r{\A(?:_config\.yml|_data/|_includes/|_layouts/)}
    CONTENT_EXTENSIONS = %w[.html .md .markdown].freeze

    def initialize(root:, site_url:, sitemap_loader:)
      @root = Pathname.new(root).expand_path
      @site_url = site_url.sub(%r{/+\z}, "")
      @sitemap_loader = sitemap_loader
    end

    def urls_for(paths, before_sha: nil)
      paths = paths.uniq
      return sitemap_urls if paths.any? { |path| path.match?(GLOBAL_PATHS) }

      paths.filter_map { |path| url_for(path, before_sha:) }.uniq.sort
    end

    private

    def sitemap_urls
      @sitemap_loader.call.scan(%r{<loc>(.*?)</loc>}m)
        .flatten
        .map { |url| CGI.unescapeHTML(url.strip) }
        .select { |url| url.start_with?("#{@site_url}/") || url == "#{@site_url}/" }
        .uniq
        .sort
    end

    def url_for(path, before_sha:)
      case path
      when %r{\A_posts/\d{4}-\d{2}-\d{2}-(.+)\.(?:md|markdown)\z}
        absolute_url("/archive/#{Regexp.last_match(1)}/")
      when %r{\A_english/(.+)\.(?:md|markdown)\z}
        absolute_url("/en/archive/#{Regexp.last_match(1)}/")
      else
        return unless page_source?(path)

        permalink = front_matter(content_for(path, before_sha:))["permalink"]
        absolute_url(permalink) if permalink&.start_with?("/")
      end
    end

    def page_source?(path)
      pathname = Pathname.new(path)
      CONTENT_EXTENSIONS.include?(pathname.extname.downcase) &&
        (pathname.each_filename.to_a.length == 1 || path.start_with?("en/"))
    end

    def content_for(path, before_sha:)
      local_path = @root.join(path)
      return local_path.read if local_path.file?
      return "" unless before_sha

      stdout, _stderr, status = Open3.capture3(
        "git", "show", "#{before_sha}:#{path}", chdir: @root.to_s
      )
      status.success? ? stdout : ""
    end

    def front_matter(content)
      match = content.match(%r{\A---\s*\n(.*?)\n---\s*\n}m)
      return {} unless match

      YAML.safe_load(match[1], permitted_classes: [Date, Time], aliases: false) || {}
    rescue Psych::SyntaxError
      {}
    end

    def absolute_url(permalink)
      "#{@site_url}#{permalink}"
    end
  end

  module_function

  def changed_paths(root, before_sha, after_sha)
    validate_sha!(before_sha)
    validate_sha!(after_sha)
    stdout, stderr, status = Open3.capture3(
      "git", "diff", "--name-status", "-M", before_sha, after_sha, chdir: root.to_s
    )
    raise Error, stderr unless status.success?

    stdout.lines.flat_map do |line|
      status_code, *paths = line.chomp.split("\t")
      status_code.start_with?("R", "C") ? paths : paths.last(1)
    end.compact
  end

  def validate_sha!(sha)
    return if sha.match?(/\A[0-9a-f]{40}\z/i)

    raise Error, "invalid commit SHA: #{sha.inspect}"
  end
end

if $PROGRAM_NAME == __FILE__
  begin
    root = Pathname.new(__dir__).join("..").expand_path
    before_sha, after_sha = ARGV
    abort "usage: ruby scripts/indexnow_urls.rb BEFORE_SHA AFTER_SHA" unless before_sha && after_sha

    sitemap_url = ENV.fetch("INDEXNOW_SITEMAP_URL")
    selector = IndexNowUrls::Selector.new(
      root:,
      site_url: ENV.fetch("INDEXNOW_SITE_URL"),
      sitemap_loader: -> { URI.open(sitemap_url, &:read) }
    )
    puts selector.urls_for(
      IndexNowUrls.changed_paths(root, before_sha, after_sha),
      before_sha:
    )
  rescue IndexNowUrls::Error => error
    warn error.message
    exit 1
  end
end
