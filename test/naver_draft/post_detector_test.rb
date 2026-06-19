require "minitest/autorun"
require "fileutils"
require "open3"
require "pathname"
require "tmpdir"

require_relative "../../lib/naver_draft"

class PostDetectorTest < Minitest::Test
  def git(root, *args)
    stdout, stderr, status = Open3.capture3("git", *args, chdir: root)
    raise stderr unless status.success?

    stdout.strip
  end

  def test_returns_only_posts_added_between_commits
    Dir.mktmpdir("naver-detector") do |dir|
      git(dir, "init", "-q")
      git(dir, "config", "user.email", "test@example.invalid")
      git(dir, "config", "user.name", "Test")
      FileUtils.mkdir_p(Pathname(dir).join("_posts"))
      Pathname(dir).join("_posts/2026-01-01-old.md").write("old\n")
      Pathname(dir).join("README.md").write("old\n")
      git(dir, "add", ".")
      git(dir, "commit", "-qm", "base")
      before = git(dir, "rev-parse", "HEAD")

      Pathname(dir).join("_posts/2026-01-01-old.md").write("changed\n")
      Pathname(dir).join("_posts/2026-01-02-new.md").write("new\n")
      Pathname(dir).join("README.md").write("changed\n")
      git(dir, "add", ".")
      git(dir, "commit", "-qm", "change")
      after = git(dir, "rev-parse", "HEAD")

      assert_equal ["_posts/2026-01-02-new.md"], NaverDraft::PostDetector.new(dir).added(before, after)
    end
  end

  def test_rejects_non_commit_arguments
    Dir.mktmpdir("naver-detector") do |dir|
      git(dir, "init", "-q")
      error = assert_raises(NaverDraft::Error) do
        NaverDraft::PostDetector.new(dir).added("HEAD; touch bad", "HEAD")
      end
      assert_match(/commit SHA/, error.message)
    end
  end
end
