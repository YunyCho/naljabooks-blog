# Substack English Essay Publication Design

## Goal

Publish the user's Substack essay as one complete English article in the Nalja Archive on 2026-06-19. Preserve the essay's wording and chapter structure while adapting only the surrounding metadata and terminology required by the archive.

## Source

- Source post: `https://substack.com/home/post/p-188469570`
- Public title: `At the Edge of Intelligence, We Find What It Means to Be Human.`
- Subtitle/description: `In the Age of AGI, What My Son Will Teach Humanity`
- Display author: `NaljaBook`

## Publication Shape

The essay is published as a single Jekyll post, not split into a series and not reduced to an excerpt. The body begins with the source's contents and prologue material and continues through the signed epilogue. Substack subscription prompts, engagement controls, footer copy, and discussion UI are not part of the essay and are excluded.

The stable URL slug is:

`at-the-edge-of-intelligence-we-find-what-it-means-to-be-human`

## Content Preservation

- Keep the English prose, quotations, section order, and decorative `◆ ◆ ◆` separators.
- Do not translate, summarize, or add new claims to the body.
- Replace public-prose uses of `developmental disability`, `developmental disabilities`, and `people with developmental disabilities` with the corresponding `intellectual disability` wording. This is the only editorial terminology change.
- Keep the final signature text from the source essay.
- Do not copy Substack calls to subscribe, like, comment, share, or view profiles.

## Structure and Metadata

Use the repository's existing `layout: post` schema with:

- publication and modification date `2026-06-19`
- author object whose visible name is `NaljaBook`
- English title and description
- category `AI and Human Dignity`
- English tags for AGI, intellectual disability, humanity, analogy, and Nalja Project
- a table of contents for Prologue, Chapters 1–5, and Epilogue
- one structured source linking back to the Substack original
- `lang: en`

Update the default layout so a post-level language overrides the site-wide Korean language: `page.lang | default: site.lang | default: 'ko-KR'`. Existing Korean pages remain unchanged.

## Homepage and Existing Schedule

The pinned AI declaration remains in the left featured card. The new essay becomes the newest item in the right-hand list. The previously configured Tuesday/Friday automation remains unchanged and will continue with the eight planned Korean articles.

## Verification

Extend generated-site verification before implementation. Verify:

- the English page exists at its canonical URL
- title, description, Open Graph fields, publication date, JSON-LD, author, and `lang="en"` are correct
- all seven TOC anchors are present
- the body contains the prologue lead and final signature
- subscription/interface text from Substack is absent
- `developmental disabilit` is absent from public article prose
- the Substack source link is visible
- the homepage still pins the declaration and places the essay first on the right
- sitemap and feed contain the essay URL
- production build, site verifier, pinned-home integration verifier, and diff check pass

After deployment, verify the same signals against the public GitHub Pages site.
