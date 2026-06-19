require "minitest/autorun"
require "pathname"
require "tmpdir"
require "time"
require_relative "../../lib/naver_draft"

class GeneratorTest < Minitest::Test
  def with_root
    Dir.mktmpdir("naver-generator") do |dir|
      root = Pathname(dir)
      root.join("_posts").mkpath
      root.join("_config.yml").write(<<~YAML)
        url: "https://yunycho.github.io"
        baseurl: "/naljabooks-blog"
        permalink: /archive/:title/
      YAML
      yield root
    end
  end

  def post(title:, lang: nil)
    language = lang ? "lang: #{lang}\n" : ""
    "---\n#{language}title: \"#{title}\"\ntags: [검증]\n---\n본문\n"
  end

  def generator(root)
    NaverDraft::Generator.new(
      root, source_commit: "abc1234", generated_at: Time.iso8601("2026-06-19T00:00:00Z")
    )
  end

  def test_creates_korean_and_skips_english
    with_root do |root|
      korean = "_posts/2026-06-19-korean.md"
      english = "_posts/2026-06-19-english.md"
      root.join(korean).write(post(title: "한국어"))
      root.join(english).write(post(title: "English", lang: "en"))
      result = generator(root).generate([korean, english])

      assert_equal ["naver-drafts/korean.md"], result.created
      assert_equal [english], result.skipped_language
      assert root.join("naver-drafts/korean.md").file?
    end
  end

  def test_does_not_overwrite_existing_draft
    with_root do |root|
      path = "_posts/2026-06-19-korean.md"
      root.join(path).write(post(title: "한국어"))
      root.join("naver-drafts").mkpath
      output = root.join("naver-drafts/korean.md")
      output.write("human edit\n")
      result = generator(root).generate([path])

      assert_equal ["naver-drafts/korean.md"], result.skipped_existing
      assert_equal "human edit\n", output.read
    end
  end

  def test_invalid_post_prevents_every_write
    with_root do |root|
      valid = "_posts/2026-06-19-valid.md"
      invalid = "_posts/2026-06-19-invalid.md"
      root.join(valid).write(post(title: "정상"))
      root.join(invalid).write("---\ntitle: [\n---\n본문\n")

      assert_raises(NaverDraft::Error) { generator(root).generate([valid, invalid]) }
      refute root.join("naver-drafts/valid.md").exist?
    end
  end
end
