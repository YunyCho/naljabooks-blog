# Pinned Declaration Homepage Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Keep the AI declaration permanently in the homepage's left mint card while automatically stacking every other post newest-first in the right column.

**Architecture:** Mark the declaration post with a boolean `pinned` front-matter field, then derive pinned and regular collections in Liquid instead of relying on post position. Extend the generated-site verifier for the current invariant and add an integration verifier that temporarily publishes a newer fixture post to prove future posts accumulate on the right without displacing or duplicating the declaration.

**Tech Stack:** Jekyll, Liquid, Markdown front matter, Ruby, Open3, temporary filesystem fixtures

---

### Task 1: Define pinned-homepage invariants

**Files:**
- Modify: `scripts/verify_site.rb`
- Create: `scripts/verify_pinned_home.rb`
- Test: `scripts/verify_site.rb`
- Test: `scripts/verify_pinned_home.rb`

- [ ] **Step 1: Add failing source and generated-page assertions**

Add this source check after `errors = []` in `scripts/verify_site.rb`:

```ruby
pinned_posts = Dir.glob(ROOT.join("_posts/*")).select do |file|
  File.read(file).match?(/^pinned:\s*true\s*$/)
end
unless pinned_posts.length == 1
  errors << "posts: expected exactly one pinned declaration, found #{pinned_posts.length}"
end
```

Inside the existing `if home.file?` block, add:

```ruby
  declaration_path = "/naljabooks-blog/archive/ai-must-benefit-people-with-intellectual-disabilities/"
  featured_story = html[%r{<article class="featured-story">.*?</article>}m]
  story_list = html[%r{<div class="story-list".*?</div>}m]

  unless featured_story&.include?(declaration_path)
    errors << "index.html: pinned declaration is not in the featured story"
  end
  unless featured_story&.include?("고정 선언문")
    errors << "index.html: pinned declaration badge is missing"
  end
  unless html.scan(%(href="#{declaration_path}")).length == 1
    errors << "index.html: pinned declaration must appear exactly once"
  end
  unless story_list&.include?("지적장애인에게 왜 유추력이 필요할까?")
    errors << "index.html: regular post is missing from the right story list"
  end
```

- [ ] **Step 2: Add a future-post integration verifier**

Create `scripts/verify_pinned_home.rb` with:

```ruby
#!/usr/bin/env ruby

require "fileutils"
require "open3"
require "pathname"
require "tmpdir"

ROOT = Pathname.new(__dir__).join("..").expand_path
FIXTURE_POST = ROOT.join("_posts/2026-06-18-pinned-home-fixture.md")
DECLARATION_PATH = "/naljabooks-blog/archive/ai-must-benefit-people-with-intellectual-disabilities/"
FIXTURE_TITLE = "새 글 누적 검증"
REGULAR_TITLE = "지적장애인에게 왜 유추력이 필요할까?"

fixture = <<~MARKDOWN
  ---
  layout: post
  title: "#{FIXTURE_TITLE}"
  description: "새 글이 오른쪽 목록에 누적되는지 검증하는 임시 게시물입니다."
  date: 2026-06-18 00:00:00 +0900
  category: "검증"
  ---
  임시 검증 글입니다.
MARKDOWN

begin
  FIXTURE_POST.write(fixture)

  Dir.mktmpdir("nalja-pinned-home-") do |destination|
    stdout, stderr, status = Open3.capture3(
      { "JEKYLL_ENV" => "production" },
      "bundle", "exec", "jekyll", "build", "--trace",
      "--destination", destination,
      chdir: ROOT.to_s
    )
    abort [stdout, stderr].join("\n") unless status.success?

    html = Pathname.new(destination).join("index.html").read
    featured_story = html[%r{<article class="featured-story">.*?</article>}m]
    story_list = html[%r{<div class="story-list".*?</div>}m]
    errors = []

    errors << "fixture: declaration left the featured card" unless featured_story&.include?(DECLARATION_PATH)
    errors << "fixture: declaration is duplicated" unless html.scan(%(href="#{DECLARATION_PATH}")).length == 1
    errors << "fixture: new post is missing from the right list" unless story_list&.include?(FIXTURE_TITLE)
    errors << "fixture: existing regular post is missing" unless story_list&.include?(REGULAR_TITLE)

    if story_list&.include?(FIXTURE_TITLE) && story_list.include?(REGULAR_TITLE)
      errors << "fixture: new post is not first in the right list" unless story_list.index(FIXTURE_TITLE) < story_list.index(REGULAR_TITLE)
    end

    abort errors.join("\n") unless errors.empty?
  end

  puts "Pinned homepage integration verification passed"
ensure
  FileUtils.rm_f(FIXTURE_POST)
end
```

- [ ] **Step 3: Build and run both verifiers to confirm failure**

Run:

```bash
JEKYLL_ENV=production bundle exec jekyll build --trace
ruby scripts/verify_site.rb
ruby scripts/verify_pinned_home.rb
```

Expected: the build succeeds; both verifiers fail because no post is pinned and the homepage still selects `site.posts.first`.

- [ ] **Step 4: Commit the failing requirements**

```bash
git add scripts/verify_site.rb scripts/verify_pinned_home.rb
git commit -m "test: define pinned declaration homepage behavior"
```

### Task 2: Pin the declaration and separate regular posts

**Files:**
- Modify: `_posts/2026-06-15-ai-must-benefit-people-with-intellectual-disabilities.md`
- Modify: `index.html`

- [ ] **Step 1: Mark the declaration as pinned**

Add this field to the declaration post front matter after `updated`:

```yaml
pinned: true
```

- [ ] **Step 2: Derive pinned and regular collections in Liquid**

Replace the positional `featured_post` assignment in `index.html` with:

```liquid
{% assign pinned_posts = site.posts | where: "pinned", true %}
{% assign featured_post = pinned_posts.first %}
{% assign regular_posts = site.posts | where_exp: "post", "post.pinned != true" %}
```

Replace the featured badge:

```html
<span>고정 선언문</span>
```

Replace the right-list condition and loop with:

```liquid
{% if regular_posts.size > 0 %}
  <div class="story-list" aria-label="이어지는 글">
    {% for post in regular_posts %}
      <article class="story-list-item">
        <p class="story-category">{{ post.category }}</p>
        <h3><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h3>
        <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%Y.%m.%d" }}</time>
      </article>
    {% endfor %}
  </div>
{% endif %}
```

- [ ] **Step 3: Run the production and future-post verifications**

Run:

```bash
JEKYLL_ENV=production bundle exec jekyll build --trace
ruby scripts/verify_site.rb
ruby scripts/verify_pinned_home.rb
git diff --check
```

Expected: production build exits 0, the site verifier prints `Site verification passed`, the integration verifier prints `Pinned homepage integration verification passed`, and `git diff --check` prints nothing.

- [ ] **Step 4: Confirm the integration fixture cleaned itself up**

Run:

```bash
test ! -e _posts/2026-06-18-pinned-home-fixture.md
git status --short
```

Expected: the fixture test exits 0 and Git reports only the two intended implementation files plus the already committed test files.

- [ ] **Step 5: Commit the implementation**

```bash
git add index.html _posts/2026-06-15-ai-must-benefit-people-with-intellectual-disabilities.md
git commit -m "feat: pin declaration on homepage"
```

### Task 3: Verify the rendered layout and future publishing contract

**Files:**
- Verify: `_site/index.html`
- Verify: `index.html`
- Verify: `_posts/2026-06-15-ai-must-benefit-people-with-intellectual-disabilities.md`

- [ ] **Step 1: Inspect the generated ordering markers**

Run:

```bash
rg -n "featured-story|고정 선언문|AI must benefit people with intellectual disabilities|story-list|지적장애인에게 왜 유추력이 필요할까" _site/index.html
```

Expected: the declaration title and `고정 선언문` occur inside `featured-story`; the analogy post occurs after `story-list` begins.

- [ ] **Step 2: Verify the publishing contract in source**

Run:

```bash
rg -n "pinned: true|where: \"pinned\"|where_exp|for post in regular_posts" _posts/2026-06-15-ai-must-benefit-people-with-intellectual-disabilities.md index.html
```

Expected: exactly one post contains `pinned: true`; the homepage derives the pinned post and loops over `regular_posts` without an offset.

- [ ] **Step 3: Run the full final verification**

Run:

```bash
JEKYLL_ENV=production bundle exec jekyll build --trace
ruby scripts/verify_site.rb
ruby scripts/verify_pinned_home.rb
git diff --check
```

Expected: all commands exit 0 with both verifier success messages.

