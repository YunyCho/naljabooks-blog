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
