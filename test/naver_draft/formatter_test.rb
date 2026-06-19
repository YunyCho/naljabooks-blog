require "minitest/autorun"
require "pathname"
require "tmpdir"
require "time"
require_relative "../../lib/naver_draft"

class FormatterTest < Minitest::Test
  def test_formats_copy_ready_body_and_tracking_metadata
    Dir.mktmpdir("naver-formatter") do |dir|
      root = Pathname(dir)
      root.join("_posts").mkpath
      root.join("_posts/2026-06-19-sample.md").write(<<~MARKDOWN)
        ---
        title: "샘플 글"
        tags: ["쉬운 글", "읽기-이해"]
        ---
        ## 이해 활동 {#activity}

        **중요한 문장**과 [관련 자료](https://example.org/read)를 봅니다.

        ![학습 장면](/assets/images/scene.webp)

        > 질문을 확인합니다.

        - 첫 번째
        - 두 번째
      MARKDOWN
      post = NaverDraft::Post.load(root, "_posts/2026-06-19-sample.md")
      draft = NaverDraft::Formatter.new(
        site_url: "https://yunycho.github.io", base_url: "/naljabooks-blog"
      ).render(post, source_commit: "abc1234", generated_at: Time.iso8601("2026-06-19T00:00:00Z"))

      assert_includes draft, 'source_path: "_posts/2026-06-19-sample.md"'
      assert_includes draft, 'source_url: "https://yunycho.github.io/naljabooks-blog/archive/sample/"'
      assert_includes draft, "source_commit: \"abc1234\""
      assert_includes draft, "## 이해 활동\n"
      refute_includes draft, "{#activity}"
      assert_includes draft, "중요한 문장과 관련 자료 (https://example.org/read)"
      assert_includes draft, "이미지: 학습 장면 (https://yunycho.github.io/naljabooks-blog/assets/images/scene.webp)"
      assert_includes draft, "> 질문을 확인합니다."
      assert_includes draft, "- 첫 번째"
      assert_includes draft, "원문 보기: https://yunycho.github.io/naljabooks-blog/archive/sample/"
      assert_includes draft, "#쉬운글 #읽기이해"
    end
  end
end
