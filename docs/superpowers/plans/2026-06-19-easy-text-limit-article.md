# Easy Text Limits Article Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Publish `쉬운 글만으로 충분하지 않은 이유` as a fully structured Jekyll post dated 2026-06-19 while preserving the pinned declaration and placing the new post first in the right homepage list.

**Architecture:** Convert the supplied Markdown into the repository's established post schema rather than copying its foreign front matter verbatim. Extend the existing generated-site verifier first, then add the adapted post with matched TOC anchors and structured sources; rely on the existing Jekyll SEO, sitemap, feed, and BlogPosting pipeline and verify their concrete output.

**Tech Stack:** Jekyll, Kramdown, Liquid, YAML front matter, Ruby verification script

---

### Task 1: Define publication and SEO requirements

**Files:**
- Modify: `scripts/verify_site.rb`
- Test: `scripts/verify_site.rb`

- [ ] **Step 1: Register the expected post and anchors**

Add this entry to `POSTS` in `scripts/verify_site.rb`:

```ruby
  "archive/why-easy-text-alone-is-not-enough/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "쉬운 글은 꼭 필요하지만 충분하지 않다",
    anchors: %w[summary easy-text comprehension activities adulthood repetition nalja-view conclusion],
    source_count: 4
  },
```

Add `source_count: 4` to neither existing post; update the source validation inside the `POSTS.each` loop so the optional field is enforced only when present:

```ruby
  if expectations[:source_count]
    source_count = html.scan(%r{id="source-\d+"}).length
    unless source_count == expectations[:source_count]
      errors << "#{path}: expected #{expectations[:source_count]} sources, found #{source_count}"
    end
  end
```

- [ ] **Step 2: Add article metadata and discovery assertions**

After the `POSTS.each` loop, add:

```ruby
easy_text_path = "archive/why-easy-text-alone-is-not-enough/index.html"
easy_text_url = "https://yunycho.github.io/naljabooks-blog/archive/why-easy-text-alone-is-not-enough/"
easy_text_post = SITE.join(easy_text_path)

if easy_text_post.file?
  html = easy_text_post.read
  {
    "Open Graph title" => 'property="og:title" content="쉬운 글만으로 충분하지 않은 이유"',
    "Open Graph description" => 'property="og:description"',
    "Open Graph URL" => %(property="og:url" content="#{easy_text_url}"),
    "published time" => 'property="article:published_time" content="2026-06-19T00:00:00+09:00"',
    "canonical URL" => %(rel="canonical" href="#{easy_text_url}"),
    "JSON-LD dateModified" => '"dateModified":"2026-06-19T00:00:00+09:00"',
    "JSON-LD datePublished" => '"datePublished":"2026-06-19T00:00:00+09:00"',
    "JSON-LD mainEntityOfPage" => %("@id":"#{easy_text_url}")
  }.each do |label, marker|
    errors << "#{easy_text_path}: missing #{label}" unless html.include?(marker)
  end
  article_body = html[%r{<div class="article-body">.*?</div>}m]
  if article_body&.include?("발달장애")
    errors << "#{easy_text_path}: public article prose must use 지적장애인"
  end
end

%w[sitemap.xml feed.xml].each do |path|
  next unless SITE.join(path).file?
  errors << "#{path}: missing easy-text article" unless SITE.join(path).read.include?(easy_text_url)
end
```

- [ ] **Step 3: Assert homepage placement and source terminology**

Inside the homepage verification block, after extracting `story_list`, add:

```ruby
  first_regular_story = story_list&.match(%r{<article class="story-list-item">.*?</article>}m)&.to_s
  unless first_regular_story&.include?("쉬운 글만으로 충분하지 않은 이유")
    errors << "index.html: easy-text article is not the newest regular story"
  end
```

After `PUBLIC_COPY_FILES`, add the new source file to the terminology audit without broadening it to documentation:

```ruby
EASY_TEXT_SOURCE = "_posts/2026-06-19-why-easy-text-alone-is-not-enough.md"
if ROOT.join(EASY_TEXT_SOURCE).file?
  source_body = ROOT.join(EASY_TEXT_SOURCE).read.sub(%r{\A---.*?---}m, "")
  if source_body.include?("발달장애")
    errors << "#{EASY_TEXT_SOURCE}: public article prose must use 지적장애인"
  end
end
```

- [ ] **Step 4: Build and confirm the requirements fail for the missing post**

Run:

```bash
JEKYLL_ENV=production bundle exec jekyll build --trace
ruby scripts/verify_site.rb
```

Expected: the build succeeds and the verifier fails with missing new post, sitemap/feed, and homepage placement messages.

- [ ] **Step 5: Commit the failing requirements**

```bash
git add scripts/verify_site.rb
git commit -m "test: define easy-text article publication"
```

### Task 2: Adapt and publish the supplied article

**Files:**
- Read source: `/Users/yuny/Downloads/naljabooks_ai_seo_blog_md/09-why-easy-text-alone-is-not-enough.md`
- Create: `_posts/2026-06-19-why-easy-text-alone-is-not-enough.md`

- [ ] **Step 1: Create repository-native front matter**

Use this exact front matter:

```yaml
---
layout: post
title: "쉬운 글만으로 충분하지 않은 이유"
description: "쉬운 글은 접근성을 높이는 출발점이지만, 지적장애 청소년·성인의 실제 이해와 일상 적용을 위해서는 활동, 질문, 반복, 피드백이 함께 필요합니다."
date: 2026-06-19
updated: 2026-06-19
author:
  name: "도서출판 날자 · 날자꾸러미 편집부"
  url: "https://naljabooks.com"
  type: Organization
category: "문해력과 쉬운 정보"
tags: ["쉬운 글", "읽기이해", "문해력", "지적장애", "학습설계"]
toc:
  - id: summary
    title: "핵심 요약"
  - id: easy-text
    title: "쉬운 글의 역할"
  - id: comprehension
    title: "이해의 조건"
  - id: activities
    title: "이해 활동"
  - id: adulthood
    title: "성인성 존중"
  - id: repetition
    title: "반복과 피드백"
  - id: nalja-view
    title: "날자꾸러미의 관점"
  - id: conclusion
    title: "결론"
sources:
  - title: "발달장애인을 위한 쉽게 접근할 수 있는 정보 만들기"
    organization: "국립장애인도서관"
    url: "https://nld.go.kr/upload/contents02/baldal_jumgbo.pdf"
  - title: "Easy Read Health Information for People With Intellectual Disabilities"
    organization: "Wilson et al."
    url: "https://pmc.ncbi.nlm.nih.gov/articles/PMC12893875/"
  - title: "Cognitive and Language Abilities Associated With Reading in Intellectual Disability"
    organization: "Nilsson et al."
    url: "https://journals.sagepub.com/doi/10.1177/07419325251328644"
  - title: "CAST Universal Design for Learning Guidelines"
    organization: "CAST"
    url: "https://udlguidelines.cast.org/"
---
```

The bibliographic title of source 1 remains unchanged because it is the official publication title; the public article prose and tags use `지적장애인`.

- [ ] **Step 2: Transfer the source body without duplicating layout content**

Copy the source prose beginning with `쉬운 글은 꼭 필요하지만 충분하지 않다.` and ending with the article's `결론` paragraphs. Do not copy:

```text
# 쉬운 글만으로 충분하지 않은 이유
## 참고자료
## 편집 기준
```

Apply these exact public-copy substitutions:

```text
발달장애인에게 → 지적장애인에게
발달장애 성인에게 → 지적장애 성인에게
발달장애인을 → 지적장애인을
발달장애 성인 → 지적장애 성인
```

- [ ] **Step 3: Map headings to stable anchors**

Use these exact Kramdown headings:

```markdown
## 핵심 요약 {#summary}
## 쉬운 글은 문턱을 낮춘다 {#easy-text}
## 이해는 글 밖의 능력과도 관련된다 {#comprehension}
## 쉬운 글은 활동으로 이어져야 한다 {#activities}
## 너무 쉬운 글은 오히려 성인성을 약하게 만들 수 있다 {#adulthood}
## 반복과 피드백이 없으면 변화가 쌓이기 어렵다 {#repetition}
## 날자꾸러미의 관점 {#nalja-view}
## 결론 {#conclusion}
```

- [ ] **Step 4: Link claims to the structured source list**

Add these citation links without changing claim strength:

```markdown
특히 지적장애인에게는 정보 접근권을 보장하는 중요한 방식이다.[1](#source-1)
읽기이해는 문장 자체만으로 결정되지 않는다.[3](#source-3)
짧은 문장, 익숙한 단어, 명확한 제목, 충분한 여백, 적절한 그림은 읽기 부담을 줄인다.[2](#source-2)
쉬운 글과 이해 활동을 함께 설계하는 접근은 다양한 표현과 참여 방식을 여는 보편적 학습설계 원칙과도 맞닿아 있다.[4](#source-4)
```

The fourth sentence belongs at the end of the `쉬운 글은 활동으로 이어져야 한다` section and summarizes design alignment rather than promising outcomes.

- [ ] **Step 5: Build and run all verifiers**

Run:

```bash
JEKYLL_ENV=production bundle exec jekyll build --trace
ruby scripts/verify_site.rb
ruby scripts/verify_pinned_home.rb
git diff --check
```

Expected: build exits 0, `Site verification passed`, `Pinned homepage integration verification passed`, and no diff errors.

- [ ] **Step 6: Commit the article**

```bash
git add _posts/2026-06-19-why-easy-text-alone-is-not-enough.md
git commit -m "feat: publish easy-text limits article"
```

### Task 3: Verify generated publication artifacts

**Files:**
- Verify: `_site/archive/why-easy-text-alone-is-not-enough/index.html`
- Verify: `_site/index.html`
- Verify: `_site/sitemap.xml`
- Verify: `_site/feed.xml`

- [ ] **Step 1: Verify article metadata and structure**

Run:

```bash
rg -n "<title>|meta name=\"description\"|rel=\"canonical\"|og:title|og:description|og:url|article:published_time|datePublished|dateModified|mainEntityOfPage|id=\"source-[1-4]\"|발달장애" _site/archive/why-easy-text-alone-is-not-enough/index.html
```

Expected: required metadata and four source IDs appear; `발달장애` has no match in the article prose except the official source title in the source list.

- [ ] **Step 2: Verify homepage ordering and declaration pinning**

Run:

```bash
rg -n "featured-story|AI must benefit people with intellectual disabilities|고정 선언문|story-list|쉬운 글만으로 충분하지 않은 이유|지적장애인에게 왜 유추력이 필요할까" _site/index.html
```

Expected: declaration remains in `featured-story`; the new article is the first `story-list-item`; the analogy article follows it.

- [ ] **Step 3: Verify discovery files**

Run:

```bash
rg -n "archive/why-easy-text-alone-is-not-enough" _site/sitemap.xml _site/feed.xml
```

Expected: both files contain the new article URL.

- [ ] **Step 4: Run the full final suite**

Run:

```bash
JEKYLL_ENV=production bundle exec jekyll build --trace
ruby scripts/verify_site.rb
ruby scripts/verify_pinned_home.rb
git diff --check
git status --short --branch
```

Expected: all verification commands pass and the branch is clean.
