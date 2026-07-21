# 중등도 지적장애 경험 연구 백서·공개 초안 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 원본을 보존하면서 근거 등급이 명확한 내부 백서 1편과 공개 전 검토용 비공개 초안 5편을 만들고 production 사이트 비노출을 자동 검증한다.

**Architecture:** 연구 백서는 검증된 주장과 해석을 분리하는 단일 기준 문서로 두고, 공개 초안은 백서의 근거를 주제별로 좁혀 독립 파일로 작성한다. `drafts/`를 Jekyll 제외 대상으로 지정하고 전용 Ruby 검증기가 파일 구조, 위험 표현, 용어, 필수 메타데이터와 `_site` 비노출을 확인한다.

**Tech Stack:** Markdown, Jekyll 3.10, Ruby 표준 라이브러리, ripgrep, Git

---

## 파일 구조

- Create: `docs/research/moderate-intellectual-disability-lived-experience-evidence-review.md` — 내부 근거 백서
- Create: `drafts/moderate-intellectual-disability-series/01-expression-is-not-the-limit-of-understanding.md` — 표현과 이해 초안
- Create: `drafts/moderate-intellectual-disability-series/02-when-yes-is-not-informed-agreement.md` — 묵종과 동의 초안
- Create: `drafts/moderate-intellectual-disability-series/03-private-speech-is-not-just-problem-behavior.md` — 사적 언어 초안
- Create: `drafts/moderate-intellectual-disability-series/04-pain-and-sensory-needs-mistaken-for-intellectual-disability.md` — 감각·통증 초안
- Create: `drafts/moderate-intellectual-disability-series/05-safety-literacy-against-counterfeit-friendship.md` — 메이트 크라임 초안
- Create: `scripts/verify_research_drafts.rb` — 백서·초안 구조와 공개 비노출 검증
- Modify: `_config.yml` — `drafts`를 Jekyll 제외 경로에 추가

## Task 1: 검증기를 먼저 추가해 RED 확인

**Files:**
- Create: `scripts/verify_research_drafts.rb`
- Modify: `_config.yml`
- Test: `scripts/verify_research_drafts.rb`

- [ ] **Step 1: 실패하는 검증기 작성**

`scripts/verify_research_drafts.rb`를 다음 책임으로 작성한다.

```ruby
#!/usr/bin/env ruby

require "pathname"
require "yaml"

ROOT = Pathname.new(__dir__).join("..").expand_path
WHITEPAPER = ROOT.join("docs/research/moderate-intellectual-disability-lived-experience-evidence-review.md")
DRAFT_DIR = ROOT.join("drafts/moderate-intellectual-disability-series")
DRAFTS = %w[
  01-expression-is-not-the-limit-of-understanding.md
  02-when-yes-is-not-informed-agreement.md
  03-private-speech-is-not-just-problem-behavior.md
  04-pain-and-sensory-needs-mistaken-for-intellectual-disability.md
  05-safety-literacy-against-counterfeit-friendship.md
].freeze
REQUIRED_DRAFT_LABELS = [
  "게시 후보 제목", "description", "권장 category", "권장 tags",
  "키워드 연결", "핵심 요약", "출처", "관련 글 연결 제안", "공개 전 확인"
].freeze
FORBIDDEN_ABSOLUTES = ["IQ 50의 세계", "어느 경우에도", "감정 기능은 온전하다", "40~100배", "80%"].freeze

errors = []
config = YAML.safe_load(ROOT.join("_config.yml").read, aliases: true)
errors << "_config.yml: drafts must be excluded" unless Array(config["exclude"]).include?("drafts")

unless WHITEPAPER.file?
  errors << "missing #{WHITEPAPER.relative_path_from(ROOT)}"
else
  text = WHITEPAPER.read
  ["[근거 A]", "[근거 B]", "[근거 C]", "[해석 D]", "설계 시사점", "근거 공백과 추가 검증"].each do |marker|
    errors << "whitepaper: missing #{marker}" unless text.include?(marker)
  end
  FORBIDDEN_ABSOLUTES.each do |phrase|
    errors << "whitepaper: unsafe phrase #{phrase}" if text.include?(phrase)
  end
end

DRAFTS.each do |name|
  path = DRAFT_DIR.join(name)
  unless path.file?
    errors << "missing #{path.relative_path_from(ROOT)}"
    next
  end
  text = path.read
  REQUIRED_DRAFT_LABELS.each do |label|
    errors << "#{name}: missing #{label}" unless text.include?(label)
  end
  errors << "#{name}: publication date must be assigned at publish time" if text.match?(/^date:|^updated:/)
  body_without_sources = text.split(/^## 출처/, 2).first
  errors << "#{name}: public terminology must center 지적장애인" if body_without_sources.match?(/발달장애인|발달장애/)
  FORBIDDEN_ABSOLUTES.each do |phrase|
    errors << "#{name}: unsafe phrase #{phrase}" if text.include?(phrase)
  end
end

site_drafts = ROOT.join("_site/drafts")
errors << "_site: drafts were published" if site_drafts.exist?

abort errors.join("\n") unless errors.empty?
puts "Research draft verification passed"
```

- [ ] **Step 2: 검증기가 산출물 부재로 실패하는지 확인**

Run: `ruby scripts/verify_research_drafts.rb`

Expected: FAIL. `_config.yml: drafts must be excluded`, 백서 1개와 초안 5개 누락 메시지가 출력된다.

- [ ] **Step 3: Jekyll 비노출 설정 추가**

`_config.yml`의 `exclude:` 목록에 다음 항목을 추가한다.

```yaml
  - drafts
```

- [ ] **Step 4: 설정만으로는 여전히 RED인지 확인**

Run: `ruby scripts/verify_research_drafts.rb`

Expected: FAIL. `drafts must be excluded` 오류는 사라지고 백서·초안 누락 오류만 남는다.

- [ ] **Step 5: 검증기와 설정 커밋**

```bash
git add _config.yml scripts/verify_research_drafts.rb
git commit -m "test: guard private research drafts"
```

## Task 2: 근거 등급형 내부 백서 작성

**Files:**
- Create: `docs/research/moderate-intellectual-disability-lived-experience-evidence-review.md`
- Reference only: `/Users/yuny/Downloads/중등도지적장애_주관적경험_실증문헌종합_개정.md`
- Test: `scripts/verify_research_drafts.rb`

- [ ] **Step 1: 원본 무결성 기록**

Run:

```bash
shasum -a 256 '/Users/yuny/Downloads/중등도지적장애_주관적경험_실증문헌종합_개정.md'
```

Expected: SHA-256 한 줄을 실행 기록에 보관한다.

- [ ] **Step 2: 공식 정의와 핵심 출처 확인**

다음 우선순위로 원문을 확인한다.

1. AAIDD·ASHA·WHO 등 공식 전문기관
2. PubMed·PMC에 등재된 원 논문과 체계적 문헌고찰
3. 출판사 원문 페이지
4. 국내 KCI·학술지 원문

확인하지 못한 Grokipedia, Wikipedia, ResearchGate 기반 주장은 본문에서 제외하고 `근거 공백과 추가 검증`에 기록한다. 감각 손상 배수, 청소년 피해 80%, 사적 언어의 약물 오인 빈도는 원 모집단과 직접 근거를 확인하지 못하면 수치와 빈도 표현을 쓰지 않는다.

- [ ] **Step 3: 백서 본문 작성**

백서는 아래 제목과 절을 정확히 포함한다.

```markdown
# 중등도 지적장애인의 경험을 이해하기 위한 실증 문헌 종합

> 인지·언어·감각·감정·관계에서 드러나는 지원의 조건

## 문서의 목적과 사용 범위
## 용어와 범위
## 근거를 읽는 네 단계
## 인지와 작업기억
## 언어와 의사소통
## 감각과 통증
## 감정과 사회적 경험
## 동의, 관계와 착취 위험
## 콘텐츠 재현 원칙
## 근거 공백과 추가 검증
## 참고문헌
```

각 연구 주장 문단은 `[근거 A]`, `[근거 B]`, `[근거 C]` 중 하나로 시작한다. 생활 언어로 확장한 문단은 `[해석 D]`로 시작하고, 제품 적용은 `**설계 시사점:**`으로 분리한다. 표현된 말이 이해의 전부가 아닐 수 있다는 점, 혼잣말만으로 정신증을 판단할 수 없다는 점, 행동을 장애 탓으로 돌리기 전에 통증·감각·환경·의사소통 기능을 확인해야 한다는 점을 조건부 문장으로 서술한다.

- [ ] **Step 4: 백서 위험 표현 검사**

Run:

```bash
rg -n 'IQ 50의 세계|어느 경우에도|온전하다|40~100배|80%|grokipedia|wikipedia|researchgate' docs/research/moderate-intellectual-disability-lived-experience-evidence-review.md
```

Expected: 일치 없음. 참고문헌의 공식 명칭에 포함된 경우가 아니라면 모두 제거하거나 근거 공백 설명으로 바꾼다.

- [ ] **Step 5: 중간 검증**

Run: `ruby scripts/verify_research_drafts.rb`

Expected: FAIL. 백서 관련 오류는 사라지고 초안 5개 누락 오류만 남는다.

- [ ] **Step 6: 백서 커밋**

```bash
git add docs/research/moderate-intellectual-disability-lived-experience-evidence-review.md
git commit -m "docs: revise moderate intellectual disability evidence review"
```

## Task 3: 표현·동의 공개 초안 작성

**Files:**
- Create: `drafts/moderate-intellectual-disability-series/01-expression-is-not-the-limit-of-understanding.md`
- Create: `drafts/moderate-intellectual-disability-series/02-when-yes-is-not-informed-agreement.md`
- Reference: `docs/editorial-search-strategy.md`
- Reference: `docs/research/moderate-intellectual-disability-lived-experience-evidence-review.md`
- Test: `scripts/verify_research_drafts.rb`

- [ ] **Step 1: 편집·검색 전략 다시 읽기**

Run: `sed -n '1,260p' docs/editorial-search-strategy.md`

Expected: 큰 키워드, 날자의 고유 키워드, 다리 역할 키워드와 중요 기둥글 기준을 확인한다.

- [ ] **Step 2: 표현과 이해 초안 작성**

첫 초안은 다음 메타 정보를 사용한다.

```markdown
# 게시 후보 제목
말로 표현된 것만으로 지적장애인의 이해를 판단하면 안 되는 이유

## description
지적장애인의 표현 언어와 읽기이해는 같은 수준으로 드러나지 않을 수 있습니다. 말로 나온 답만으로 이해 능력을 단정하지 않고 표현 지원과 기다림이 필요한 이유를 설명합니다.

## 권장 category
권리와 문해력

## 권장 tags
지적장애, 표현 언어, 읽기이해, 의사소통 지원, 자기결정, 날자꾸러미

## 키워드 연결
- 큰 키워드: 지적장애, 특수교육
- 날자의 고유 키워드: 날자꾸러미, 배운 것이 삶으로 이어지도록
- 다리 역할 키워드: 읽기이해, 표현 지원, 자기결정
```

본문은 `핵심 요약`, `말로 나온 것이 이해의 전부는 아니다`, `수용·표현·화용은 따로 살펴야 한다`, `질문의 형식이 답을 바꾼다`, `기다림과 선택지가 필요한 이유`, `날자꾸러미의 표현 지원`, `결론`, `출처`, `관련 글 연결 제안`, `공개 전 확인` 순서로 작성한다. “머릿속에는 다 있다”는 표현은 사용하지 않는다.

- [ ] **Step 3: 묵종과 동의 초안 작성**

두 번째 초안은 다음 메타 정보를 사용한다.

```markdown
# 게시 후보 제목
지적장애인의 “예”는 언제 진짜 동의가 아닌가

## description
지적장애인이 질문에 “예”라고 답했더라도 충분히 이해하고 선택한 동의인지 확인해야 합니다. 묵종을 줄이는 질문 방식과 자기결정 지원 원칙을 설명합니다.

## 권장 category
권리와 문해력

## 권장 tags
지적장애, 묵종, 동의, 자기결정, 의사소통 지원, 안전 문해력

## 키워드 연결
- 큰 키워드: 지적장애, 특수교육
- 날자의 고유 키워드: 날자꾸러미, 배운 것이 삶으로 이어지도록
- 다리 역할 키워드: 자기결정, 표현 지원, 쉬운 정보
```

본문은 `핵심 요약`, `예라는 답과 동의는 다르다`, `묵종은 질문 상황에서 커질 수 있다`, `권력 차이가 답에 미치는 영향`, `예·아니오 대신 선택을 확인하는 법`, `자기결정을 지키는 지원`, `결론`, `출처`, `관련 글 연결 제안`, `공개 전 확인` 순서로 작성한다. 묵종을 성격이나 필연적 생존 전략으로 단정하지 않는다.

- [ ] **Step 4: 중간 검증**

Run: `ruby scripts/verify_research_drafts.rb`

Expected: FAIL. 초안 01·02 오류는 없고 03·04·05 누락만 남는다.

- [ ] **Step 5: 첫 두 초안 커밋**

```bash
git add drafts/moderate-intellectual-disability-series/01-expression-is-not-the-limit-of-understanding.md drafts/moderate-intellectual-disability-series/02-when-yes-is-not-informed-agreement.md
git commit -m "docs: draft expression and consent articles"
```

## Task 4: 혼잣말·감각·관계 안전 공개 초안 작성

**Files:**
- Create: `drafts/moderate-intellectual-disability-series/03-private-speech-is-not-just-problem-behavior.md`
- Create: `drafts/moderate-intellectual-disability-series/04-pain-and-sensory-needs-mistaken-for-intellectual-disability.md`
- Create: `drafts/moderate-intellectual-disability-series/05-safety-literacy-against-counterfeit-friendship.md`
- Reference: `docs/editorial-search-strategy.md`
- Reference: `docs/research/moderate-intellectual-disability-lived-experience-evidence-review.md`
- Test: `scripts/verify_research_drafts.rb`

- [ ] **Step 1: 혼잣말 초안 작성**

메타 정보:

```markdown
# 게시 후보 제목
지적장애인의 혼잣말을 문제행동으로만 보면 놓치는 것

## description
지적장애인의 혼잣말은 계획, 감정조절, 문제해결을 돕는 자기 대화일 수 있습니다. 혼잣말만으로 병리화하지 않고 맥락과 변화를 살펴야 하는 이유를 설명합니다.

## 권장 category
배움과 일상

## 권장 tags
지적장애, 혼잣말, 자기 대화, 감정조절, 의사소통 지원, 날자꾸러미
```

`혼잣말만으로 환각이나 망상으로 판단해서는 안 된다`고 쓰되, 갑작스러운 변화나 고통·기능 저하가 동반되면 전문가 평가가 필요하다는 안전 문장을 함께 둔다.

- [ ] **Step 2: 통증과 감각 초안 작성**

메타 정보:

```markdown
# 게시 후보 제목
지적장애인의 통증과 감각 문제가 지능 탓으로 오인될 때

## description
지적장애인의 행동 변화 뒤에는 통증, 청각·시각 문제, 불편한 환경이 있을 수 있습니다. 장애 탓으로 단정하기 전에 직접 묻고 점검해야 할 순서를 설명합니다.

## 권장 category
권리와 문해력

## 권장 tags
지적장애, 통증 표현, 감각 지원, 진단적 가림, 의사소통 지원, 건강 문해력
```

검증되지 않은 유병률과 배수는 사용하지 않는다. `행동 변화 → 당사자에게 묻기 → 통증·감각·환경 확인 → 의사소통 방식 조정 → 의료 평가 연결` 순서를 제시한다.

- [ ] **Step 3: 위조된 우정과 안전 문해력 초안 작성**

메타 정보:

```markdown
# 게시 후보 제목
친구라는 이름의 착취를 알아차리는 지적장애인 안전 문해력

## description
친구 관계를 가장한 금전·주거·성적 착취는 외로움과 의사소통 장벽을 이용할 수 있습니다. 관계를 제한하지 않으면서 위험 신호와 도움 요청 방법을 익히는 안전 문해력을 설명합니다.

## 권장 category
권리와 문해력

## 권장 tags
지적장애, 안전 문해력, 메이트 크라임, 자기결정, 관계, 도움 요청
```

관계를 금지하거나 자립을 제한하는 결론을 피한다. 상호성, 비밀 요구, 돈·집·신체 경계, 거절 뒤 반응, 믿을 수 있는 제3자와의 확인을 구체적인 판단 기준으로 제시한다. 출처가 약한 80% 수치는 사용하지 않는다.

- [ ] **Step 4: 초안 5편 전체 검증**

Run: `ruby scripts/verify_research_drafts.rb`

Expected: `Research draft verification passed`

- [ ] **Step 5: 마지막 세 초안 커밋**

```bash
git add drafts/moderate-intellectual-disability-series/03-private-speech-is-not-just-problem-behavior.md drafts/moderate-intellectual-disability-series/04-pain-and-sensory-needs-mistaken-for-intellectual-disability.md drafts/moderate-intellectual-disability-series/05-safety-literacy-against-counterfeit-friendship.md
git commit -m "docs: draft safety literacy article series"
```

## Task 5: 전체 검증과 인계

**Files:**
- Verify: `docs/research/moderate-intellectual-disability-lived-experience-evidence-review.md`
- Verify: `drafts/moderate-intellectual-disability-series/*.md`
- Verify: `_config.yml`
- Verify: `scripts/verify_research_drafts.rb`

- [ ] **Step 1: 원본 무결성 재확인**

Run: Task 2 Step 1과 같은 `shasum -a 256` 명령.

Expected: Task 2에서 기록한 SHA-256과 동일하다.

- [ ] **Step 2: production Jekyll 빌드**

Run: `JEKYLL_ENV=production bundle exec jekyll build --trace`

Expected: exit 0. `_site/drafts`가 생성되지 않는다.

- [ ] **Step 3: 전체 검증 실행**

Run:

```bash
ruby scripts/verify_research_drafts.rb
ruby scripts/verify_site.rb
ruby scripts/verify_pinned_home.rb
git diff --check
```

Expected:

```text
Research draft verification passed
Site verification passed
Pinned homepage integration verification passed
```

`git diff --check`는 출력 없이 exit 0이다.

- [ ] **Step 4: 공개 상태 불변 확인**

Run:

```bash
test ! -d _site/drafts
rg -n '말로 표현된 것만으로|진짜 동의가 아닌가|혼잣말을 문제행동|통증과 감각 문제가|친구라는 이름의 착취' _site || true
```

Expected: 초안 제목과 본문이 `_site`에서 검색되지 않는다.

- [ ] **Step 5: 작업 상태 검토**

Run: `git status --short && git log --oneline -5`

Expected: 기존 미추적 `.superpowers/` 외 작업 파일은 모두 커밋되어 있다. 원격 push와 공개 게시는 수행하지 않는다.

- [ ] **Step 6: 사용자 인계**

최종 보고에 백서 경로, 초안 5개 경로, 출처 검증에서 제외·유보한 핵심 주장, 모든 검증 결과를 포함한다. 다음 단계로 5편의 게시 순서와 첫 게시 글을 사용자에게 선택받는다.
