# English Essay Parallel Publication Note Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remove the English essay's source section and mention Substack only as a linked parallel-publication note.

**Architecture:** Make source visibility optional in the shared generated-site verifier, with existing research posts continuing to require sources. Remove only this essay's `sources` front matter and extend its existing authorship note with a direct Substack link.

**Tech Stack:** Jekyll, Kramdown, YAML front matter, Ruby verification script, GitHub Pages

---

### Task 1: Define the no-source publication contract

**Files:**
- Modify: `scripts/verify_site.rb`

- [ ] Set the English essay expectation to `requires_sources: false` and remove `source_count: 1`.
- [ ] Change the shared source check to run unless `requires_sources` is explicitly false:

```ruby
  if expectations.fetch(:requires_sources, true)
    errors << "#{path}: missing visible sources" unless html.include?('id="sources"')
  elsif html.include?('id="sources"')
    errors << "#{path}: source section must not be rendered"
  end
```

- [ ] Require the exact linked note and reject obsolete labels:

```ruby
    "parallel publication note" => 'Originally written in Korean and translated into English by the author. Also published on <a href="https://naljabooks.substack.com/p/at-the-edge-of-intelligence-we-find">Substack</a>.'
```

```ruby
  errors << "#{english_essay_path}: obsolete first-publication label remains" if html.include?("First published on Substack")
  errors << "#{english_essay_path}: obsolete source label remains" if html.include?("Original Substack essay")
```

- [ ] Run the production build and `ruby scripts/verify_site.rb`; confirm failure for the rendered source section and missing linked note.
- [ ] Commit as `test: define English essay source removal`.

### Task 2: Remove the source and add the linked note

**Files:**
- Modify: `_posts/2026-06-19-at-the-edge-of-intelligence-we-find-what-it-means-to-be-human.md`

- [ ] Delete the complete `sources:` block.
- [ ] Replace the current note with:

```markdown
*Originally written in Korean and translated into English by the author. Also published on [Substack](https://naljabooks.substack.com/p/at-the-edge-of-intelligence-we-find).*
```

- [ ] Run:

```bash
JEKYLL_ENV=production bundle exec jekyll build --trace
ruby scripts/verify_site.rb
ruby scripts/verify_pinned_home.rb
git diff --check
```

- [ ] Confirm the generated essay has no `id="sources"`, contains the linked note, and retains author `조윤영` with JSON-LD type `Person`.
- [ ] Commit as `fix: remove source section from English essay`.

### Task 3: Deploy and verify

- [ ] Fast-forward the feature branch into `main` and rerun all Task 2 verification commands.
- [ ] Push `origin/main` and wait for GitHub Pages deployment success.
- [ ] Verify the live article contains the linked parallel-publication note and no source section or obsolete source labels.
