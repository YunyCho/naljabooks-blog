require "open3"
require "pathname"

module NaverDraft
  class PostDetector
    SHA = /\A[0-9a-f]{7,40}\z/i

    def initialize(root)
      @root = Pathname(root).expand_path
    end

    def added(before_sha, after_sha)
      [before_sha, after_sha].each do |sha|
        raise Error, "invalid commit SHA: #{sha.inspect}" unless SHA.match?(sha)
      end

      stdout, stderr, status = Open3.capture3(
        "git", "diff", "--diff-filter=A", "--name-only", before_sha, after_sha, "--", "_posts/*.md",
        chdir: @root.to_s
      )
      raise Error, "git diff failed: #{stderr.strip}" unless status.success?

      stdout.lines(chomp: true).reject(&:empty?).sort
    end
  end
end
