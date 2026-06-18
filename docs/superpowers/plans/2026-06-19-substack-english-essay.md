# Substack English Essay Publication Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Publish the complete English Substack essay as a 2026-06-19 Nalja Archive post with correct language metadata, archive placement, discovery files, and terminology.

**Architecture:** Keep the essay in one repository-native Jekyll post and reuse the existing post, SEO, source-list, feed, and sitemap pipeline. Add page-level language support through one fallback expression in the default layout, and extend the generated-site verifier before adding the post so publication, preservation, and discovery requirements are covered by a red-green cycle.

**Tech Stack:** Jekyll, Liquid, Kramdown, YAML front matter, Ruby verification scripts, GitHub Pages

---

### Task 1: Define the English publication contract

**Files:**
- Modify: `scripts/verify_site.rb`
- Test: `scripts/verify_site.rb`

- [ ] **Step 1: Register the essay and required structure**

Add this entry at the beginning of `POSTS`:

```ruby
  "archive/at-the-edge-of-intelligence-we-find-what-it-means-to-be-human/index.html" => {
    author: "NaljaBook",
    required_text: "At the edge of intelligence, we will at last discover the heart.",
    anchors: %w[prologue chapter-1 chapter-2 chapter-3 chapter-4 chapter-5 epilogue],
    source_count: 1
  },
```

The optional `source_count` assertion already exists and must remain shared with the easy-text article.

- [ ] **Step 2: Add English metadata and preservation assertions**

After the existing easy-text discovery checks, add:

```ruby
english_essay_path = "archive/at-the-edge-of-intelligence-we-find-what-it-means-to-be-human/index.html"
english_essay_url = "https://yunycho.github.io/naljabooks-blog/archive/at-the-edge-of-intelligence-we-find-what-it-means-to-be-human/"
english_essay = SITE.join(english_essay_path)

if english_essay.file?
  html = english_essay.read
  {
    "English document language" => '<html lang="en">',
    "Open Graph title" => 'property="og:title" content="At the Edge of Intelligence, We Find What It Means to Be Human."',
    "Open Graph description" => 'property="og:description" content="In the Age of AGI, What My Son Will Teach Humanity"',
    "Open Graph URL" => %(property="og:url" content="#{english_essay_url}"),
    "published time" => 'property="article:published_time" content="2026-06-19T00:00:00+09:00"',
    "canonical URL" => %(rel="canonical" href="#{english_essay_url}"),
    "JSON-LD dateModified" => '"dateModified":"2026-06-19T00:00:00+09:00"',
    "JSON-LD datePublished" => '"datePublished":"2026-06-19T00:00:00+09:00"',
    "JSON-LD mainEntityOfPage" => %("@id":"#{english_essay_url}"),
    "source essay" => "https://naljabooks.substack.com/p/at-the-edge-of-intelligence-we-find"
  }.each do |label, marker|
    errors << "#{english_essay_path}: missing #{label}" unless html.include?(marker)
  end

  article_body = html[%r{<div class="article-body">.*?</div>}m].to_s
  {
    "prologue opening" => "It was a summer day.",
    "final signature" => "At the beginning of the Nalza Project",
    "intellectual-disability terminology" => "people with intellectual disabilities"
  }.each do |label, marker|
    errors << "#{english_essay_path}: missing #{label}" unless article_body.include?(marker)
  end
  errors << "#{english_essay_path}: developmental-disability terminology remains" if article_body.match?(/developmental disabilit/i)
  errors << "#{english_essay_path}: Substack subscription prompt leaked into article" if article_body.include?("Thanks for reading NaljaBooks's Substack!")
end

%w[sitemap.xml feed.xml].each do |path|
  next unless SITE.join(path).file?
  errors << "#{path}: missing English essay" unless SITE.join(path).read.include?(english_essay_url)
end
```

- [ ] **Step 3: Assert newest-right placement without weakening pinned-home checks**

Inside the homepage verification block, after `first_regular_story` is assigned, change the first-item expectation to:

```ruby
  unless first_regular_story&.include?("At the Edge of Intelligence, We Find What It Means to Be Human.")
    errors << "index.html: English essay is not the newest regular story"
  end
  unless story_list.include?("쉬운 글만으로 충분하지 않은 이유")
    errors << "index.html: easy-text article is missing from the right story list"
  end
```

Keep the declaration badge, single-occurrence, and analogy-post assertions unchanged.

- [ ] **Step 4: Build and prove the contract is red**

Run:

```bash
JEKYLL_ENV=production bundle exec jekyll build --trace
ruby scripts/verify_site.rb
```

Expected: the build succeeds, then verification fails for the missing essay, homepage placement, sitemap, and feed.

- [ ] **Step 5: Commit the failing publication contract**

```bash
git add scripts/verify_site.rb
git commit -m "test: define Substack essay publication"
```

### Task 2: Add page-level English language support

**Files:**
- Modify: `_layouts/default.html`
- Test: `scripts/verify_site.rb`

- [ ] **Step 1: Make the HTML language page-aware**

Replace:

```liquid
<html lang="{{ site.lang | default: 'ko-KR' }}">
```

with:

```liquid
<html lang="{{ page.lang | default: site.lang | default: 'ko-KR' }}">
```

- [ ] **Step 2: Confirm existing Korean pages stay Korean**

Add this check in the homepage verification block:

```ruby
  errors << 'index.html: site language changed from Korean' unless html.include?('<html lang="ko-KR">')
```

- [ ] **Step 3: Build and inspect the fallback behavior**

Run:

```bash
JEKYLL_ENV=production bundle exec jekyll build --trace
rg -n '<html lang=' _site/index.html _site/archive/why-easy-text-alone-is-not-enough/index.html
```

Expected: both existing documents contain `<html lang="ko-KR">`. The overall verifier still fails only because the English post is not present yet.

- [ ] **Step 4: Commit language support**

```bash
git add _layouts/default.html scripts/verify_site.rb
git commit -m "feat: support per-page document language"
```

### Task 3: Adapt the complete Substack essay into a Jekyll post

**Files:**
- Read: `https://naljabooks.substack.com/p/at-the-edge-of-intelligence-we-find`
- Create: `_posts/2026-06-19-at-the-edge-of-intelligence-we-find-what-it-means-to-be-human.md`

- [ ] **Step 1: Create exact repository-native front matter**

Use:

```yaml
---
layout: post
lang: en
title: "At the Edge of Intelligence, We Find What It Means to Be Human."
description: "In the Age of AGI, What My Son Will Teach Humanity"
date: 2026-06-19
updated: 2026-06-19
author:
  name: "NaljaBook"
  url: "https://naljabooks.substack.com"
  type: Organization
category: "AI and Human Dignity"
tags: ["AGI", "intellectual disability", "humanity", "analogy", "Nalja Project"]
toc:
  - id: prologue
    title: "Prologue · Wild Strawberries and the Buddha"
  - id: chapter-1
    title: "Chapter 1 · From Thinking Beings to Feeling Beings"
  - id: chapter-2
    title: "Chapter 2 · The End of Efficiency and the Triumph of Being"
  - id: chapter-3
    title: "Chapter 3 · Wild Analogies and the Uncorrupted Gaze"
  - id: chapter-4
    title: "Chapter 4 · The Hyper-Sensor — Hearing the World’s Whispers"
  - id: chapter-5
    title: "Chapter 5 · Humanity’s North Star"
  - id: epilogue
    title: "Epilogue · Dreaming of a Cognitive Rehabilitation Center"
sources:
  - title: "Original Substack essay"
    organization: "NaljaBook"
    year: 2026
    url: "https://naljabooks.substack.com/p/at-the-edge-of-intelligence-we-find"
---
```

- [ ] **Step 2: Transfer only the authored essay**

Use the source article's visible text in this exact boundary:

```text
Start: Contents
First prose paragraph: It was a summer day.
End: At the beginning of the Nalza Project
```

Exclude every occurrence of these Substack interface strings:

```text
Thanks for reading NaljaBooks's Substack! Subscribe for free to receive new posts and support my work.
Discover more from NaljaBooks's Substack
Type your email...
Like
Share
Discussion about this post
Ready for more?
```

Preserve all authored prose paragraphs, quotations, subsection titles, and `◆ ◆ ◆` separators between the stated boundaries.

- [ ] **Step 3: Map the seven major sections to stable anchors**

Replace the source's repeated uppercase major labels and titles with these Kramdown headings while preserving every subsection beneath them:

```markdown
## PROLOGUE · Wild Strawberries and the Buddha {#prologue}
## CHAPTER ONE · From Thinking Beings to Feeling Beings {#chapter-1}
## CHAPTER TWO · The End of Efficiency and the Triumph of Being {#chapter-2}
## CHAPTER THREE · Wild Analogies and the Uncorrupted Gaze {#chapter-3}
## CHAPTER FOUR · The Hyper-Sensor — Hearing the World’s Whispers {#chapter-4}
## CHAPTER FIVE · Humanity’s North Star {#chapter-5}
## EPILOGUE · Dreaming of a Cognitive Rehabilitation Center {#epilogue}
```

Render subsection labels such as `The End of Descartes`, `Pristine Authenticity`, `The Aesthetics of Slowness`, `The Contribution of Sheer Existence`, `The Intelligence That Destroys Categories`, `A Gaze Without Borders Between the Sacred and the Ordinary`, `Sensitivity as a Superpower`, `The Density of Observation`, `The Collapse of Standards`, and `The Anchor of Humanity` as level-three headings.

- [ ] **Step 4: Apply the sole editorial terminology change**

Within the article body only, apply these replacements while leaving every other sentence untouched:

```text
people with developmental disabilities → people with intellectual disabilities
developmental disabilities → intellectual disabilities
developmental disability → intellectual disability
```

Run:

```bash
rg -n -i 'developmental disabilit|Thanks for reading|Subscribe|Discussion about this post|Ready for more' _posts/2026-06-19-at-the-edge-of-intelligence-we-find-what-it-means-to-be-human.md
```

Expected: no matches.

- [ ] **Step 5: Build and run all repository verifiers**

Run:

```bash
JEKYLL_ENV=production bundle exec jekyll build --trace
ruby scripts/verify_site.rb
ruby scripts/verify_pinned_home.rb
git diff --check
```

Expected: build exits 0, `Site verification passed`, `Pinned homepage integration verification passed`, and no diff errors.

- [ ] **Step 6: Commit the English essay**

```bash
git add _posts/2026-06-19-at-the-edge-of-intelligence-we-find-what-it-means-to-be-human.md
git commit -m "feat: publish Substack English essay"
```

### Task 4: Verify generated and public publication artifacts

**Files:**
- Verify: `_site/archive/at-the-edge-of-intelligence-we-find-what-it-means-to-be-human/index.html`
- Verify: `_site/index.html`
- Verify: `_site/sitemap.xml`
- Verify: `_site/feed.xml`

- [ ] **Step 1: Inspect generated metadata and preservation markers**

Run:

```bash
rg -n '<html lang="en">|<title>|meta name="description"|rel="canonical"|og:title|og:description|og:url|article:published_time|datePublished|dateModified|mainEntityOfPage|id="(prologue|chapter-[1-5]|epilogue)"|Original Substack essay|At the beginning of the Nalza Project|developmental disabilit|Thanks for reading' _site/archive/at-the-edge-of-intelligence-we-find-what-it-means-to-be-human/index.html
```

Expected: English language, metadata, seven section IDs, source, and final signature appear; prohibited terminology and subscription prompt do not appear.

- [ ] **Step 2: Inspect homepage ordering and discovery files**

Run:

```bash
rg -n 'featured-story|고정 선언문|story-list|At the Edge of Intelligence|쉬운 글만으로 충분하지 않은 이유' _site/index.html
rg -n 'archive/at-the-edge-of-intelligence-we-find-what-it-means-to-be-human' _site/sitemap.xml _site/feed.xml
```

Expected: the declaration is still featured, the essay is first on the right, the easy-text article follows, and both discovery files contain the essay URL.

- [ ] **Step 3: Merge, verify, and deploy**

After the implementation branch is approved, fast-forward it into `main`, rerun the full Task 3 verification commands from `main`, and push `origin/main`. Do not modify or include the user's untracked `.superpowers/` directory.

- [ ] **Step 4: Verify GitHub Pages**

Wait for the Pages deployment workflow to succeed. Then verify the live homepage and article for the same title, ordering, `lang="en"`, canonical URL, published date, final signature, one source, and prohibited-term absence. Directly request the public `sitemap.xml` and `feed.xml` and confirm the essay URL appears in both.
