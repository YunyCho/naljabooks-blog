require "minitest/autorun"
require "pathname"
require "tmpdir"
require_relative "../../lib/naver_draft"

class PostTest < Minitest::Test
  KOREAN = <<~MARKDOWN
    ---
    title: "새 글"
    tags: ["쉬운 글", "읽기-이해"]
    ---
    본문입니다.
  MARKDOWN

  def with_root
    Dir.mktmpdir("naver-post") do |dir|
      root = Pathname(dir)
      root.join("_posts").mkpath
      yield root
    end
  end

  def test_parses_missing_language_as_korean
    with_root do |root|
      root.join("_posts/2026-06-19-new-post.md").write(KOREAN)
      post = NaverDraft::Post.load(root, "_posts/2026-06-19-new-post.md")

      assert post.korean?
      assert_equal "새 글", post.title
      assert_equal "new-post", post.slug
      assert_equal "본문입니다.\n", post.body
    end
  end

  def test_accepts_ko_and_ko_kr_but_skips_en
    with_root do |root|
      %w[ko ko-KR en].each do |lang|
        root.join("_posts/2026-06-19-#{lang}.md").write(KOREAN.sub("title:", "lang: #{lang}\ntitle:"))
      end

      assert NaverDraft::Post.load(root, "_posts/2026-06-19-ko.md").korean?
      assert NaverDraft::Post.load(root, "_posts/2026-06-19-ko-KR.md").korean?
      refute NaverDraft::Post.load(root, "_posts/2026-06-19-en.md").korean?
    end
  end

  def test_rejects_bad_front_matter_missing_title_and_path_escape
    with_root do |root|
      root.join("_posts/2026-06-19-bad.md").write("---\ntitle: [\n---\nbody\n")
      assert_raises(NaverDraft::Error) { NaverDraft::Post.load(root, "_posts/2026-06-19-bad.md") }

      root.join("_posts/2026-06-19-no-title.md").write("---\nlang: ko\n---\nbody\n")
      assert_raises(NaverDraft::Error) { NaverDraft::Post.load(root, "_posts/2026-06-19-no-title.md") }
      assert_raises(NaverDraft::Error) { NaverDraft::Post.load(root, "../secret.md") }
    end
  end
end
