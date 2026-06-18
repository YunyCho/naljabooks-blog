# Homepage Follow-up Refinements Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refine the approved homepage by neutralizing illustration skin fills, replacing the temporary header mark with the supplied Nalkku SVG logo, and tightening public-facing terminology and hero copy.

**Architecture:** Extend the generated-site verifier before changing public copy or header markup. Keep the supplied SVG as a project-owned asset, update only public site copy rather than quoted source material, and replace the hero PNG/WebP together so the existing `<picture>` fallback remains valid.

**Tech Stack:** Jekyll, Liquid, semantic HTML, CSS, SVG, PNG/WebP, Ruby generated-site verification

---

## File Map

- `scripts/verify_site.rb`: asserts the Nalkku logo, concise hero copy, and public terminology.
- `assets/images/nalkku-logo.svg`: project copy of the supplied brand mark.
- `_includes/header.html`: renders the supplied logo instead of the temporary circular `날` mark.
- `assets/css/main.css`: sizes the new logo on desktop and mobile.
- `_config.yml`, `index.html`, `about.md`, `llms.txt`: use `지적장애인` in public descriptions and remove redundant hero copy.
- `assets/images/home-learning-scenes.png`, `assets/images/home-learning-scenes.webp`: edited illustration with paper-colored faces, necks, and hands.

### Task 1: Define the follow-up public contract

**Files:**
- Modify: `scripts/verify_site.rb`

- [ ] **Step 1: Add failing generated-home assertions**

Inside the existing homepage block, add:

```ruby
errors << "index.html: missing Nalkku logo" unless html.include?("nalkku-logo.svg")
errors << "index.html: obsolete hero kicker" if html.include?("배움과 선택을 잇는 기록")
if html.include?("보호자와 교사, 복지 현장의 실무자가 함께 읽을 수 있는 말로 핵심부터 설명합니다.")
  errors << "index.html: redundant hero sentence"
end
```

After the existing source-file quality scan, inspect the four public copy sources:

```ruby
PUBLIC_COPY_FILES = %w[_config.yml index.html about.md llms.txt].freeze
PUBLIC_COPY_FILES.each do |path|
  errors << "#{path}: public terminology must use 지적장애인" if ROOT.join(path).read.include?("발달장애인")
end
```

- [ ] **Step 2: Build and verify the assertions fail for the intended reasons**

Run: `JEKYLL_ENV=production bundle exec jekyll build --trace && ruby scripts/verify_site.rb`

Expected: FAIL for missing Nalkku logo, obsolete hero kicker, redundant hero sentence, and public terminology in `_config.yml`, `index.html`, `about.md`, and `llms.txt`.

- [ ] **Step 3: Commit the failing requirements**

```bash
git add scripts/verify_site.rb
git commit -m "test: define homepage refinement requirements"
```

### Task 2: Install the supplied logo and refine public copy

**Files:**
- Create: `assets/images/nalkku-logo.svg`
- Modify: `_includes/header.html`
- Modify: `assets/css/main.css`
- Modify: `_config.yml`
- Modify: `index.html`
- Modify: `about.md`
- Modify: `llms.txt`

- [ ] **Step 1: Copy the supplied SVG without altering its vector paths**

Copy `/Users/yuny/Desktop/시각디자인_날꾸관련 파일/날꾸로고.svg` to `assets/images/nalkku-logo.svg`. Preserve its `viewBox="0 0 292.96 225.42"`, navy `#1e2b60`, and orange `#ee7426` brand colors.

- [ ] **Step 2: Replace the temporary header mark**

Replace:

```html
<span class="brand-mark" aria-hidden="true">날</span>
```

with:

```html
<img class="brand-logo" src="{{ '/assets/images/nalkku-logo.svg' | relative_url }}" alt="" width="59" height="45">
```

The existing brand link retains `aria-label="날자 아카이브 홈"`, so the logo remains decorative.

- [ ] **Step 3: Size the logo without changing header height**

Add `.brand-logo { width: 52px; height: 40px; object-fit: contain; }` and set it to `46px` by `35px` below `760px`. Remove the unused `.brand-mark` style block.

- [ ] **Step 4: Apply the exact approved copy**

- `_config.yml` and `llms.txt`: replace `발달장애인의` with `지적장애인의`.
- `index.html` front matter and hero paragraph: replace `발달장애인의` with `지적장애인의`.
- `index.html`: remove the `home-kicker` paragraph from the hero and remove the sentence beginning `보호자와 교사`.
- `about.md`: change `발달장애인 또는 지적장애인의 보호자` to `지적장애인의 보호자`.

- [ ] **Step 5: Build and verify the public contract passes**

Run: `JEKYLL_ENV=production bundle exec jekyll build --trace && ruby scripts/verify_site.rb`

Expected: `Site verification passed`.

- [ ] **Step 6: Commit the logo and copy**

```bash
git add assets/images/nalkku-logo.svg _includes/header.html assets/css/main.css _config.yml index.html about.md llms.txt
git commit -m "feat: refine homepage identity and terminology"
```

### Task 3: Neutralize skin fills in the hero illustration

**Files:**
- Modify: `assets/images/home-learning-scenes.png`
- Modify: `assets/images/home-learning-scenes.webp`

- [ ] **Step 1: Edit only the approved color treatment**

Use the existing PNG as the edit target. Preserve every figure, pose, object, connecting line, frame, crop, and pastel accent. Change only faces, ears, necks, and hands to the same warm paper color as the background, retain the black facial line work and hair, and remove all beige or brown skin-color fills so no figure suggests a specific race.

- [ ] **Step 2: Inspect the generated result**

Confirm all five figures remain present, no hands or facial lines disappeared, skin areas match the paper background, there is no new text or watermark, and the image stays at the same wide aspect ratio.

- [ ] **Step 3: Replace both delivery formats**

Copy the accepted edit to `assets/images/home-learning-scenes.png`, then export `assets/images/home-learning-scenes.webp` at quality 88. Confirm both files share the same dimensions.

- [ ] **Step 4: Commit the revised illustration**

```bash
git add assets/images/home-learning-scenes.png assets/images/home-learning-scenes.webp
git commit -m "fix: neutralize homepage illustration skin tones"
```

### Task 4: Verify the finished page

**Files:**
- Modify only a failing file from Task 2 or Task 3 if verification identifies a focused defect.

- [ ] **Step 1: Run full production verification**

Run: `JEKYLL_ENV=production bundle exec jekyll build --trace && ruby scripts/verify_site.rb && git diff --check`

Expected: production build succeeds, verifier prints `Site verification passed`, and `git diff --check` prints nothing.

- [ ] **Step 2: Inspect desktop and mobile rendering**

Reload `http://localhost:4000/naljabooks-blog/`. At desktop width, verify the Nalkku logo, concise hero paragraph, and paper-colored skin areas. At 390px width, verify the logo does not crowd the navigation, the hero has no horizontal overflow, and the illustration remains legible.

- [ ] **Step 3: Confirm terminology scope**

Run: `rg -n "발달장애인" _config.yml index.html about.md llms.txt`

Expected: no output.

- [ ] **Step 4: Commit any focused verification fix**

If verification required a fix, stage only the affected file and commit with `git commit -m "fix: polish homepage refinements"`. If no fix was required, skip this commit.
