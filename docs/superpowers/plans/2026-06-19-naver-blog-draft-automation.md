# Naver Blog Draft Automation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Detect newly added Korean Jekyll posts on `main`, generate deterministic Naver-ready draft files, and open a review Pull Request without modifying source posts or publishing to Naver.

**Architecture:** A small Ruby domain layer separates git change detection, strict post parsing, text formatting, and atomic batch writing. A GitHub Actions workflow runs the same tests and CLIs used locally, commits only generated `naver-drafts/` files to an automation-owned branch, and opens one review PR per source push using the repository `GITHUB_TOKEN`.

**Tech Stack:** Ruby 3.3 standard library, Minitest, Jekyll/YAML front matter, Git, GitHub Actions, GitHub CLI

---

## File map

- `lib/naver_draft.rb`: public requires and shared `NaverDraft::Error`.
- `lib/naver_draft/post_detector.rb`: report only `_posts/*.md` files added between two commits.
- `lib/naver_draft/post.rb`: validate paths and parse strict Jekyll front matter.
- `lib/naver_draft/formatter.rb`: convert one parsed Korean post into deterministic draft content.
- `lib/naver_draft/generator.rb`: validate a batch, skip ineligible inputs, and write all generated drafts atomically.
- `scripts/list_new_posts.rb`: CLI adapter for GitHub event commit SHAs.
- `scripts/generate_naver_drafts.rb`: CLI adapter for a newline-delimited path list.
- `test/naver_draft/*_test.rb`: focused unit and real-git integration tests.
- `.github/workflows/create-naver-draft.yml`: push trigger, verification, generation, automation branch, and PR creation.
- `_config.yml`: exclude review drafts from the public Jekyll site.
- `scripts/verify_site.rb`: assert drafts never enter `_site`.
- `README.md`: local usage, repository permission setup, and human review/publish procedure.

### Task 1: Detect only newly added post files

**Files:**
- Create: `lib/naver_draft.rb`
- Create: `lib/naver_draft/post_detector.rb`
- Create: `scripts/list_new_posts.rb`
- Create: `test/naver_draft/post_detector_test.rb`

- [ ] **Step 1: Write a failing real-git detector test**

Create `test/naver_draft/post_detector_test.rb`:

```ruby
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
```

- [ ] **Step 2: Run the detector test and verify RED**

Run: `ruby -Itest test/naver_draft/post_detector_test.rb`

Expected: FAIL with `cannot load such file -- .../lib/naver_draft`.

- [ ] **Step 3: Implement the detector and CLI**

Create `lib/naver_draft.rb`:

```ruby
module NaverDraft
  class Error < StandardError; end
end

require_relative "naver_draft/post_detector"
```

Create `lib/naver_draft/post_detector.rb`:

```ruby
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
```

Create executable `scripts/list_new_posts.rb`:

```ruby
#!/usr/bin/env ruby

require "pathname"
require_relative "../lib/naver_draft"

root = Pathname(__dir__).join("..").expand_path
abort "Usage: scripts/list_new_posts.rb BEFORE_SHA AFTER_SHA" unless ARGV.length == 2

puts NaverDraft::PostDetector.new(root).added(ARGV.fetch(0), ARGV.fetch(1))
```

- [ ] **Step 4: Verify GREEN**

Run: `ruby -Itest test/naver_draft/post_detector_test.rb`

Expected: 2 runs, 4 assertions, 0 failures.

- [ ] **Step 5: Commit detector**

```bash
git add lib/naver_draft.rb lib/naver_draft/post_detector.rb scripts/list_new_posts.rb test/naver_draft/post_detector_test.rb
git commit -m "feat: detect newly added blog posts"
```

### Task 2: Parse posts and classify Korean content

**Files:**
- Modify: `lib/naver_draft.rb`
- Create: `lib/naver_draft/post.rb`
- Create: `test/naver_draft/post_test.rb`

- [ ] **Step 1: Write failing parser tests**

Create `test/naver_draft/post_test.rb` with a temporary repository root and these tests:

```ruby
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
```

- [ ] **Step 2: Run parser tests and verify RED**

Run: `ruby -Itest test/naver_draft/post_test.rb`

Expected: FAIL with `uninitialized constant NaverDraft::Post`.

- [ ] **Step 3: Implement strict post parsing**

Create `lib/naver_draft/post.rb`:

```ruby
require "date"
require "pathname"
require "yaml"

module NaverDraft
  class Post
    FRONT_MATTER = /\A---\s*\n(.*?)\n---\s*\n?(.*)\z/m
    FILENAME = /\A\d{4}-\d{2}-\d{2}-(.+)\.md\z/

    attr_reader :relative_path, :title, :tags, :body, :slug, :language

    def self.load(root, relative_path)
      root = Pathname(root).expand_path
      relative = Pathname(relative_path.to_s)
      posts_root = root.join("_posts").expand_path
      candidate = root.join(relative).expand_path
      allowed_prefix = "#{posts_root}#{File::SEPARATOR}"
      unless !relative.absolute? && candidate.to_s.start_with?(allowed_prefix) && candidate.dirname == posts_root
        raise Error, "post path must stay directly under _posts: #{relative_path}"
      end

      filename_match = FILENAME.match(candidate.basename.to_s)
      raise Error, "invalid post filename: #{relative_path}" unless filename_match

      document_match = FRONT_MATTER.match(candidate.read)
      raise Error, "invalid front matter delimiters: #{relative_path}" unless document_match

      metadata = YAML.safe_load(
        document_match[1], permitted_classes: [Date, Time], permitted_symbols: [], aliases: false
      )
      raise Error, "front matter must be a mapping: #{relative_path}" unless metadata.is_a?(Hash)

      title = metadata["title"].to_s.strip
      raise Error, "missing title: #{relative_path}" if title.empty?

      new(
        relative_path: relative.to_s,
        title: title,
        tags: Array(metadata["tags"]),
        body: document_match[2],
        slug: filename_match[1],
        language: metadata["lang"]&.to_s
      )
    rescue Errno::ENOENT => error
      raise Error, "post not found: #{error.message}"
    rescue Psych::Exception => error
      raise Error, "invalid YAML in #{relative_path}: #{error.message}"
    end

    def initialize(relative_path:, title:, tags:, body:, slug:, language:)
      @relative_path = relative_path
      @title = title
      @tags = tags
      @body = body
      @slug = slug
      @language = language
    end

    def korean?
      language.nil? || %w[ko ko-KR].include?(language)
    end
  end
end
```

Add this require to `lib/naver_draft.rb`:

```ruby
require_relative "naver_draft/post"
```

The path check deliberately permits files only directly inside `_posts`, matching the repository convention and workflow glob.
def korean?
  language.nil? || %w[ko ko-KR].include?(language)
end
```

Add `require_relative "naver_draft/post"` to `lib/naver_draft.rb`.

- [ ] **Step 4: Verify GREEN and the existing real posts**

Run:

```bash
ruby -Itest test/naver_draft/post_test.rb
ruby -Ilib -e 'require "naver_draft"; require "pathname"; root = Pathname.pwd; Dir["_posts/*.md"].sort.each { |p| post = NaverDraft::Post.load(root, p); puts "#{p}: #{post.korean? ? "ko" : "skip"}" }'
```

Expected: parser tests pass; three current Korean posts print `ko` and the English essay prints `skip`.

- [ ] **Step 5: Commit parser**

```bash
git add lib/naver_draft.rb lib/naver_draft/post.rb test/naver_draft/post_test.rb
git commit -m "feat: parse Korean Jekyll posts"
```

### Task 3: Format one post as a Naver review draft

**Files:**
- Modify: `lib/naver_draft.rb`
- Create: `lib/naver_draft/formatter.rb`
- Create: `test/naver_draft/formatter_test.rb`

- [ ] **Step 1: Write the failing formatting behavior**

Create `test/naver_draft/formatter_test.rb`:

```ruby
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
```

- [ ] **Step 2: Run formatter test and verify RED**

Run: `ruby -Itest test/naver_draft/formatter_test.rb`

Expected: FAIL with `uninitialized constant NaverDraft::Formatter`.

- [ ] **Step 3: Implement deterministic formatting**

Create `lib/naver_draft/formatter.rb`:

```ruby
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
```

Add this require to `lib/naver_draft.rb`:

```ruby
require_relative "naver_draft/formatter"
```

- [ ] **Step 4: Verify GREEN**

Run: `ruby -Itest test/naver_draft/formatter_test.rb`

Expected: formatter tests pass with 0 failures.

- [ ] **Step 5: Commit formatter**

```bash
git add lib/naver_draft.rb lib/naver_draft/formatter.rb test/naver_draft/formatter_test.rb
git commit -m "feat: format Naver review drafts"
```

### Task 4: Generate batches atomically and skip duplicates

**Files:**
- Modify: `lib/naver_draft.rb`
- Create: `lib/naver_draft/generator.rb`
- Create: `scripts/generate_naver_drafts.rb`
- Create: `test/naver_draft/generator_test.rb`

- [ ] **Step 1: Write failing batch tests**

Create `test/naver_draft/generator_test.rb`:

```ruby
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
```

- [ ] **Step 2: Run generator tests and verify RED**

Run: `ruby -Itest test/naver_draft/generator_test.rb`

Expected: FAIL with `uninitialized constant NaverDraft::Generator`.

- [ ] **Step 3: Implement two-phase batch generation**

Create `lib/naver_draft/generator.rb`:

```ruby
require "fileutils"
require "pathname"
require "uri"
require "yaml"

module NaverDraft
  class Generator
    Result = Struct.new(:created, :skipped_language, :skipped_existing, keyword_init: true)
    SHA = /\A[0-9a-f]{7,40}\z/i

    def initialize(root, source_commit:, generated_at:)
      @root = Pathname(root).expand_path
      raise Error, "invalid source commit" unless SHA.match?(source_commit)
      @source_commit = source_commit
      @generated_at = generated_at
    end

    def generate(paths)
      formatter = formatter_from_config
      result = Result.new(created: [], skipped_language: [], skipped_existing: [])
      planned = {}

      paths.each do |path|
        post = Post.load(@root, path)
        unless post.korean?
          result.skipped_language << path
          next
        end

        relative_output = "naver-drafts/#{post.slug}.md"
        output = @root.join(relative_output)
        if output.exist?
          result.skipped_existing << relative_output
          next
        end
        raise Error, "duplicate draft slug: #{post.slug}" if planned.key?(output)

        planned[output] = formatter.render(
          post, source_commit: @source_commit, generated_at: @generated_at
        )
      end

      written = []
      begin
        @root.join("naver-drafts").mkpath unless planned.empty?
        planned.each do |output, content|
          File.open(output, File::CREAT | File::EXCL | File::WRONLY) { |file| file.write(content) }
          written << output
          result.created << output.relative_path_from(@root).to_s
        end
      rescue SystemCallError => error
        written.each { |path| FileUtils.rm_f(path) }
        raise Error, "draft write failed: #{error.message}"
      end

      result
    end

    private

    def formatter_from_config
      config = YAML.safe_load(@root.join("_config.yml").read, aliases: false)
      raise Error, "_config.yml must be a mapping" unless config.is_a?(Hash)

      url = config["url"].to_s.sub(%r{/+\z}, "")
      base_url = config["baseurl"].to_s
      uri = URI.parse(url)
      raise Error, "site url must use HTTPS" unless uri.is_a?(URI::HTTPS) && uri.host
      raise Error, "invalid baseurl" unless base_url.empty? || base_url.start_with?("/")
      raise Error, "unsupported permalink" unless config["permalink"] == "/archive/:title/"

      Formatter.new(site_url: url, base_url: base_url)
    rescue Errno::ENOENT, Psych::Exception, URI::InvalidURIError => error
      raise Error, "invalid site config: #{error.message}"
    end
  end
end
```

Add this require to `lib/naver_draft.rb`:

```ruby
require_relative "naver_draft/generator"
```

Create executable `scripts/generate_naver_drafts.rb`:

```ruby
#!/usr/bin/env ruby

require "optparse"
require "pathname"
require "time"
require_relative "../lib/naver_draft"

options = {}
OptionParser.new do |parser|
  parser.on("--paths-file PATH") { |value| options[:paths_file] = value }
  parser.on("--source-commit SHA") { |value| options[:source_commit] = value }
  parser.on("--generated-at TIME") { |value| options[:generated_at] = value }
end.parse!

abort "--paths-file is required" unless options[:paths_file]
abort "--source-commit is required" unless options[:source_commit]

root = Pathname(__dir__).join("..").expand_path
paths = Pathname(options[:paths_file]).read.lines(chomp: true).reject(&:empty?)
generated_at = options[:generated_at] ? Time.iso8601(options[:generated_at]) : Time.now.utc
result = NaverDraft::Generator.new(
  root, source_commit: options[:source_commit], generated_at: generated_at
).generate(paths)

result.created.each { |path| puts "created: #{path}" }
result.skipped_language.each { |path| puts "skipped-language: #{path}" }
result.skipped_existing.each { |path| puts "skipped-existing: #{path}" }
rescue NaverDraft::Error, OptionParser::ParseError, ArgumentError => error
  warn error.message
  exit 1
```

The CLI prints one log line per result:

```text
created: naver-drafts/slug.md
skipped-language: _posts/english.md
skipped-existing: naver-drafts/already-present.md
```

Return 0 for all-created/all-skipped batches and nonzero with a concise error on invalid input.

- [ ] **Step 4: Verify GREEN and run a disposable real-post conversion**

Run:

```bash
ruby -Itest test/naver_draft/generator_test.rb
tmpdir="$(mktemp -d)"
cp -R _config.yml _posts lib scripts "$tmpdir/"
printf '%s\n' '_posts/2026-06-19-why-easy-text-alone-is-not-enough.md' > "$tmpdir/paths.txt"
(cd "$tmpdir" && ruby scripts/generate_naver_drafts.rb --paths-file paths.txt --source-commit abc1234 --generated-at 2026-06-19T00:00:00Z)
test -f "$tmpdir/naver-drafts/why-easy-text-alone-is-not-enough.md"
```

Expected: tests pass, the CLI prints one `created:` line, and the disposable draft exists.

- [ ] **Step 5: Commit generator**

```bash
git add lib/naver_draft.rb lib/naver_draft/generator.rb scripts/generate_naver_drafts.rb test/naver_draft/generator_test.rb
git commit -m "feat: generate Naver drafts atomically"
```

### Task 5: Keep draft files out of the public Jekyll build

**Files:**
- Modify: `scripts/verify_site.rb`
- Modify: `_config.yml`

- [ ] **Step 1: Add a failing public-build assertion**

In `scripts/verify_site.rb`, after the expected file checks, add:

```ruby
published_drafts = Dir.glob(SITE.join("naver-drafts/**/*"), File::FNM_DOTMATCH).reject do |path|
  %w[. ..].include?(File.basename(path))
end
unless published_drafts.empty?
  errors << "naver-drafts: review files must be excluded from the public site"
end
```

Create a temporary `naver-drafts/visibility-check.md` with front matter and build the site.

- [ ] **Step 2: Verify RED**

Run:

```bash
mkdir -p naver-drafts
printf '%s\n' '---' 'title: Visibility check' '---' 'private review draft' > naver-drafts/visibility-check.md
JEKYLL_ENV=production bundle exec jekyll build --trace
ruby scripts/verify_site.rb
```

Expected: FAIL with `naver-drafts: review files must be excluded from the public site`.

- [ ] **Step 3: Exclude drafts and verify GREEN**

Add `naver-drafts` to `_config.yml` under `exclude`. Rebuild and run `ruby scripts/verify_site.rb`; expect `Site verification passed`. Remove only the temporary `naver-drafts/visibility-check.md` and remove the directory if empty.

- [ ] **Step 4: Commit public-site protection**

```bash
git add _config.yml scripts/verify_site.rb
git commit -m "fix: exclude Naver drafts from public site"
```

### Task 6: Automate branch and review PR creation

**Files:**
- Create: `.github/workflows/create-naver-draft.yml`

- [ ] **Step 1: Write the workflow with least privilege**

Create `.github/workflows/create-naver-draft.yml`:

```yaml
name: Create Naver blog draft

on:
  push:
    branches: [main]
    paths: ["_posts/**"]

permissions:
  contents: write
  pull-requests: write

concurrency:
  group: naver-draft-automation
  cancel-in-progress: false

jobs:
  create-draft:
    runs-on: ubuntu-latest
    steps:
      - name: Check out source commit
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: "3.3"
          bundler-cache: true

      - name: Run draft generator tests
        run: ruby -Itest -e 'Dir["test/**/*_test.rb"].sort.each { |file| require File.expand_path(file) }'

      - name: Find new posts
        id: posts
        env:
          BEFORE_SHA: ${{ github.event.before }}
          AFTER_SHA: ${{ github.sha }}
        run: |
          ruby scripts/list_new_posts.rb "$BEFORE_SHA" "$AFTER_SHA" > "$RUNNER_TEMP/new-posts.txt"
          if [[ -s "$RUNNER_TEMP/new-posts.txt" ]]; then
            echo "found=true" >> "$GITHUB_OUTPUT"
          else
            echo "found=false" >> "$GITHUB_OUTPUT"
          fi

      - name: Generate review drafts
        if: steps.posts.outputs.found == 'true'
        run: |
          ruby scripts/generate_naver_drafts.rb \
            --paths-file "$RUNNER_TEMP/new-posts.txt" \
            --source-commit "$GITHUB_SHA"

      - name: Detect generated files
        if: steps.posts.outputs.found == 'true'
        id: drafts
        run: |
          if [[ -n "$(git status --porcelain -- naver-drafts)" ]]; then
            echo "created=true" >> "$GITHUB_OUTPUT"
          else
            echo "created=false" >> "$GITHUB_OUTPUT"
          fi

      - name: Commit generated drafts
        if: steps.drafts.outputs.created == 'true'
        id: commit
        run: |
          branch="automation/naver-draft-${GITHUB_SHA::7}"
          git config user.name "github-actions[bot]"
          git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
          git switch -c "$branch"
          git add -- naver-drafts
          git diff --cached --name-only > "$RUNNER_TEMP/generated-drafts.txt"
          git commit -m "chore: create Naver review draft"
          git push --force-with-lease origin "HEAD:refs/heads/$branch"
          echo "branch=$branch" >> "$GITHUB_OUTPUT"

      - name: Open review pull request
        if: steps.drafts.outputs.created == 'true'
        env:
          GH_TOKEN: ${{ github.token }}
          BRANCH: ${{ steps.commit.outputs.branch }}
        run: |
          {
            echo "## 생성된 네이버 블로그 초안"
            echo
            while IFS= read -r path; do echo "- \`$path\`"; done < "$RUNNER_TEMP/generated-drafts.txt"
            echo
            echo "이 PR은 네이버에 글을 게시하지 않습니다. 검수 후 병합하고 복사 영역을 네이버 편집기에 직접 붙여 넣어 주세요."
            echo
            echo "## 검수 체크리스트"
            echo
            echo "- [ ] 제목과 본문 의미가 원문과 같습니다."
            echo "- [ ] 문단과 소제목이 읽기 좋습니다."
            echo "- [ ] 링크와 이미지 URL이 올바릅니다."
            echo "- [ ] 해시태그가 적절합니다."
            echo "- [ ] 네이버 미리보기에서 최종 레이아웃을 확인했습니다."
          } > "$RUNNER_TEMP/naver-pr.md"

          existing="$(gh pr list --head "$BRANCH" --state open --json url --jq '.[0].url')"
          if [[ -n "$existing" ]]; then
            echo "$existing"
          else
            gh pr create \
              --base main \
              --head "$BRANCH" \
              --title "네이버 블로그 초안 검수" \
              --body-file "$RUNNER_TEMP/naver-pr.md"
          fi
```

The fixed SHA-derived branch makes reruns idempotent. It is automation-owned, so force-with-lease is restricted to that exact branch. The workflow stages only `naver-drafts/`; checkout credentials, tokens, and temporary path lists never enter the commit. Do not use `pull_request_target`.

- [ ] **Step 2: Validate workflow syntax and commands locally**

Run:

```bash
ruby -e 'require "yaml"; YAML.load_file(".github/workflows/create-naver-draft.yml"); puts "workflow YAML parsed"'
ruby -Itest -e 'Dir["test/**/*_test.rb"].sort.each { |file| require File.expand_path(file) }'
git diff --check
```

Expected: YAML parses, all tests pass, and diff check is clean.

- [ ] **Step 3: Commit workflow**

```bash
git add .github/workflows/create-naver-draft.yml
git commit -m "ci: open Naver draft review pull requests"
```

### Task 7: Document setup and the human publishing boundary

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Add operator documentation**

Add a `## 네이버 블로그 초안 자동화` section documenting:

- trigger: only newly added Korean `_posts/*.md` on `main`;
- output: review PR containing `naver-drafts/<slug>.md`;
- non-goals: no AI rewrite, no Naver login, no automatic publication;
- GitHub setup: Settings → Actions → General → Workflow permissions → Read and write permissions, and enable allowing GitHub Actions to create pull requests;
- local tests: `ruby -Itest -e 'Dir["test/**/*_test.rb"].sort.each { |file| require File.expand_path(file) }'`;
- local dry run using a path list and a temporary copy so tracked drafts are not created accidentally;
- review sequence: inspect PR, edit if necessary, merge, copy the marked region, paste into Naver, verify preview, publish manually.

State explicitly that the GitHub post remains the source of truth even when the Naver copy is edited for layout.

- [ ] **Step 2: Verify documentation commands and links**

Run every local command copied into README, then run `rg -n "Workflow permissions|자동 게시|source of truth|원본" README.md`.

Expected: commands exit 0 and the setup, boundary, and source-of-truth statements are present.

- [ ] **Step 3: Commit documentation**

```bash
git add README.md
git commit -m "docs: explain Naver draft review workflow"
```

### Task 8: Final end-to-end verification

**Files:**
- Verify all files changed above

- [ ] **Step 1: Run the complete automated suite**

```bash
ruby -Itest -e 'Dir["test/**/*_test.rb"].sort.each { |file| require File.expand_path(file) }'
JEKYLL_ENV=production bundle exec jekyll build --trace
ruby scripts/verify_site.rb
ruby scripts/verify_pinned_home.rb
git diff --check
```

Expected: all Minitest cases pass, Jekyll exits 0, both verifiers print their success messages, and diff check is clean.

- [ ] **Step 2: Exercise the full pipeline in a disposable git clone**

Create a temporary clone of the working repository, add one Korean fixture and one English fixture in a new commit, obtain the before/after SHAs, run the detector into a path file, and run the generator with a fixed timestamp. Assert:

```text
detector output contains both newly added posts
generator output contains one created line and one skipped-language line
only the Korean naver-drafts/<slug>.md exists
git status lists no modified _posts files
```

Inspect the generated Korean draft and confirm its source URL, source commit, heading without `{#id}`, expanded link, absolute image URL, and hashtags.

- [ ] **Step 3: Review repository scope**

Run:

```bash
git status --short
git log --oneline --decorate -10
git diff origin/main...HEAD --stat
```

Expected: only the planned automation, tests, config, and documentation changes appear; the user's existing `.superpowers/` directory remains untouched and untracked.
