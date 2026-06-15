# Nalja Archive Blog Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build and verify the first deployable version of the Korean-language Nalja Archive Jekyll blog, including its core pages, first sourced article, metadata, crawler files, and GitHub Pages configuration.

**Architecture:** Use the GitHub Pages-supported Jekyll stack with a small custom theme. Content lives in Markdown/front matter, Liquid includes own reusable presentation, and a standalone Ruby verification script inspects the generated `_site` output so metadata and path regressions fail locally.

**Tech Stack:** Ruby, Bundler, GitHub Pages/Jekyll, Liquid, HTML5, CSS, JSON-LD, Minitest-free Ruby verification

---

## File Map

- `_config.yml`: site identity, GitHub Pages URL/baseurl, plugins, defaults, and SEO settings.
- `Gemfile`: GitHub Pages-compatible dependency entry point.
- `index.html`: home page hero, topic overview, editorial promise, and recent posts.
- `about.md`, `methodology.md`, `questions.md`, `404.html`: initial static pages.
- `_layouts/default.html`: document shell, metadata, skip link, header/footer, and main landmark.
- `_layouts/post.html`: article header, reading time, table of contents, sources, CTA, and BlogPosting JSON-LD.
- `_includes/header.html`, `_includes/footer.html`, `_includes/post-card.html`, `_includes/source-list.html`: reusable UI fragments.
- `_posts/2026-06-15-why-analogy-matters.md`: first researched article.
- `assets/css/main.css`: all responsive visual styling and focus states.
- `assets/images/share-default.svg`: simple brand-owned social preview artwork.
- `robots.txt`, `llms.txt`: crawler guidance.
- `scripts/verify_site.rb`: generated-site assertions for pages, metadata, canonical URLs, JSON-LD, files, placeholders, and baseurl-safe assets.
- `README.md`: local authoring, verification, and GitHub Pages deployment instructions.

### Task 1: Bootstrap the Jekyll project

**Files:**
- Create: `Gemfile`
- Create: `_config.yml`
- Create: `.gitignore`

- [ ] **Step 1: Add the GitHub Pages dependency**

```ruby
source "https://rubygems.org"

gem "github-pages", group: :jekyll_plugins
```

- [ ] **Step 2: Add the production site configuration**

```yaml
title: "날자 아카이브"
tagline: "배움과 선택을 잇는 연구와 실천의 기록"
description: "도서출판 날자와 날자꾸러미가 발달장애인의 배움, 문해력, 유추와 일상 적용을 연구하고 기록하는 전문 아카이브입니다."
lang: ko-KR
url: "https://yunycho.github.io"
baseurl: "/naljabooks-blog"
author:
  name: "도서출판 날자 · 날자꾸러미 편집부"
  url: "https://naljabooks.com"
logo: "/assets/images/share-default.svg"
social:
  name: "도서출판 날자 · 날자꾸러미 편집부"
  links:
    - "https://naljabooks.com"
plugins:
  - jekyll-feed
  - jekyll-seo-tag
  - jekyll-sitemap
permalink: /archive/:title/
timezone: Asia/Seoul
future: false
strict_front_matter: true
defaults:
  - scope:
      path: ""
    values:
      image: "/assets/images/share-default.svg"
  - scope:
      path: ""
      type: posts
    values:
      layout: post
      author: "도서출판 날자 · 날자꾸러미 편집부"
      category: "유추와 문해력"
exclude:
  - docs
  - scripts
  - README.md
  - Gemfile
  - Gemfile.lock
```

- [ ] **Step 3: Ignore generated and local files**

```gitignore
_site/
.jekyll-cache/
.jekyll-metadata
.bundle/
vendor/
```

- [ ] **Step 4: Install dependencies**

Run: `bundle config set --local path vendor/bundle && bundle install`

Expected: Bundler resolves `github-pages` and writes `Gemfile.lock` without dependency errors.

- [ ] **Step 5: Commit the bootstrap**

```bash
git add Gemfile Gemfile.lock _config.yml .gitignore
git commit -m "build: bootstrap Jekyll blog"
```

### Task 2: Add failing generated-site verification

**Files:**
- Create: `scripts/verify_site.rb`

- [ ] **Step 1: Write the verifier before page implementation**

```ruby
#!/usr/bin/env ruby

require "json"
require "pathname"

ROOT = Pathname.new(__dir__).join("..").expand_path
SITE = ROOT.join("_site")
BASEURL = "/naljabooks-blog"
EXPECTED = %w[index.html about/index.html methodology/index.html questions/index.html 404.html sitemap.xml feed.xml robots.txt llms.txt].freeze

errors = []

EXPECTED.each do |path|
  errors << "missing #{path}" unless SITE.join(path).file?
end

Dir.glob(SITE.join("**/*.html")).sort.each do |file|
  html = File.read(file)
  relative = Pathname.new(file).relative_path_from(SITE)
  errors << "#{relative}: missing title" unless html.match?(%r{<title>[^<]+</title>})
  errors << "#{relative}: missing description" unless html.include?('name="description"')
  errors << "#{relative}: missing canonical" unless html.include?('rel="canonical"')
  errors << "#{relative}: root-relative asset bypasses baseurl" if html.match?(%r{(?:href|src)="/(?!naljabooks-blog/|/|https?:)})
end

post = SITE.join("archive/why-analogy-matters/index.html")
if post.file?
  html = post.read
  errors << "post: missing BlogPosting JSON-LD" unless html.include?('"@type":"BlogPosting"')
  errors << "post: missing visible sources" unless html.include?('id="sources"')
end

source_files = Dir.glob(ROOT.join("{*.md,*.html,_posts/*,_includes/*,_layouts/*,robots.txt,llms.txt}"))
source_files.each do |file|
  content = File.read(file)
  errors << "#{Pathname.new(file).relative_path_from(ROOT)}: placeholder text" if content.match?(/\b(?:TBD|TODO)\b|example\.com|임시 URL/i)
end

if errors.empty?
  puts "Site verification passed"
else
  warn errors.join("\n")
  exit 1
end
```

- [ ] **Step 2: Run the verifier and confirm it fails**

Run: `ruby scripts/verify_site.rb`

Expected: FAIL listing missing generated files because `_site` has not been built.

- [ ] **Step 3: Commit the failing verifier**

```bash
git add scripts/verify_site.rb
git commit -m "test: add generated site verification"
```

### Task 3: Build the shared document shell

**Files:**
- Create: `_layouts/default.html`
- Create: `_includes/header.html`
- Create: `_includes/footer.html`
- Create: `assets/images/share-default.svg`

- [ ] **Step 1: Add the default layout**

Create a Korean HTML5 document with `{% seo %}`, the feed meta tag, a skip link to `#main-content`, `{% include header.html %}`, a `<main id="main-content">{{ content }}</main>`, and `{% include footer.html %}`. Load `assets/css/main.css` through `{{ '/assets/css/main.css' | relative_url }}`.

- [ ] **Step 2: Add semantic navigation and footer includes**

The header must link to `/`, `/about/`, `/methodology/`, and `/questions/` through `relative_url`, plus `https://naljabooks.com`. The footer must identify the editor, link to the methodology page, show `site.time | date: '%Y'`, and link to the main site.

- [ ] **Step 3: Add a brand-owned SVG preview image**

Create a 1200 by 630 SVG with a cream background, orange rounded panel, the title `날자 아카이브`, and subtitle `배움과 선택을 잇는 연구와 실천의 기록`. Include no external font or image dependency.

- [ ] **Step 4: Build and confirm the verifier still fails for content pages**

Run: `JEKYLL_ENV=production bundle exec jekyll build --trace && ruby scripts/verify_site.rb`

Expected: Jekyll builds the shell; verification still fails because required pages and post are absent.

- [ ] **Step 5: Commit the shell**

```bash
git add _layouts/default.html _includes/header.html _includes/footer.html assets/images/share-default.svg
git commit -m "feat: add accessible site shell"
```

### Task 4: Add the home page and static information pages

**Files:**
- Create: `index.html`
- Create: `_includes/post-card.html`
- Create: `about.md`
- Create: `methodology.md`
- Create: `questions.md`
- Create: `404.html`

- [ ] **Step 1: Implement the home page**

Use front matter with `layout`, `title`, and `description`. Add a hero that explains the archive in two sentences, a main-site CTA, a `site.posts` recent-post loop using `post-card.html`, three initial topic cards, and an editorial-principles section linking to `/methodology/`.

- [ ] **Step 2: Implement the reusable post card**

Render the post category, linked title, description, date, and calculated reading time. Use `post.url | relative_url`; calculate Korean-friendly reading time from `post.content | strip_html | size | divided_by: 500`, with a minimum of one minute.

- [ ] **Step 3: Write the about page**

Explain that the archive publishes research evidence, educational perspectives, cases, and policy explanations; identify the default editorial author; and direct official company and product information to `https://naljabooks.com`.

- [ ] **Step 4: Write the methodology page**

State source selection priorities, separation of general information from product perspective, update/correction policy, privacy rules for cases, and a correction contact path through the main site.

- [ ] **Step 5: Write the questions page**

Link to the main-site FAQ, explain that deep answers will be published as articles, and link to the first analogy article through `{% post_url 2026-06-15-why-analogy-matters %}`.

- [ ] **Step 6: Add a helpful 404 page**

Set `permalink: /404.html`, explain that the address may have changed, and link back home and to the main site.

- [ ] **Step 7: Build and verify expected page generation**

Run: `JEKYLL_ENV=production bundle exec jekyll build --trace && ruby scripts/verify_site.rb`

Expected: Static pages pass; verification still reports the missing article requirements and crawler files.

- [ ] **Step 8: Commit the initial pages**

```bash
git add index.html _includes/post-card.html about.md methodology.md questions.md 404.html
git commit -m "feat: add archive information pages"
```

### Task 5: Publish the first researched article

**Files:**
- Create: `_layouts/post.html`
- Create: `_includes/source-list.html`
- Create: `_posts/2026-06-15-why-analogy-matters.md`

- [ ] **Step 1: Implement article rendering**

Render category, title, description, published and updated dates, author, reading time, and a short table of contents. Place `{{ content }}` in an article body, render `source-list.html`, add a methodology note and main-site CTA, and output JSON-LD with `BlogPosting`, canonical URL, headline, description, image, dates, author, and publisher values sourced from front matter.

- [ ] **Step 2: Implement structured source rendering**

For every item in `page.sources`, render title as an external link plus organization/author and year. Add `rel="noopener noreferrer"` and make the section heading `출처` use `id="sources"`.

- [ ] **Step 3: Write the article with bounded claims**

Use the title `지적장애인에게 왜 유추력이 필요할까?`. Define analogy as noticing a relationship in one situation and using that relationship in another. Explain its possible relevance to language, number concepts, routines, safety, and choice as an educational rationale, not a guaranteed treatment effect. Explicitly state that direct evidence for a single analogy program improving everyday outcomes for all people with intellectual disability is not established, and that instruction must be individualized.

Use these sources in front matter and the visible source list:

```yaml
sources:
  - title: "Defining Criteria for Intellectual Disability"
    organization: "American Association on Intellectual and Developmental Disabilities"
    year: 2026
    url: "https://www.aaidd.org/intellectual-disability/definition"
  - title: "Structure-mapping: A theoretical framework for analogy"
    organization: "Dedre Gentner, Cognitive Science"
    year: 1983
    url: "https://doi.org/10.1207/s15516709cog0702_3"
  - title: "Learning and transfer: A general role for analogical encoding"
    organization: "Gentner, Loewenstein, and Thompson, Journal of Educational Psychology"
    year: 2003
    url: "https://doi.org/10.1037/0022-0663.95.2.393"
  - title: "Learning through case comparisons: A meta-analytic review"
    organization: "Alfieri, Nokes-Malach, and Schunn, Educational Psychologist"
    year: 2013
    url: "https://doi.org/10.1080/00461520.2013.775712"
```

- [ ] **Step 4: Build and verify article output**

Run: `JEKYLL_ENV=production bundle exec jekyll build --trace && ruby scripts/verify_site.rb`

Expected: Article page exists at `_site/archive/why-analogy-matters/index.html`, contains visible sources and BlogPosting JSON-LD; only crawler/style gaps remain.

- [ ] **Step 5: Commit the article**

```bash
git add _layouts/post.html _includes/source-list.html _posts/2026-06-15-why-analogy-matters.md
git commit -m "feat: publish first sourced archive article"
```

### Task 6: Add the responsive editorial theme

**Files:**
- Create: `assets/css/main.css`

- [ ] **Step 1: Define tokens and global typography**

Define cream, orange, brown, muted text, white, and border custom properties. Set `box-sizing`, a Korean system font stack, comfortable line height, 18px article text on larger screens, a 72ch reading width, and no motion dependency.

- [ ] **Step 2: Style structure and components**

Style the skip link, sticky header, wrapping navigation, hero, buttons, two-column post/topic grids, cards, article header, metadata, table of contents, blockquotes, source list, CTA panel, and footer. Keep borders soft and corner radii between 16px and 28px.

- [ ] **Step 3: Add accessibility and responsive rules**

Use a high-contrast `:focus-visible` outline. Under 760px collapse all grids to one column, reduce hero/title sizes, allow navigation wrapping, and preserve 20px horizontal page padding. Respect `prefers-reduced-motion` by removing smooth scrolling or transitions.

- [ ] **Step 4: Build and inspect generated CSS links**

Run: `JEKYLL_ENV=production bundle exec jekyll build --trace && ruby scripts/verify_site.rb`

Expected: Every HTML page references `/naljabooks-blog/assets/css/main.css`; no root-relative asset error appears.

- [ ] **Step 5: Commit the theme**

```bash
git add assets/css/main.css
git commit -m "feat: style responsive editorial theme"
```

### Task 7: Add crawler files and operating documentation

**Files:**
- Create: `robots.txt`
- Create: `llms.txt`
- Create: `README.md`

- [ ] **Step 1: Add robots guidance**

```liquid
---
layout: null
---
User-agent: *
Allow: /

Sitemap: {{ '/sitemap.xml' | absolute_url }}
```

- [ ] **Step 2: Add the llms.txt guide**

Include the archive name, one-paragraph purpose, canonical home URL, links to About, Methodology, Questions, RSS, and the first article using `absolute_url`, plus a note that claims should be read with each article's visible sources and dates.

- [ ] **Step 3: Document authoring and deployment**

Document prerequisites, `bundle install`, local serving with `bundle exec jekyll serve`, production build, verifier command, required post front matter, source-entry schema, GitHub Pages settings, and the later custom-domain configuration change from project baseurl to an empty baseurl.

- [ ] **Step 4: Run complete automated verification**

Run: `JEKYLL_ENV=production bundle exec jekyll build --trace && ruby scripts/verify_site.rb && ! rg -n 'TBD|TODO|example\.com|임시 URL' --glob '!docs/**' .`

Expected: Build succeeds, verifier prints `Site verification passed`, and the placeholder scan exits successfully with no matches.

- [ ] **Step 5: Commit crawler and operating files**

```bash
git add robots.txt llms.txt README.md
git commit -m "docs: add crawler and publishing guidance"
```

### Task 8: Browser verification and release readiness

**Files:**
- Modify only files with defects found during verification.

- [ ] **Step 1: Start the project-site-aware development server**

Run: `bundle exec jekyll serve --baseurl /naljabooks-blog`

Expected: Server listens locally and serves the site under `/naljabooks-blog/`.

- [ ] **Step 2: Verify desktop pages in the in-app browser**

Open `http://127.0.0.1:4000/naljabooks-blog/`. Check the home, About, Methodology, Questions, article, 404, feed, sitemap, robots, and llms routes. Confirm navigation, main-site links, article sources, and focus states.

- [ ] **Step 3: Verify the mobile layout**

At a viewport near 390 by 844, confirm one-column cards, readable article measure, wrapping navigation, non-overflowing source URLs, and visible focus treatment.

- [ ] **Step 4: Re-run release verification after any fixes**

Run: `JEKYLL_ENV=production bundle exec jekyll build --trace && ruby scripts/verify_site.rb && git diff --check`

Expected: All commands succeed with no warnings from `git diff --check`.

- [ ] **Step 5: Commit verification fixes, if any**

```bash
git add <only-the-files-fixed-during-browser-verification>
git commit -m "fix: address release verification findings"
```

The commit is unnecessary when browser verification finds no defect.
