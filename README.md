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
ruby scripts/verify_content_schema.rb
```

검증 스크립트는 초기 페이지와 글, title, description, canonical, `BlogPosting` 구조화 데이터, sitemap, RSS, robots, llms 파일과 `baseurl` 적용을 확인합니다. 콘텐츠 스키마 검증은 필수 메타데이터, 주제·관련 글 ID, 목차, 출처 연결과 Markdown 본문의 표현 독립성을 확인합니다.

## 글 작성

`_posts/YYYY-MM-DD-slug.md` 파일을 만들고 다음 front matter를 사용합니다.

```yaml
---
layout: post
lang: ko-KR
content_type: article
title: "글 제목"
description: "검색 결과와 공유 카드에 사용할 고유한 요약"
date: 2026-06-15
updated: 2026-06-15
last_modified_at: 2026-06-15
author:
  name: "도서출판 날자 · 날자꾸러미 편집부"
  url: "https://naljabooks.com"
  type: Organization
category: "유추와 문해력"
topics: ["analogy-learning", "developmental-learning"]
tags: ["유추력", "문해력"]
related: ["analogy-learning-and-transfer-to-daily-life"]
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

`topics`에는 `_data/topics.yml`에 정의된 안정적인 ID를 사용합니다. `related`에는 제목이나 URL을 반복하지 않고 대상 글의 날짜를 제외한 파일명(slug)만 기록합니다. 관련 글을 지정하지 않을 때는 `related: []`로 두며, 화면에서는 첫 번째 주제가 같은 최신 글을 자동으로 제안합니다.

`updated`는 화면과 기계용 출력에서 사용하는 수정일이고, `last_modified_at`은 검색용 구조화 데이터가 사용하는 수정일입니다. 두 값은 항상 같게 기록하며 콘텐츠 스키마 검증에서 불일치를 차단합니다.

목차를 사용할 때는 본문의 제목에 같은 ID를 지정합니다.

```markdown
## 본문 제목 {#section-id}
```

수치와 연구 주장은 확인 가능한 원문과 연결합니다. 일반 교육 정보와 날자꾸러미의 제품·설계 관점을 구분하고, 효과를 보장하는 표현은 사용하지 않습니다.

## 재사용 가능한 콘텐츠 출력

하나의 Markdown 원본에서 다음 출력을 함께 생성합니다.

- `/llms.txt`: 전체 글의 제목, 요약, 주소와 메타데이터 목록
- `/llms-full.txt`: 공개 글 본문과 출처를 모은 전체 텍스트
- `/llms-en.txt`: 영어 글만 모은 AI용 색인
- `/content/index.json`: 외부 도구가 읽을 수 있는 콘텐츠 목록
- `/content/en/index.json`: 영어 글만 담은 콘텐츠 목록
- `/feed.json`: 한국어 글의 HTML과 일반 텍스트 본문을 포함한 JSON Feed
- `/en/feed.json`: 영어 글의 JSON Feed
- `/feed.xml`: 구독 도구를 위한 RSS 피드

주제 페이지와 관련 글도 각 글의 `topics`와 `related` 메타데이터를 기준으로 생성하므로 제목이나 설명을 여러 파일에 반복해서 적지 않습니다.

## 영어 번역 운영

한국어 글은 `_posts`, 영어 번역은 `_english`에서 관리합니다. 서로 같은 글에는 동일한 `translation_key`를 지정하고, 실제 한국어·영어 주소는 `_data/translations.yml` 한 곳에서 연결합니다. 영어 글에는 다음 번역 상태를 기록합니다.

- `translation_status: ai-assisted` 또는 `human-reviewed`
- `source_updated`: 번역이 따라간 한국어 원문의 `updated` 날짜
- `translation_updated`: 영어 번역을 마지막으로 수정한 날짜

한국어 원문의 `updated`가 바뀌었는데 영어 글의 `source_updated`가 따라가지 않으면 콘텐츠 검증이 실패합니다. 이때 영어 번역을 다시 확인한 뒤 두 날짜를 갱신합니다. 영어 페이지에는 한국어 원문이 기준 문서라는 안내와 언어 전환 링크가 표시됩니다.

영어 페이지의 구조화 데이터에는 `Nalja Books and Nalkku Editorial Team`을 기본 작성자·출판 주체로 사용합니다. 개인 저자가 있는 글은 영어 저자명을 표시하며, 모든 영어 페이지에 Nalja Books의 영문 조직 설명과 전문 분야를 별도 `Organization` 데이터로 제공합니다.

## IndexNow 자동 제출

`main` 브랜치에 공개 콘텐츠가 반영되면 `.github/workflows/indexnow.yml`이 같은 커밋의 GitHub Pages 배포 완료를 기다립니다. 이후 이번 커밋에서 추가·수정·삭제된 공개 URL만 `api.indexnow.org`에 제출합니다. 공통 레이아웃·설정·데이터 변경으로 모든 페이지가 바뀐 경우에는 배포된 sitemap의 URL 전체를 제출합니다.

IndexNow 소유권 키는 사이트에 공개되어야 하는 프로토콜 키이며 비밀번호가 아닙니다. 키 파일은 `/d16572b6a4c3cec49332e841d46eb2f2.txt`에서 제공됩니다. 수동 재실행은 GitHub Actions의 **Submit changed URLs to IndexNow → Run workflow**에서 할 수 있습니다.

## 편집·검색 전략

날자 아카이브는 검색량이 큰 키워드만 좇지 않고, 사람들이 이미 찾는 말과 날자꾸러미가 만들어 가는 언어를 연결하는 방식으로 운영합니다. 자동 게시와 수동 발행 모두 [편집·검색 전략](docs/editorial-search-strategy.md)을 기준으로 기둥글 여부, `/topics/` 연결, 색인 요청 필요성을 판단합니다.

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
