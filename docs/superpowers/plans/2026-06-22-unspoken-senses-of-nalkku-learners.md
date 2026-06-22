# Unspoken Senses of Nalkku Learners Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Publish a Korean Jekyll article explaining the ten unspoken senses guiding Nalkku learner-centered design for a general audience.

**Architecture:** Add one self-contained post under `_posts` using the repository's existing front matter, table-of-contents anchors, and editorial conventions. Preserve the ten-part list while integrating the source material's program and service language into readable prose, then validate content coverage and the production build.

**Tech Stack:** Jekyll, Markdown, YAML front matter, Ruby verification scripts

---

## File Structure

- Create `_posts/2026-06-22-ten-unspoken-senses-of-nalkku-learners.md`: canonical Korean article with metadata, table of contents, ten numbered principles, and conclusion.
- Modify `scripts/verify_site.rb`: register the new post's publication contract and update the newest regular-story expectation.
- Modify this plan: mark execution steps complete as evidence is produced.

### Task 1: Create the article

**Files:**
- Create: `_posts/2026-06-22-ten-unspoken-senses-of-nalkku-learners.md`

- [x] **Step 1: Confirm the post does not exist yet**

Run `test ! -e _posts/2026-06-22-ten-unspoken-senses-of-nalkku-learners.md`.

Expected: exit status 0.

- [x] **Step 2: Write the post**

Create the file with the approved title, dates, author, category, tags, eleven-entry table of contents, opening statement, ten numbered sections in the approved order, and a conclusion framing the senses as conditions for entering, continuing, and returning to learning.

- [x] **Step 3: Check all required sections and metadata**

Run:

```bash
ruby -e 'p=File.read("_posts/2026-06-22-ten-unspoken-senses-of-nalkku-learners.md"); required=["layout: post", "date: 2026-06-22", "category: \"날자꾸러미의 관점\"", "1. 나도 할 수 있을 것 같은 감각", "2. 나를 어린아이처럼 보지 않는 감각", "3. 내 마음을 먼저 묻는 감각", "4. 내가 고를 수 있다는 감각", "5. 내 이야기가 생기는 감각", "6. 배운 것이 내 생활에 닿는 감각", "7. 내가 남긴 것이 보이는 감각", "8. 혼자 있지만 연결되어 있다는 감각", "9. 다시 시작할 수 있다는 감각", "10. 나에게도 근사한 것이 온다는 감각", "## 배움에 들어갈 수 있는 조건"]; missing=required.reject { |s| p.include?(s) }; abort("Missing: #{missing.join(", ")}") unless missing.empty?; puts "article coverage: ok"'
```

Expected: `article coverage: ok`.

### Task 2: Validate the publication build

**Files:**
- Modify: `scripts/verify_site.rb`
- Test: `scripts/verify_site.rb`
- Test: `scripts/verify_pinned_home.rb`
- Test: `test/naver_draft/*_test.rb`

- [x] **Step 1: Run the Ruby test suite**

Run `ruby -Itest -e 'Dir["test/**/*_test.rb"].sort.each { |file| require File.expand_path(file) }'`.

Expected: all tests report 0 failures and 0 errors.

- [x] **Step 2: Build the production site**

Run `JEKYLL_ENV=production bundle exec jekyll build --trace`.

Expected: exit status 0 and the post renders under `_site/archive/ten-unspoken-senses-of-nalkku-learners/`.

- [x] **Step 3: Run repository verifiers**

Run `ruby scripts/verify_site.rb` and `ruby scripts/verify_pinned_home.rb`.

Expected: both commands exit with status 0 and print success messages.

- [x] **Step 4: Review the final diff**

Run `git diff --check` and review the post and plan diffs.

Expected: the whitespace check has no output and the diff contains only the approved post and checklist updates.
