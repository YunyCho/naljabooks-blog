# Editorial Illustration Homepage Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Redesign the Nalja Archive homepage as a responsive editorial page with a custom connected-learning illustration, serif-led typography, muted sage colors, and an accessible recent-post hierarchy.

**Architecture:** Keep the existing Jekyll data model and shared layout. Add generated-site assertions before changing the homepage, use one project-owned raster hero illustration plus code-native SVG topic icons, and contain the new responsive presentation in the existing stylesheet.

**Tech Stack:** Jekyll, Liquid, semantic HTML, CSS, SVG, WebP/PNG, Ruby generated-site verification

---

## File Map

- `scripts/verify_site.rb`: asserts the new homepage structure, asset paths, CTA, and absence of a newsletter form.
- `_layouts/default.html`: loads the serif display font with swap behavior and system fallbacks.
- `index.html`: owns homepage section order and recent-post hierarchy.
- `_includes/topic-icon.html`: renders the three small code-native SVG topic icons.
- `assets/css/main.css`: owns the editorial palette, typography, layout, focus, and responsive behavior.
- `assets/images/home-learning-scenes.png`: transparent fallback for the generated hero illustration.
- `assets/images/home-learning-scenes.webp`: optimized primary hero illustration.

### Task 1: Define the generated homepage contract

**Files:**
- Modify: `scripts/verify_site.rb`

- [ ] **Step 1: Add failing homepage assertions**

After the common generated-file checks, read `_site/index.html` and append errors unless it includes the exact structural contracts:

```ruby
home = SITE.join("index.html")
if home.file?
  html = home.read
  {
    "editorial hero" => 'class="home-hero"',
    "connected learning illustration" => 'home-learning-scenes.webp',
    "featured latest post" => 'class="featured-story"',
    "topic icon" => 'class="topic-icon"',
    "editorial principle" => 'class="home-principle"',
    "latest posts CTA" => 'href="#recent-posts"'
  }.each do |label, marker|
    errors << "index.html: missing #{label}" unless html.include?(marker)
  end
  errors << "index.html: newsletter input is out of scope" if html.match?(%r{<input[^>]+type=["']email["']})
end
```

- [ ] **Step 2: Build and verify the new contract fails**

Run: `JEKYLL_ENV=production bundle exec jekyll build --trace && ruby scripts/verify_site.rb`

Expected: FAIL with missing editorial hero, illustration, featured latest post, topic icon, and editorial principle.

- [ ] **Step 3: Commit the failing contract**

```bash
git add scripts/verify_site.rb
git commit -m "test: define editorial homepage requirements"
```

### Task 2: Create the project-owned illustration assets

**Files:**
- Create: `assets/images/home-learning-scenes.png`
- Create: `assets/images/home-learning-scenes.webp`

- [ ] **Step 1: Generate the hero illustration against a removable key color**

Use the approved reference only for mood and medium, not for copied characters or layout. Generate a wide hand-drawn scene on flat `#00ff00` showing four respectful adolescent/adult figures in separate loose rectangular frames: reading, arranging learning cards, discussing a page, and using a tablet. Connect the frames with a few expressive ink lines. Use warm off-white clothing, ink black, muted sage, pale yellow, dusty pink, and pale blue. Require no text, logos, watermark, shadows, gradients, childish proportions, or bright green in the subject.

Copy the generated source to `/private/tmp/nalja-home-learning-scenes-source.png`; do not commit the chroma-key source.

- [ ] **Step 2: Remove the key color and validate transparency**

Run:

```bash
python "${CODEX_HOME:-$HOME/.codex}/skills/.system/imagegen/scripts/remove_chroma_key.py" \
  --input /private/tmp/nalja-home-learning-scenes-source.png \
  --out assets/images/home-learning-scenes.png \
  --auto-key border --soft-matte --transparent-threshold 12 \
  --opaque-threshold 220 --despill
```

Expected: PNG has an alpha channel, transparent corners, no green fringe, and all figures remain intact.

- [ ] **Step 3: Create the optimized WebP**

Use the available image tooling to export `home-learning-scenes.webp` with alpha while retaining the PNG fallback. Verify both images are approximately 2× the intended desktop display width and contain no embedded text.

- [ ] **Step 4: Commit the image assets**

```bash
git add assets/images/home-learning-scenes.png assets/images/home-learning-scenes.webp
git commit -m "feat: add connected learning homepage illustration"
```

### Task 3: Implement semantic homepage content

**Files:**
- Modify: `_layouts/default.html`
- Modify: `index.html`
- Create: `_includes/topic-icon.html`

- [ ] **Step 1: Add the display-font resource**

Add preconnect links for `fonts.googleapis.com` and `fonts.gstatic.com`, then load `Noto Serif KR` weights 500 and 600. Keep CSS fallbacks so all text remains visible if the font request fails.

- [ ] **Step 2: Add the code-native topic icon include**

Create a decorative `svg.topic-icon` with `aria-hidden="true"` and three Liquid branches selected by `include.name`: `analogy`, `daily`, and `practice`. Each branch uses black strokes and no more than one muted pastel fill.

- [ ] **Step 3: Replace the homepage markup**

Implement, in order:

```html
<section class="home-hero">…<a class="button" href="#recent-posts">최신 글 읽기</a>…</section>
<section id="recent-posts" class="home-stories">…</section>
<section class="home-topics">…{% include topic-icon.html name="analogy" %}…</section>
<section class="home-principle">…</section>
<section class="home-closing">…</section>
```

Use a `<picture>` element for the hero, with WebP first and PNG fallback. Add `alt=""`, `aria-hidden="true"`, and explicit width/height because the image is decorative and adjacent text provides the meaning.

Assign the first item from `site.posts` to the large `.featured-story`; render remaining posts as `.story-list-item` entries. If only one post exists, omit the empty supporting list without leaving a blank column.

- [ ] **Step 4: Build and confirm structure assertions pass**

Run: `JEKYLL_ENV=production bundle exec jekyll build --trace && ruby scripts/verify_site.rb`

Expected: `Site verification passed` before visual styling is added.

- [ ] **Step 5: Commit semantic markup**

```bash
git add _layouts/default.html _includes/topic-icon.html index.html
git commit -m "feat: restructure editorial homepage"
```

### Task 4: Apply the editorial visual system responsively

**Files:**
- Modify: `assets/css/main.css`

- [ ] **Step 1: Replace palette and type tokens**

Define the homepage palette with warm paper `#fbfaf7`, ink `#1f211d`, sage `#7f9f8d`, pale sage `#e4eee8`, pale yellow `#f4e8a8`, dusty pink `#efc8ce`, and pale blue `#d6e7ed`. Use this display stack:

```css
--font-display: "Noto Serif KR", "AppleMyungjo", "Batang", serif;
```

- [ ] **Step 2: Style the approved desktop structure**

Use a centered hero with generous white space, image width constrained below the text measure, a large featured story beside a compact supporting list, a three-column topic row, a pale-sage principle banner, and a quiet centered closing CTA. Remove card shadows and large pill shapes from homepage components; retain clear borders and focus rings.

- [ ] **Step 3: Add mobile behavior**

At `900px`, stack the featured story and supporting list. At `680px`, stack the topics, reduce heading sizes, keep the hero illustration within the viewport, and let header links wrap to two lines with the external link on the final line. Ensure CTA targets are at least 44px high.

- [ ] **Step 4: Respect motion and image failure conditions**

Add a `prefers-reduced-motion: reduce` rule that disables smooth scrolling and decorative transitions. Ensure the hero reserves its aspect ratio and does not obscure any text when the image fails.

- [ ] **Step 5: Run the full automated verification**

Run: `JEKYLL_ENV=production bundle exec jekyll build --trace && ruby scripts/verify_site.rb`

Expected: `Site verification passed` with no Jekyll warnings or errors.

- [ ] **Step 6: Commit the visual system**

```bash
git add assets/css/main.css
git commit -m "feat: style editorial illustration homepage"
```

### Task 5: Verify rendered behavior and finish

**Files:**
- Modify only if a failing check requires a focused fix.

- [ ] **Step 1: Start the Jekyll server**

Run: `bundle exec jekyll serve --host 127.0.0.1`

Expected: local site available at `http://127.0.0.1:4000/naljabooks-blog/`.

- [ ] **Step 2: Inspect desktop rendering**

At 1280×900, verify header, serif hero, connected-learning image, featured story hierarchy, topic icons, principle banner, closing CTA, and footer. Confirm there is no horizontal overflow and no email input.

- [ ] **Step 3: Inspect mobile rendering**

At 390×844, verify header wrapping, readable title lines, contained illustration, single-column stories/topics, 44px CTA targets, and visible focus treatment.

- [ ] **Step 4: Verify image fallback**

Temporarily block or rename the WebP request in browser inspection and confirm the PNG displays; then confirm content remains usable with both image requests unavailable.

- [ ] **Step 5: Re-run final verification**

Run: `JEKYLL_ENV=production bundle exec jekyll build --trace && ruby scripts/verify_site.rb && git diff --check`

Expected: production build succeeds, verifier prints `Site verification passed`, and `git diff --check` prints nothing.

- [ ] **Step 6: Commit any focused verification fixes**

If verification required a fix, stage only the changed files from `_layouts/default.html`, `index.html`, `_includes/topic-icon.html`, and `assets/css/main.css`, then commit with `git commit -m "fix: polish responsive editorial homepage"`. If no fix was required, skip this commit.
