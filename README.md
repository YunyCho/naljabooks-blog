# 날자 아카이브

도서출판 날자와 날자꾸러미의 연구, 교육 관점, 사례와 정책 해설을 발행하는 Jekyll 블로그입니다.

## 로컬 실행

GitHub Pages의 현재 빌드 환경과 같은 Ruby 3.3 계열을 권장합니다.

```bash
bundle install
bundle exec jekyll serve
```

프로젝트 사이트 경로를 포함한 로컬 주소는 `http://127.0.0.1:4000/naljabooks-blog/`입니다.

## 프로덕션 검증

```bash
JEKYLL_ENV=production bundle exec jekyll build --trace
ruby scripts/verify_site.rb
ruby scripts/verify_pinned_home.rb
```

검증 스크립트는 초기 페이지와 글, title, description, canonical, `BlogPosting` 구조화 데이터, sitemap, RSS, robots, llms 파일과 `baseurl` 적용을 확인합니다.

## 글 작성

`_posts/YYYY-MM-DD-slug.md` 파일을 만들고 다음 front matter를 사용합니다.

```yaml
---
layout: post
title: "글 제목"
description: "검색 결과와 공유 카드에 사용할 고유한 요약"
date: 2026-06-15
updated: 2026-06-15
author:
  name: "도서출판 날자 · 날자꾸러미 편집부"
  url: "https://naljabooks.com"
  type: Organization
category: "유추와 문해력"
tags: ["유추력", "문해력"]
toc:
  - id: "section-id"
    title: "목차에 표시할 제목"
sources:
  - title: "원문 제목"
    organization: "저자 또는 발행기관"
    year: 2026
    url: "https://doi.org/원문-식별자"
---
```

목차를 사용할 때는 본문의 제목에 같은 ID를 지정합니다.

```markdown
## 본문 제목 {#section-id}
```

수치와 연구 주장은 확인 가능한 원문과 연결합니다. 일반 교육 정보와 날자꾸러미의 제품·설계 관점을 구분하고, 효과를 보장하는 표현은 사용하지 않습니다.

## 네이버 블로그 초안 자동화

`main` 브랜치에 새 한국어 `_posts/*.md` 파일이 추가되면 GitHub Actions가 `naver-drafts/<slug>.md`를 만들고 검수용 Pull Request를 엽니다. `lang`이 없거나 `ko`, `ko-KR`인 글만 처리하며 영어 글과 기존 글 수정은 건너뜁니다.

이 자동화는 문장을 AI로 재작성하지 않고 Markdown 표현만 복사하기 쉬운 형태로 정리합니다. 네이버 로그인, 임시저장, 예약 발행, 자동 게시 기능은 없습니다. 네이버에 맞춰 레이아웃을 편집하더라도 GitHub의 `_posts` 글이 항상 원본(source of truth)입니다.

### GitHub 최초 설정

저장소의 **Settings → Actions → General → Workflow permissions**에서 다음을 허용합니다.

1. **Read and write permissions**를 선택합니다.
2. **Allow GitHub Actions to create and approve pull requests**를 켭니다.

별도 API 키나 GitHub Secret은 필요하지 않습니다.

### 로컬 테스트

```bash
ruby -Itest -e 'Dir["test/**/*_test.rb"].sort.each { |file| require File.expand_path(file) }'
```

실제 저장소에 초안을 남기지 않고 변환 결과를 확인하려면 임시 복사본에서 실행합니다.

```bash
tmpdir="$(mktemp -d)"
cp -R _config.yml _posts lib scripts "$tmpdir/"
printf '%s\n' '_posts/2026-06-19-why-easy-text-alone-is-not-enough.md' > "$tmpdir/paths.txt"
(cd "$tmpdir" && ruby scripts/generate_naver_drafts.rb \
  --paths-file paths.txt \
  --source-commit abc1234 \
  --generated-at 2026-06-19T00:00:00Z)
```

결과는 `$tmpdir/naver-drafts/`에 생성됩니다.

### 글 게시 절차

1. 자동 생성된 PR에서 제목, 본문, 링크, 이미지 URL, 해시태그를 확인합니다.
2. 필요한 수정은 PR의 초안 파일에 반영하고 병합합니다.
3. 초안 파일의 `네이버 블로그 복사 영역`을 네이버 편집기에 붙여 넣습니다.
4. 네이버 미리보기에서 문단과 이미지를 다시 확인합니다.
5. 사용자가 최종 게시 버튼을 직접 누릅니다.

## GitHub Pages 배포

저장소 설정의 Pages 항목에서 `main` 브랜치의 루트 디렉터리를 배포 원본으로 지정합니다. 현재 설정은 프로젝트 사이트 주소를 기준으로 합니다.

```yaml
url: "https://yunycho.github.io"
baseurl: "/naljabooks-blog"
```

기본 주소 검증 후 `blog.naljabooks.com`을 연결할 때는 DNS와 Pages 사용자 정의 도메인을 설정한 뒤 다음처럼 변경하고 전체 검증을 다시 실행합니다.

```yaml
url: "https://blog.naljabooks.com"
baseurl: ""
```
