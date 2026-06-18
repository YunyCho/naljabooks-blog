# Homepage Title Refresh Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the ambiguous homepage search/share title with `AI 시대, 지적장애인의 배움과 일상`, remove the header subtitle, and preserve the visible hero headline.

**Architecture:** Keep page-specific SEO copy in the homepage front matter and align the site-level tagline and default share SVG with it. Remove the now-unused header subtitle markup and CSS, while extending the existing generated-site verifier to protect the new title and the unchanged hero headline.

**Tech Stack:** Jekyll, Liquid, HTML, CSS, SVG, Ruby verification script

---

### Task 1: Define the title and header requirements

**Files:**
- Modify: `scripts/verify_site.rb`
- Test: `scripts/verify_site.rb`

- [ ] **Step 1: Add failing homepage assertions**

In the existing `if home.file?` block, after the Nalkku logo assertion, add:

```ruby
  expected_home_title = "AI 시대, 지적장애인의 배움과 일상"
  errors << "index.html: missing refreshed page title" unless html.include?("<title>#{expected_home_title} | 날자 아카이브</title>")
  errors << "index.html: missing refreshed Open Graph title" unless html.include?(%(property="og:title" content="#{expected_home_title}"))
  errors << "index.html: missing refreshed Twitter title" unless html.include?(%(property="twitter:title" content="#{expected_home_title}"))
  errors << "index.html: header tagline must be removed" if html.match?(%r{<small>[^<]*</small>})
  errors << "index.html: hero headline changed unexpectedly" unless html.include?("배운 것이") && html.include?("삶으로 이어지도록")
  errors << "index.html: obsolete public tagline" if html.include?("배움과 선택을 잇는 연구와 실천의 기록")
```

After `PUBLIC_COPY_FILES`, add a public asset assertion:

```ruby
share_image = ROOT.join("assets/images/share-default.svg").read
errors << "share-default.svg: missing refreshed title" unless share_image.include?("AI 시대, 지적장애인의 배움과 일상")
errors << "share-default.svg: obsolete tagline" if share_image.include?("배움과 선택을 잇는 연구와 실천의 기록")
```

- [ ] **Step 2: Build and run the verifier to confirm failure**

Run:

```bash
JEKYLL_ENV=production bundle exec jekyll build --trace
ruby scripts/verify_site.rb
```

Expected: the build succeeds and the verifier fails with refreshed-title, header-tagline, or obsolete-tagline messages.

- [ ] **Step 3: Commit the failing requirements**

```bash
git add scripts/verify_site.rb
git commit -m "test: define homepage title refresh requirements"
```

### Task 2: Refresh titles and remove the header subtitle

**Files:**
- Modify: `index.html`
- Modify: `_config.yml`
- Modify: `_includes/header.html`
- Modify: `assets/css/main.css`
- Modify: `assets/images/share-default.svg`

- [ ] **Step 1: Update the homepage and site-level titles**

In `index.html`, set the front matter title to:

```yaml
title: "AI 시대, 지적장애인의 배움과 일상"
```

In `_config.yml`, set:

```yaml
tagline: "AI 시대, 지적장애인의 배움과 일상"
```

Do not change the hero heading:

```html
<h1>배운 것이<br><em>삶으로 이어지도록</em></h1>
```

- [ ] **Step 2: Remove the header subtitle markup**

Change the brand text in `_includes/header.html` to:

```html
<span>
  <strong>{{ site.title }}</strong>
</span>
```

- [ ] **Step 3: Remove subtitle-only CSS**

In `assets/css/main.css`, change the shared display selector to:

```css
.site-brand strong {
  display: block;
}
```

Delete the `.site-brand small` desktop rule and the `.site-brand small { display: none; }` mobile rule.

- [ ] **Step 4: Update the default share image copy**

In `assets/images/share-default.svg`, replace both occurrences of `배움과 선택을 잇는 연구와 실천의 기록` with `AI 시대, 지적장애인의 배움과 일상`:

```xml
<desc id="desc">AI 시대, 지적장애인의 배움과 일상</desc>
...
<text x="145" y="375" fill="#fff1df" font-family="Arial, Apple SD Gothic Neo, sans-serif" font-size="38">AI 시대, 지적장애인의 배움과 일상</text>
```

- [ ] **Step 5: Build and verify the implementation**

Run:

```bash
JEKYLL_ENV=production bundle exec jekyll build --trace
ruby scripts/verify_site.rb
git diff --check
```

Expected: production build exits 0, verifier prints `Site verification passed`, and `git diff --check` prints nothing.

- [ ] **Step 6: Confirm the generated metadata and preserved hero copy**

Run:

```bash
rg -n "AI 시대, 지적장애인의 배움과 일상|배운 것이|삶으로 이어지도록|배움과 선택을 잇는 연구와 실천의 기록" _site/index.html assets/images/share-default.svg
```

Expected: the new title appears in generated metadata and the share SVG; both hero fragments remain; the obsolete phrase has no matches.

- [ ] **Step 7: Commit the implementation**

```bash
git add index.html _config.yml _includes/header.html assets/css/main.css assets/images/share-default.svg
git commit -m "feat: clarify homepage search and share title"
```

