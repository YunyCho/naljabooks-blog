# English Essay Authorship Clarification Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Identify 조윤영 as the English essay's author, disclose that she wrote the Korean original and translated it into English, and relabel Substack as the first publication location.

**Architecture:** Change only the English essay's front matter, provenance note, and structured publication label. Generalize the existing post verifier just enough to support both `Person` and `Organization` authors, then verify the generated JSON-LD and visible copy before deploying through the existing GitHub Pages pipeline.

**Tech Stack:** Jekyll, YAML front matter, Kramdown, Ruby verification script, GitHub Pages

---

### Task 1: Define the corrected authorship contract

**Files:**
- Modify: `scripts/verify_site.rb`
- Test: `scripts/verify_site.rb`

- [ ] **Step 1: Describe the English essay's Person author**

Change the English essay entry in `POSTS` to:

```ruby
  "archive/at-the-edge-of-intelligence-we-find-what-it-means-to-be-human/index.html" => {
    author: "조윤영",
    author_type: "Person",
    required_text: "At the edge of intelligence, we will at last discover the heart.",
    anchors: %w[prologue chapter-1 chapter-2 chapter-3 chapter-4 chapter-5 epilogue],
    source_count: 1
  },
```

- [ ] **Step 2: Generalize structured-author verification**

Replace the hard-coded Organization assertion inside `POSTS.each` with:

```ruby
  author_type = expectations.fetch(:author_type, "Organization")
  unless html.include?(%("author":{"@type":"#{author_type}"))
    errors << "#{path}: structured author must be a #{author_type}"
  end
```

This keeps all existing organization-authored posts unchanged while allowing the essay to use a truthful `Person` author.

- [ ] **Step 3: Add provenance assertions**

In the English essay marker hash, replace the source marker with:

```ruby
    "authorship note" => "Originally written in Korean and translated into English by the author.",
    "first publication link" => "First published on Substack"
```

After the marker loop, add:

```ruby
  errors << "#{english_essay_path}: obsolete account-name byline remains" if html.include?(">NaljaBook<")
  errors << "#{english_essay_path}: Substack is mislabeled as an external source" if html.include?("Original Substack essay")
```

- [ ] **Step 4: Build and verify the new requirements fail**

Run:

```bash
JEKYLL_ENV=production bundle exec jekyll build --trace
ruby scripts/verify_site.rb
```

Expected: build succeeds; verification fails for visible author, structured `Person` author, authorship note, and first-publication label.

- [ ] **Step 5: Commit the failing contract**

```bash
git add scripts/verify_site.rb
git commit -m "test: define English essay authorship"
```

### Task 2: Correct the article authorship and provenance

**Files:**
- Modify: `_posts/2026-06-19-at-the-edge-of-intelligence-we-find-what-it-means-to-be-human.md`
- Test: `scripts/verify_site.rb`

- [ ] **Step 1: Replace the author object**

Use:

```yaml
author:
  name: "조윤영"
  url: "https://naljabooks.com"
  type: Person
```

- [ ] **Step 2: Relabel the publication link**

Use:

```yaml
sources:
  - title: "First published on Substack"
    organization: "NaljaBooks"
    year: 2026
    url: "https://naljabooks.substack.com/p/at-the-edge-of-intelligence-we-find"
```

- [ ] **Step 3: Add the visible authorship note**

Immediately after the closing front-matter delimiter and before `## Contents`, add:

```markdown
*Originally written in Korean and translated into English by the author.*
```

Do not change any source-essay paragraph.

- [ ] **Step 4: Run complete local verification**

Run:

```bash
JEKYLL_ENV=production bundle exec jekyll build --trace
ruby scripts/verify_site.rb
ruby scripts/verify_pinned_home.rb
git diff --check
```

Expected: build exits 0, both verification scripts pass, and the diff check is empty.

- [ ] **Step 5: Inspect generated author data**

Run:

```bash
rg -n '조윤영|"author":\{"@type":"Person"|Originally written in Korean|First published on Substack|NaljaBook|Original Substack essay' _site/archive/at-the-edge-of-intelligence-we-find-what-it-means-to-be-human/index.html
```

Expected: the Person author, note, and first-publication label appear; the obsolete byline and label do not.

- [ ] **Step 6: Commit the correction**

```bash
git add _posts/2026-06-19-at-the-edge-of-intelligence-we-find-what-it-means-to-be-human.md
git commit -m "fix: clarify English essay authorship"
```

### Task 3: Deploy and verify the public correction

**Files:**
- Verify: public homepage and English essay

- [ ] **Step 1: Merge and reverify on `main`**

Fast-forward the feature branch into `main`, rerun Task 2 Step 4 from the main workspace, and preserve the user's untracked `.superpowers/` directory.

- [ ] **Step 2: Push and wait for GitHub Pages**

Push `origin/main`, then wait for the new `pages-build-deployment` run to complete successfully.

- [ ] **Step 3: Verify the live article**

Request the public article and confirm:

```text
visible author: 조윤영
JSON-LD author type: Person
authorship note: Originally written in Korean and translated into English by the author.
publication label: First published on Substack
obsolete byline absent: NaljaBook
obsolete label absent: Original Substack essay
```

Also confirm the homepage still pins the declaration and keeps the English essay first on the right.
