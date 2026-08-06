require "minitest/autorun"
require "fileutils"
require "pathname"
require "tmpdir"

require_relative "../../scripts/indexnow_urls"

class IndexNowUrlsTest < Minitest::Test
  SITE_URL = "https://example.test/blog"

  def selector(root, sitemap: "")
    IndexNowUrls::Selector.new(
      root:,
      site_url: SITE_URL,
      sitemap_loader: -> { sitemap }
    )
  end

  def test_maps_korean_and_english_articles
    Dir.mktmpdir("indexnow-urls") do |dir|
      urls = selector(dir).urls_for([
        "_posts/2026-08-06-new-article.md",
        "_english/new-article.md"
      ])

      assert_equal [
        "#{SITE_URL}/archive/new-article/",
        "#{SITE_URL}/en/archive/new-article/"
      ], urls
    end
  end

  def test_reads_page_permalink_from_front_matter
    Dir.mktmpdir("indexnow-urls") do |dir|
      FileUtils.mkdir_p(Pathname(dir).join("en"))
      Pathname(dir).join("en/about.md").write(<<~MARKDOWN)
        ---
        title: About
        permalink: /en/about/
        ---
        Body
      MARKDOWN

      assert_equal ["#{SITE_URL}/en/about/"], selector(dir).urls_for(["en/about.md"])
    end
  end

  def test_global_template_change_uses_deployed_sitemap
    sitemap = <<~XML
      <urlset>
        <url><loc>https://example.test/blog/</loc></url>
        <url><loc>https://example.test/blog/archive/article/</loc></url>
        <url><loc>https://other.test/not-ours/</loc></url>
      </urlset>
    XML

    assert_equal [
      "#{SITE_URL}/",
      "#{SITE_URL}/archive/article/"
    ], selector(Dir.pwd, sitemap:).urls_for(["_layouts/default.html"])
  end

  def test_rejects_shell_content_in_commit_sha
    error = assert_raises(IndexNowUrls::Error) do
      IndexNowUrls.validate_sha!("HEAD; touch bad")
    end

    assert_match(/invalid commit SHA/, error.message)
  end
end
