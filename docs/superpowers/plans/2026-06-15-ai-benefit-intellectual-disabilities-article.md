# AI Must Benefit People with Intellectual Disabilities Article Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Publish a sourced declaration article stating that AI must provide direct benefits to people with intellectual disabilities, while converting the post layout to support per-article tables of contents.

**Architecture:** Keep content in Jekyll Markdown and define each article's table of contents as front matter data. The shared post layout renders that data generically, while the Ruby generated-site verifier asserts post metadata, authorship, sources, structured data, and anchor integrity before deployment.

**Tech Stack:** Ruby 3.3, GitHub Pages/Jekyll 3.10, Liquid, Markdown/Kramdown, HTML, CSS, GitHub Pages

---

## File Map

- `scripts/verify_site.rb`: verify both generated articles, their authors, structured data, visible sources, article-specific text, and table-of-contents anchors.
- `_layouts/post.html`: replace the first article's hard-coded table of contents with a loop over `page.toc`.
- `_posts/2026-06-15-why-analogy-matters.md`: define the existing article's six table-of-contents entries in front matter.
- `_posts/2026-06-15-ai-must-benefit-people-with-intellectual-disabilities.md`: publish the new first-person declaration with four official sources.
- `assets/css/main.css`: ensure the long English title, declaration block, and principle list remain readable on desktop and mobile.
- `README.md`: document the optional `toc` front matter structure for future articles.

### Task 1: Generalize generated-post verification

**Files:**
- Modify: `scripts/verify_site.rb`

- [ ] **Step 1: Replace the single-post assertion with post specifications**

Define these constants after `EXPECTED`:

```ruby
POSTS = {
  "archive/why-analogy-matters/index.html" => {
    author: "도서출판 날자 · 날자꾸러미 편집부",
    required_text: "지적장애인에게 왜 유추력이 필요할까?",
    anchors: %w[analogy daily-life learning principles nalja-view summary]
  },
  "archive/ai-must-benefit-people-with-intellectual-disabilities/index.html" => {
    author: "도서출판 날자 대표 조윤영",
    required_text: "AI는 지적장애인의 이해와 선택, 참여를 넓혀야 한다",
    anchors: %w[mothers-question declaration practical-benefits decision-boundary principles risks nalja-promise]
  }
}.freeze
```

Replace the current `post = SITE.join(...)` block with:

```ruby
POSTS.each do |path, expectations|
  post = SITE.join(path)
  unless post.file?
    errors << "missing #{path}"
    next
  end

  html = post.read
  blog_posting_count = html.scan('"@type":"BlogPosting"').length
  errors << "#{path}: expected one BlogPosting JSON-LD, found #{blog_posting_count}" unless blog_posting_count == 1
  errors << "#{path}: structured author must be an Organization" unless html.include?('"author":{"@type":"Organization"')
  errors << "#{path}: missing visible author" unless html.include?(expectations[:author])
  errors << "#{path}: missing required article text" unless html.include?(expectations[:required_text])
  errors << "#{path}: missing visible sources" unless html.include?('id="sources"')

  expectations[:anchors].each do |id|
    errors << "#{path}: missing section anchor ##{id}" unless html.include?("id=\"#{id}\"")
    errors << "#{path}: missing TOC link ##{id}" unless html.include?("href=\"##{id}\"")
  end

  errors << "#{path}: raw Kramdown attribute syntax is visible" if html.include?("{:#")
end
```

- [ ] **Step 2: Run verification and confirm the new article fails**

Run:

```bash
JEKYLL_ENV=production /usr/local/opt/ruby@3.3/bin/bundle exec jekyll build --trace
/usr/local/opt/ruby@3.3/bin/ruby scripts/verify_site.rb
```

Expected: Jekyll succeeds, then verification fails with `missing archive/ai-must-benefit-people-with-intellectual-disabilities/index.html`.

- [ ] **Step 3: Commit the failing verification contract**

```bash
git add scripts/verify_site.rb
git commit -m "test: define AI declaration article requirements"
```

### Task 2: Make post tables of contents data-driven

**Files:**
- Modify: `_layouts/post.html`
- Modify: `_posts/2026-06-15-why-analogy-matters.md`
- Test: `scripts/verify_site.rb`

- [ ] **Step 1: Add the existing article's table of contents to front matter**

Insert this block before `sources:` in `_posts/2026-06-15-why-analogy-matters.md`:

```yaml
toc:
  - id: analogy
    title: "유추력이란"
  - id: daily-life
    title: "일상 학습과 선택"
  - id: learning
    title: "학습에서 고려할 점"
  - id: principles
    title: "설계 원칙"
  - id: nalja-view
    title: "날자꾸러미의 적용"
  - id: summary
    title: "핵심 요약"
```

- [ ] **Step 2: Render table-of-contents data generically**

Replace the hard-coded `<aside class="table-of-contents">` in `_layouts/post.html` with:

```liquid
{% if page.toc and page.toc.size > 0 %}
  <aside class="table-of-contents" aria-labelledby="toc-title">
    <p id="toc-title" class="toc-title">이 글의 순서</p>
    <ol>
      {% for item in page.toc %}
        <li><a href="#{{ item.id }}">{{ item.title }}</a></li>
      {% endfor %}
    </ol>
  </aside>
{% endif %}
```

- [ ] **Step 3: Build and verify the existing article remains valid**

Run:

```bash
JEKYLL_ENV=production /usr/local/opt/ruby@3.3/bin/bundle exec jekyll build --trace
rg -n 'href="#(analogy|daily-life|learning|principles|nalja-view|summary)"' _site/archive/why-analogy-matters/index.html
```

Expected: six matching links appear. The full verifier still fails only because the new article is missing.

- [ ] **Step 4: Commit the reusable table of contents**

```bash
git add _layouts/post.html _posts/2026-06-15-why-analogy-matters.md
git commit -m "refactor: support article-specific contents"
```

### Task 3: Publish the AI declaration article

**Files:**
- Create: `_posts/2026-06-15-ai-must-benefit-people-with-intellectual-disabilities.md`
- Test: `scripts/verify_site.rb`

- [ ] **Step 1: Add complete front matter**

Create the file with this front matter:

```yaml
---
layout: post
title: "AI must benefit people with intellectual disabilities"
description: "AI는 지적장애인의 이해와 선택, 참여를 넓혀야 한다는 도서출판 날자의 선언과 AI가 지켜야 할 원칙을 설명합니다."
date: 2026-06-15
updated: 2026-06-15
author:
  name: "도서출판 날자 대표 조윤영"
  url: "https://naljabooks.com"
  type: Organization
category: "AI와 접근성"
tags: ["AI", "지적장애", "접근성", "자기결정", "도서출판 날자"]
toc:
  - id: mothers-question
    title: "엄마의 질문"
  - id: declaration
    title: "날자의 선언"
  - id: practical-benefits
    title: "실질적인 혜택"
  - id: decision-boundary
    title: "도움과 대리결정"
  - id: principles
    title: "AI가 지켜야 할 원칙"
  - id: risks
    title: "가능성과 위험"
  - id: nalja-promise
    title: "날자의 약속"
sources:
  - title: "Convention on the Rights of Persons with Disabilities"
    organization: "United Nations / Office of the High Commissioner for Human Rights"
    year: 2006
    url: "https://www.ohchr.org/en/instruments-mechanisms/instruments/convention-rights-persons-disabilities"
  - title: "Recommendation on the Ethics of Artificial Intelligence"
    organization: "UNESCO"
    year: 2021
    url: "https://unesdoc.unesco.org/ark:/48223/pf0000381137"
  - title: "Information for all: European standards for making information easy to read and understand"
    organization: "Inclusion Europe"
    year: 2010
    url: "https://www.inclusion-europe.eu/easy-to-read-standards-guidelines/"
  - title: "Defining Criteria for Intellectual Disability"
    organization: "American Association on Intellectual and Developmental Disabilities"
    year: 2026
    url: "https://www.aaidd.org/intellectual-disability/definition"
---
```

- [ ] **Step 2: Write the first-person opening and declaration**

Begin with these paragraphs, preserving the private boundary around the child:

```markdown
인공지능이라는 이름을 처음 들었을 때, 한 엄마로서 가장 먼저 떠올린 사람은 지적장애가 있는 내 아이였습니다. 인간의 지능을 돕기 위해 만든 기술이라면, 이해하고 배우고 판단하는 데 더 많은 지원이 필요한 사람에게 먼저 도움이 되어야 하지 않을까 생각했습니다.

가장 똑똑한 사람을 더욱 앞서가게 하는 것보다, 지금까지 기술의 혜택에서 밀려났던 사람의 이해와 선택을 넓히는 일. 나는 그것이 인공지능이 가장 먼저 해야 할 일이라고 믿습니다.

## 엄마의 질문 {#mothers-question}

나는 아이의 이름이나 구체적인 삶을 이 글의 근거로 내놓지 않으려 합니다. 한 사람의 사생활을 공개하지 않아도 질문은 분명하기 때문입니다. 인공지능은 누구에게 먼저 유용해야 합니까?

## 도서출판 날자의 선언 {#declaration}

> **AI must benefit people with intellectual disabilities.**  
> AI는 지적장애인의 이해와 선택, 참여를 넓혀야 합니다.

이 문장은 기술이 언젠가 좋은 일을 해 주기를 바라는 막연한 기대가 아닙니다. 도서출판 날자가 AI와 교육 자료를 바라보고 판단하는 기준입니다.
```

- [ ] **Step 3: Explain practical benefits without promising outcomes**

Add `## 실질적인 혜택 {#practical-benefits}`. Define benefit as understanding information, expressing questions and intentions, comparing choices, and participating in education and daily life. Use the five examples from the design: simplifying notices, organizing questions, comparing options, repeating explanations at an individual pace, and checking schedule/mobility/money/safety information.

State explicitly that these are directions AI can support, not proof that current products work reliably for every person. Connect accessible information to CRPD Articles 9 and 21 and Inclusion Europe's easy-to-read standards without claiming those organizations endorse Nalja's declaration.

- [ ] **Step 4: Draw the boundary between support and substituted decisions**

Add `## 도움과 대리결정은 다릅니다 {#decision-boundary}`. Explain that showing understandable options supports a decision, while selecting on a person's behalf removes it. State that fluent AI output may still be false and that consequential education, welfare, health, and legal decisions require checkable sources and responsible human support.

Connect this argument to dignity, autonomy, freedom to make one's own choices, and support in exercising legal capacity under the CRPD.

- [ ] **Step 5: State five product and policy principles**

Add `## AI가 혜택이 되기 위한 다섯 원칙 {#principles}` with these subheadings and meanings:

```markdown
### 1. 당사자와 함께 만듭니다
### 2. 쉽게 이해하고 조작할 수 있어야 합니다
### 3. 한 사람에게 맞게 조정할 수 있어야 합니다
### 4. 개인정보와 존엄을 지켜야 합니다
### 5. 사람의 선택과 책임을 남겨야 합니다
```

Explain stakeholder participation, accessible input/output, individualized support, data minimization, correction and human accountability. Cite UNESCO's human-rights, inclusion, privacy, fairness, human oversight, and accountability principles as supporting ethical context, not as endorsement of the exact Nalja wording.

- [ ] **Step 6: Balance possibilities and risks**

Add `## 가능성과 위험을 함께 봅니다 {#risks}`. Describe the possibilities of easier information, communication support, and individualized explanations. Then cover confident errors, unrepresentative data, surveillance, sensitive-data leakage, institution-first design, and replacing human support to reduce costs.

State that benefit is not the optimistic side of a benefits-versus-risks ledger: a system provides benefit only when material risks are controlled and the person retains agency.

- [ ] **Step 7: Close with Nalja's ongoing promise**

Add `## 도서출판 날자의 약속 {#nalja-promise}`. Include these four review questions:

```markdown
- 이 기술은 지적장애인이 더 잘 이해하도록 돕는가?
- 자신의 의사를 표현하고 선택할 여지를 넓히는가?
- 당사자의 존엄, 개인정보와 주도권을 지키는가?
- 가족과 교사, 지원자의 일을 줄이는 데서 멈추지 않고 당사자에게 직접적인 이익을 주는가?
```

End by repeating the English declaration and its Korean meaning. Do not include the child's name, age, diagnosis details, learning level, school, location, or a concrete private incident.

- [ ] **Step 8: Build and run the complete verifier**

Run:

```bash
JEKYLL_ENV=production /usr/local/opt/ruby@3.3/bin/bundle exec jekyll build --trace
/usr/local/opt/ruby@3.3/bin/ruby scripts/verify_site.rb
```

Expected: `Site verification passed`.

- [ ] **Step 9: Commit the article**

```bash
git add _posts/2026-06-15-ai-must-benefit-people-with-intellectual-disabilities.md
git commit -m "feat: publish AI accessibility declaration"
```

### Task 4: Style and document the reusable article pattern

**Files:**
- Modify: `assets/css/main.css`
- Modify: `README.md`

- [ ] **Step 1: Add styles for long titles and declaration blocks**

Add these rules near the article styles:

```css
.article-header h1 {
  overflow-wrap: anywhere;
}

.article-body blockquote {
  margin: 42px 0;
  padding: 28px 32px;
  background: var(--apricot);
  border-left: 6px solid var(--orange-dark);
  border-radius: 0 22px 22px 0;
  font-size: 21px;
  font-weight: 700;
}

.article-body blockquote p:last-child {
  margin-bottom: 0;
}
```

Inside the existing `@media (max-width: 760px)` block add:

```css
.article-header h1 {
  font-size: clamp(34px, 10.5vw, 43px);
}

.article-body blockquote {
  padding: 22px;
  font-size: 18px;
}
```

- [ ] **Step 2: Document optional article-specific contents**

Add this example below the post front matter in `README.md`:

```yaml
toc:
  - id: first-section
    title: "첫 번째 항목"
  - id: second-section
    title: "두 번째 항목"
```

Explain that each corresponding Markdown heading must use matching Kramdown syntax:

```markdown
## 첫 번째 제목 {#first-section}
```

- [ ] **Step 3: Verify generated HTML and formatting**

Run:

```bash
JEKYLL_ENV=production /usr/local/opt/ruby@3.3/bin/bundle exec jekyll build --trace
/usr/local/opt/ruby@3.3/bin/ruby scripts/verify_site.rb
git diff --check
```

Expected: all commands succeed.

- [ ] **Step 4: Commit style and authoring guidance**

```bash
git add assets/css/main.css README.md
git commit -m "docs: support declaration article presentation"
```

### Task 5: Browser verification

**Files:**
- Modify only files with defects demonstrated during browser verification.

- [ ] **Step 1: Serve the generated project site**

Run:

```bash
mkdir -p /private/tmp/nalja-ai-article-preview/naljabooks-blog
cp -R _site/. /private/tmp/nalja-ai-article-preview/naljabooks-blog/
python3 -m http.server 4173 --bind 127.0.0.1 --directory /private/tmp/nalja-ai-article-preview
```

Expected: the temporary server exposes the site at `http://127.0.0.1:4173/naljabooks-blog/`.

- [ ] **Step 2: Verify the home page on desktop**

Open the home page in the in-app browser. Confirm the new article appears first, both cards render, the long English title stays inside its card, and the new link opens `/naljabooks-blog/archive/ai-must-benefit-people-with-intellectual-disabilities/`.

- [ ] **Step 3: Verify the new article on desktop**

Confirm the title, Korean description, author `도서출판 날자 대표 조윤영`, seven table-of-contents items, declaration block, five principles, four sources, methodology note, and footer. Click at least the `엄마의 질문`, `AI가 지켜야 할 원칙`, and `날자의 약속` table-of-contents links and confirm the URL hash and target heading match.

- [ ] **Step 4: Verify the new article at 390 by 844**

Confirm there is no horizontal overflow; the English title is not clipped; navigation wraps; author metadata is readable; the declaration block fits; source URLs wrap; and the article remains a single readable column.

- [ ] **Step 5: Verify the existing article did not regress**

Open `/naljabooks-blog/archive/why-analogy-matters/`. Confirm its six table-of-contents links still appear and at least one link moves to the matching heading.

- [ ] **Step 6: Add a failing regression assertion before any browser fix**

If a defect is found, first add the smallest reproducible assertion to `scripts/verify_site.rb` when the defect is structural. For a visual-only defect, record the failing DOM measurement in the browser, apply the smallest CSS change, rebuild, reload, and verify the measurement no longer fails.

- [ ] **Step 7: Commit browser findings only when needed**

```bash
git add <files changed to fix demonstrated browser defects>
git commit -m "fix: address AI article browser findings"
```

Skip the commit when no defect is found.

### Task 6: Release and GitHub Pages verification

**Files:**
- No source changes expected.

- [ ] **Step 1: Run fresh release verification**

Run:

```bash
JEKYLL_ENV=production /usr/local/opt/ruby@3.3/bin/bundle exec jekyll build --trace
/usr/local/opt/ruby@3.3/bin/ruby scripts/verify_site.rb
! rg -n 'TBD|TODO|example\.com|임시 URL' --glob '!docs/**' --glob '!vendor/**' --glob '!scripts/verify_site.rb' .
git diff --check
git status --short --branch
```

Expected: build succeeds, verifier prints `Site verification passed`, scans produce no findings, and the worktree is clean.

- [ ] **Step 2: Push the implementation branch and integrate it**

Follow `superpowers:finishing-a-development-branch`. After the user chooses integration, ensure the commits reach `main`, then run the release verification again on `main`.

- [ ] **Step 3: Push main to GitHub**

```bash
git push origin main
```

Expected: GitHub reports `main -> main` and the local branch tracks `origin/main` without unpushed commits.

- [ ] **Step 4: Wait for GitHub Pages to build**

Run:

```bash
gh api repos/YunyCho/naljabooks-blog/pages/builds/latest --jq '{status,error,commit}'
```

Repeat at reasonable intervals while status is `queued` or `building`. Expected final status: `built`, with the commit equal to the pushed `main` head.

- [ ] **Step 5: Verify the public deployment**

Run:

```bash
curl -sS --max-time 20 https://yunycho.github.io/naljabooks-blog/ | rg -n 'AI must benefit people with intellectual disabilities'
curl -sSIL --max-time 20 https://yunycho.github.io/naljabooks-blog/archive/ai-must-benefit-people-with-intellectual-disabilities/ | head -5
curl -sS --max-time 20 https://yunycho.github.io/naljabooks-blog/feed.xml | rg -n 'AI must benefit people with intellectual disabilities'
curl -sS --max-time 20 https://yunycho.github.io/naljabooks-blog/sitemap.xml | rg -n 'ai-must-benefit-people-with-intellectual-disabilities'
```

Expected: the title appears on the public home and RSS feed, the article returns HTTP 200, and the article URL appears in the sitemap.
