---
layout: post
title: "AI 시대 전환과 지적장애인: 위험·기회·설계 원칙"
description: "AI 시대 지적장애인의 인지 접근성, 자기결정, 학습지원과 위험을 국제 연구와 한국 정책을 바탕으로 검토하고 포용적 AI 설계 원칙을 정리합니다."
date: 2026-07-03 16:55:00 +0900
updated: 2026-07-03 16:55:00 +0900
author:
  name: "도서출판 날자 · 날자꾸러미 편집부"
  url: "https://naljabooks.com"
  type: Organization
category: "AI와 권리"
tags: ["AI 시대", "지적장애", "인지 접근성", "자기결정", "특수교육 AI", "날자꾸러미"]
toc:
  - id: summary
    title: "핵심 요약"
  - id: problem
    title: "문제의식"
  - id: international-trends
    title: "국제 학술 동향"
  - id: sdt
    title: "자기결정 기반 설계"
  - id: cognitive-justice
    title: "인지정의와 최소기준"
  - id: inclusive-roadmap
    title: "포용적 생성형 AI 로드맵"
  - id: executive-function
    title: "실행기능 지원"
  - id: data-self-advocacy
    title: "데이터와 자기옹호"
  - id: learning-evidence
    title: "AI 학습 효과 근거"
  - id: korea-policy
    title: "한국 정책과 공백"
  - id: findings
    title: "새로운 관점"
  - id: nalkku-view
    title: "날자꾸러미와의 교차점"
  - id: references
    title: "전체 참고문헌"
sources:
  - title: "Artificial Intelligence and Health Equity for People with Disabilities: An Integrated Framework for Disability-Inclusive AI Design"
    organization: "Umucu et al."
    url: "https://pmc.ncbi.nlm.nih.gov/articles/PMC12374087/"
  - title: "Repositioning intellectual disability in the ethics of digital mental health technologies"
    organization: "Babu & Joseph"
    url: "https://www.frontiersin.org/journals/psychiatry/articles/10.3389/fpsyt.2025.1691940/full"
  - title: "Roadmap to inclusive Artificial Intelligence for persons with intellectual disability"
    organization: "Guasch et al."
    url: "https://www.jacces.org/index.php/jacces/article/view/625"
  - title: "Executive Dysfunction by Design: A Cognitive Accessibility Analysis of AI Support vs. Healthcare Barriers"
    organization: "Moore"
    url: "https://dl.acm.org/doi/10.1145/3663547.3749831"
  - title: "Empowering People with Intellectual and Developmental Disabilities through Cognitively Accessible Visualizations"
    organization: "Wu et al."
    url: "https://arxiv.org/pdf/2309.12194"
  - title: "Applying artificial intelligence in career education for students with intellectual disabilities"
    organization: "Hong & Kim"
    url: "https://link.springer.com/article/10.1007/s10639-024-12809-6"
  - title: "The effectiveness of using artificial intelligence in improving academic skills of school-aged students with mild intellectual disabilities in Saudi Arabia"
    organization: "Alsolami"
    url: "https://doi.org/10.1016/j.ridd.2024.104884"
  - title: "Bridging gaps with technology: A bibliometric review of inclusive education through educational technology"
    organization: "Contemporary Educational Technology"
    url: "https://www.cedtech.net/download/bridging-gaps-with-technology-a-bibliometric-review-of-inclusive-education-through-educational-17980.pdf"
---

## 핵심 요약 {#summary}

- 생성형 AI는 지적장애인의 학습과 표현을 지원할 잠재력이 있지만, 언어와 추상 중심의 인터페이스 자체가 새로운 장벽이 될 수 있다.
- 국제 연구는 자기결정, 인지정의, 당사자 공동설계와 사람의 검토를 포용적 AI의 핵심 조건으로 제시한다.
- 지적장애인 대상 AI 학습 효과 연구는 아직 소표본·단기·비통제 설계가 많아 효과를 과장하지 않는 태도가 필요하다.
- 날자꾸러미는 유추와 서사적 변환을 통해 추상을 경험에 연결하되, AI를 사람의 판단과 관계를 보완하는 도구로 다룬다.

> 이 글은 2026년 7월 3일 기준 시드 자료 8건과 소주제별 보강 검색을 바탕으로 작성한 오픈 리서치다. 지적장애(ID), 학습장애(LD), 지적·발달장애(IDD)를 구분하며, 한국 정책과 공식 명칭에서는 법정 용어를 그대로 사용한다.

## 문제의식 {#problem}

AI 전환이 모든 사람에게 같은 속도, 같은 방향으로 오지 않는다는 것은 이제 상식에 가깝다. 그러나 지적장애인에게 이 전환이 갖는 의미는 다른 취약집단과도 질적으로 다르다. 세 가지 이유 때문이다.

**첫째, AI의 핵심 인터페이스가 '언어와 추상'이라는 점.** 생성형 AI는 텍스트 프롬프트, 추상적 개념 조작, 출력물에 대한 비판적 검증을 전제로 설계돼 있다. 이는 지적장애인의 상당수가 가장 어려움을 겪는 바로 그 능력들이다. 시각·청각 장애에 대해서는 스크린리더, 자막 같은 '변환 계층'이 존재하지만, 인지적 접근성에는 아직 그런 표준화된 변환 계층이 없다. 실제로 17개 상용·오픈 LLM의 장애 포용성을 감사한 연구는, 시각·청각·지체 장애 관련 질문에는 모델들이 폭넓게 대응하는 반면 발달·유전적 장애와 감각-인지 영역은 체계적으로 과소 대응된다는 것을 보여줬다(Dash et al., 2025, arXiv). 접근성 도구로 각광받는 기술이 정작 인지장애 영역에서 가장 약하다는 역설이다.

**둘째, 연구와 설계 과정 자체에서의 배제.** 디지털 정신건강 기술 윤리를 다룬 최근 논평은, 지적장애인이 디지털 헬스 연구와 시스템 설계에서 거의 완전히 부재한 것을 "패러다임적 실패"로 규정한다(Babu & Joseph, 2025, Frontiers in Psychiatry). 포용교육 테크 문헌 계량분석들도 같은 방향을 가리킨다. 2010~2025년 Scopus 등재 포용교육-에듀테크 문헌 184편을 분석한 연구는 이 분야의 급성장 속에서도 특정 장애 집단, 특히 보조공학과 지적장애 관련 주제가 상대적으로 소외돼 있음을 지적했고(CEDTech, 2026), 2004~2024년 지적장애-통합교육 문헌 1,562편을 분석한 별도 연구도 보조공학 등 과소연구 영역에 대한 후속 연구를 촉구했다(EduLearn, 2025, ERIC EJ1478896). 즉 "AI가 장애인을 돕는다"는 담론이 가장 활발한 시기에, 지적장애인은 그 담론의 데이터에서도 설계 테이블에서도 빠져 있다.

**셋째, 위험과 기회의 비대칭성.** 기회 쪽에는 실질적인 것들이 있다. 텍스트 단순화(Easy Read 자동 생성), 실행기능 보조, 개별화 학습, 의사소통 지원(AAC) 등이다. 그러나 위험 쪽에는 과의존과 자동화 편향(AI 출력을 비판 없이 수용하는 경향), 의인화에 따른 심리적 취약성, 알고리즘이 '정상성' 기준으로 훈련되어 고용·평가에서 지적장애인을 구조적으로 불리하게 판정할 가능성 등이 지적된다(WEF, 2023; Frontiers in Education, 2026). 지적장애인의 경우 이 위험들을 스스로 감지하고 방어할 인지적 자원이 상대적으로 제한적이므로, "같은 도구, 더 큰 기회, 더 큰 위험"이라는 비대칭 구조가 성립한다.

요컨대 문제는 "AI를 지적장애인에게 어떻게 보급할 것인가"가 아니라, **"지적장애인의 인지 방식이 배제된 채 구축되고 있는 AI 인프라를, 누가, 어떤 원칙으로, 어느 지점에서 교정할 것인가"** 다. 아래에서 이 질문을 둘러싼 국제 학술 동향을 여섯 갈래로 살핀다.

---

## 국제 학술 동향 상세 조사 {#international-trends}

### 자기결정이론(SDT) 기반 장애포용적 AI 설계 {#sdt}

**핵심 출처.** Umucu 등이 제안한 통합 프레임워크는 자기결정이론(SDT)과 자기효능감이론(SET)을 결합해 장애인 대상 AI 설계를 안내한다(Umucu et al., 2025, INQUIRY / PMC12374087). 대상은 장애인 전반(건강·재활 맥락)이며 지적장애 특정 프레임워크는 아니라는 점을 먼저 밝혀둔다.

**핵심 주장.** 이 프레임워크의 논리는 다음과 같다. (1) 자율성(autonomy): 맞춤 설정과 적응형 인터페이스를 통해 사용자가 도구를 자기 방식대로 통제할 수 있어야 한다. (2) 유능감(competence): 접근 가능한 설계 자체가 사용 성공 경험을 만들어 자기효능감을 키운다. (3) 관계성(relatedness): 장애 당사자가 공동설계자(co-designer)로 참여해 실제 삶의 사용 사례를 정의할 때 도구에 대한 동기와 소속감이 생긴다. 포용적·참여적 설계 없이 만들어진 AI는 기존 건강·재활 격차를 재생산할 위험이 있다는 것이 출발 전제다.

**실증 근거와 계보.** SDT를 기술 설계에 적용하는 흐름 자체는 새롭지 않다. AI 교육 맥락에서 SDT 기반 설계 접근을 제안한 선행 연구가 있고(Xia, Chiu et al., 2022, Computers & Education — 다만 이 연구의 대상은 일반 학습자의 포용적 AI 교육이다), 지적장애를 포함한 장애학생의 전환계획(transition planning)에서 기술 사용이 자기결정 수준을 높인다는 실증은 10년 이상 전부터 축적돼 왔다(Wehmeyer, Palmer, Williams-Diehm, Shogren, Davies & Stock, 2011, Journal of Special Education Technology). 지적장애 분야에서 자기결정 기술(선택하기, 의사결정, 목표설정, 자기옹호)이 학업·고용·지역사회 성과와 강하게 연결된다는 것도 확립된 지식이다(Shogren & Wehmeyer 계열 연구, AAIDD).

**한계와 미해결 질문.** (1) Umucu 등의 프레임워크는 개념 모형이며, 지적장애인 대상 AI 도구에서 SDT 구성요소가 실제로 작동하는지 검증한 실증 연구는 검색 범위 내에서 확인되지 않았다. (2) 더 근본적인 긴장이 있다: 자율성 지원과 안전 보호(safeguarding)가 충돌할 때 어느 쪽을 우선할 것인가. SDT 프레임워크는 자율성을 밀지만, 후견주의적 보호 전통이 강한 지적장애 서비스 현장에서 이 원칙이 어떻게 협상되는지에 대한 연구는 얇다. (3) '맞춤 설정 가능성'이 곧 자율성인가에 대한 이견도 가능하다 — 설정 메뉴가 복잡할수록 오히려 인지적 부담이 커진다는 것이 인지 접근성 분야의 통상적 관찰이기 때문이다.

### 인지정의(cognitive justice) 관점의 디지털 윤리와 최소기준 {#cognitive-justice}

**핵심 출처.** Babu와 Joseph은 디지털 정신건강 기술 윤리에서 지적장애의 위치를 재정립하자고 주장한다(Babu & Joseph, 2025, Frontiers in Psychiatry). 이들이 말하는 인지정의는 다양한 인지·소통 방식을 동등하게 인정하고 기술 수명주기 전체에 통합하는 것, 즉 '인식론적 포함(epistemic inclusion)'이다.

**핵심 주장 — 다섯 가지 최소기준.** 이 논문의 실용적 기여는 선언이 아니라 체크 가능한 최소기준을 제시했다는 데 있다. (1) 조달 단계에서 인지 접근성 감사 의무화, (2) 훈련 데이터셋에 지적장애인 데이터 포함, (3) 지원의사결정(supported decision-making) 도구와 Easy Read 포맷 기본 탑재, (4) 지적장애 당사자와의 공동설계 프로토콜, (5) 상설 자문 역할을 보장하는 거버넌스 구조. 접근성을 '출시 후 보완'이 아니라 조달·데이터·거버넌스라는 상류(upstream) 단계의 의무로 끌어올린 점이 특징이다.

**이론적 배경.** 이 주장은 인식론적 부정의(epistemic injustice) 철학과 연결된다. Catala는 기존 인식론적 부정의 논의 자체가 언어·명제 중심(logocentric) 편향 때문에 지적장애인을 '인식 주체'의 범위에서 배제해 왔다고 비판하며, 다원주의적 인식 행위성 개념을 제안했다(Catala, 2020, Ethical Theory and Moral Practice). AI가 불투명성 등의 특성으로 증언적·해석학적 부정의를 증폭한다는 논의도 확장 중이다(Wiley, A Companion to Applied Philosophy of AI, 2025; OzCHI 2025 등). 글로벌 사우스 관점에서 디지털 정신건강 리터러시의 인식정의를 요구하는 흐름도 같은 계열이다(Frontiers in Psychiatry, 2025, 1611988).

**실증 근거의 정직한 상태.** 주목할 점은 Babu와 Joseph 스스로가 "이 부정합을 확증하거나 반박할 견고한 실증 데이터가 현재 없다"고 인정한다는 것이다 — 지적장애인이 연구 자체에서 부재하기 때문에 배제의 규모조차 측정되지 않는다. 감정인식, 자연어처리, 자살위험 예측 도구에서 지적장애인의 '알고리즘적 비가시성'을 지적하지만 이는 논증이지 측정이 아니다.

**한계와 미해결 질문.** (1) 이 영역은 의견 논문(perspective/opinion) 중심이며 실증 공백이 크다. (2) '인지정의'의 조작적 정의와 측정 지표에 대한 합의가 없다 — 조달 감사를 의무화하자는 제안도 무엇을 통과 기준으로 삼을지는 미정이다. (3) 저자들 스스로 인정하듯 참여설계·장애정의 프레임워크는 이론적으로는 유망하나 "실무에서는 주변적"에 머물러 있고, 왜 채택이 안 되는가(비용? 규제 부재? 당사자 참여의 실행 난이도?)에 대한 연구가 필요하다.

### 생성형 AI를 위한 UD/UCD 로드맵 {#inclusive-roadmap}

**핵심 출처.** 스페인 4개 대학(카를로스3세대, 콤플루텐세대, UNED, 카탈루냐공대)의 HumanAI 프로젝트 팀은 지적장애인을 위한 포용적 생성형 AI 로드맵을 제안했다(Guasch, Rodrigo, Francisco & Hervás, 2025, Journal of Accessibility and Design for All).

**핵심 주장.** 장애·접근성·사용성 개념을 정리한 뒤, 보편적 설계(UD)와 사용자중심설계(UCD)를 생성형 AI에 적용해 "이해 가능하고, 사용 가능하고, 맞춤 가능한" 시스템을 만들자는 것이다. 구체적으로는 유럽 접근성 표준 EN 301 549와 WCAG 2.2 준수, 쉬운 언어(easy-read) 지침 적용을 로드맵의 축으로 삼는다. 스페인 맥락의 생성형 AI 개발에서 지적장애인이 마주치는 구체적 장벽을 식별하고 권고안을 제시한다.

**인접 실증 연구.** 로드맵의 실현 가능성을 가늠할 실증 연구가 몇 갈래 있다. (1) 스페인어 Easy Read 텍스트를 LLM 파인튜닝으로 자동 생성하려는 시도가 있으며, 쉬운글 적응 코퍼스로 디코더 기반 모델을 조정하는 접근이 보고됐다(Frontiers in Computer Science, 2024, 10.3389/fcomp.2024.1394705). (2) 독일어권에서는 지적장애인 당사자가 태블릿으로 비단순화·자동단순화·수동단순화 텍스트를 읽게 하고 이해도를 네 가지 방식(선다형 문항, 체감 난이도, 반응시간, 읽기속도)으로 측정한 연구가 CHI에 발표됐다(Säuberli et al., 2024, ACM CHI). 이 연구의 중요한 부산물은 방법론적 고발이다: 자동 텍스트 단순화 모델 대부분이 정작 1차 대상자인 지적장애인이 아니라 전문가나 크라우드워커에 의해 평가되고 있다는 것.

**한계와 미해결 질문.** (1) WCAG 계열 지침이 인지 접근성을 충분히 포괄하는가는 접근성 학계의 오랜 논쟁이다 — WCAG는 감각·운동 접근성에 비해 인지 영역 기준이 성숙하지 않으며, 로드맵이 표준 준수를 축으로 삼는 것 자체가 한계를 내장한다. (2) '쉬운 언어 자동 생성'의 품질 보증 문제: LLM이 생성한 Easy Read가 정보를 왜곡·누락할 때 누가 검증하는가. 당사자 검증을 표준화한 프로토콜은 아직 없다. (3) UD(모두를 위한 설계)와 UCD(특정 사용자 밀착 설계)는 실무에서 자원 배분이 충돌할 수 있는데, 로드맵 문헌은 이 긴장을 대체로 명시적으로 다루지 않는다.

### 실행기능 지원의 실증적 효과 {#executive-function}

**핵심 출처와 대상 명확화.** 시드로 제시된 ACM SIGACCESS 논문은 **지적장애가 아니라 ADHD 당사자의 1인칭 경험 보고**다(Moore, 2025, ASSETS '25). 실행기능장애(executive dysfunction)는 ADHD·자폐 등에서 두드러지는 특성으로, 지적장애와 겹칠 수 있으나 동일하지 않다. 이 구분을 유지한 채 읽어야 한다.

**핵심 주장.** 이 보고의 대조 구조가 흥미롭다. 한쪽에는 생성형 AI가 있다: 비선형적 입력을 거부하지 않고 받아 적응하며, 사용자에게 "실행기능을 즉석에서 수행하라"고 요구하지 않는 유연성으로 공동 창작을 가능하게 했다. 다른 쪽에는 약국·의료 시스템이 있다: 완벽한 기억, 정확한 타이밍, 무한한 끈기를 전제한 규칙으로 정작 지원이 가장 필요한 사람을 배제했다. 저자는 실행기능 장벽이 개인의 결함이 아니라 시스템 설계의 산물임을 — 제목 그대로 "설계에 의한 실행기능장애" — 논증한다. 정서적 효과도 언급된다: AI의 지원은 판단(judgment) 없이 제공되기에 도움 요청에 따르는 수치심 비용이 낮다.

**보강 근거.** CHI 2025에는 신경다양성 당사자들이 생성형 AI를 '파워유저'로 사용하는 방식에 대한 자기문화기술지 연구가 발표됐고(ACM CHI 2025, 10.1145/3706598.3713670), ADHD 기술 일반에 대해서는 당사자를 설계에서 배제한 채 신경전형적 규범을 반영해 '결함 교정' 프레임으로 만들어진다는 비판이 함께 제기된다(Moore, 2025에서 재론).

**한계와 미해결 질문.** (1) 이 영역의 증거는 n=1 경험 보고와 소규모 질적 연구가 중심이다. 효과크기를 말할 수 있는 단계가 아니다. (2) **지적장애인 대상 실행기능 AI 지원의 실증 연구는 검색 범위 내에서 확인되지 않았다** — ADHD에서의 긍정적 경험을 지적장애로 일반화하는 것은 정당화되지 않는다. 지적장애의 실행기능 프로파일은 다르고, AI와의 언어적 상호작용 자체가 장벽일 수 있다. (3) 열린 질문: 정서적 안전(판단 없는 지원)이라는 기제가 지적장애인에게도 작동하는가, 아니면 의인화·과신 위험이 그 이득을 상쇄하는가. 이는 2-2의 윤리 문헌과 정면으로 만나는 미해결 지점이다.

### 자기옹호 도구로서의 데이터 {#data-self-advocacy}

**핵심 출처.** Wu 등의 연구 계열은 지적·발달장애인(IDD)이 데이터를 자기옹호에 쓸 수 있게 하는 '인지적으로 접근 가능한 시각화'를 탐구한다. 1차 연구는 IDD 당사자들이 자신의 필요와 권리를 옹호하는 맥락에서 이미 데이터를 사용하고 있으나, 통상적 시각화가 요구하는 복잡한 인지 처리와 낮은 시각화 리터러시 때문에 기존 데이터 스토리텔링 도구를 "접근 불가능하고 위협적"으로 경험한다는 것을 보여줬다(Wu et al., 2023, arXiv:2309.12194).

**후속 실증.** 후속 공동설계 연구에서는 IDD 당사자 20명이 참여했다 — 4명이 6주간 온라인 '데이터 펜팔'로, 16명이 이틀간 대면 공동설계 세션으로(Wu et al., 2024, arXiv:2408.16072). 발견은 두 갈래다. (1) IDD 당사자들은 데이터 분석과 표현의 역량을 실제로 보여줬으나 개념적·기술적·정서적 장벽에 부딪힌다. (2) 설계 전략으로 "숫자를 서사로 변환하기"와 "데이터 디자인을 일상의 미감과 결합하기"가 도출됐다 — 추상적 수치 표현이 아니라 살아온 경험에 데이터를 정박시키는 접근이 유효했다.

**의의.** 이 계열의 중요성은 AI·데이터 기술의 방향을 '당사자를 위한 서비스 제공'에서 '당사자의 발화력 증강'으로 돌린다는 데 있다. 자기옹호는 지적장애 운동의 핵심 전통("Nothing about us without us")이고, 데이터가 제도와 협상하는 언어가 된 시대에 데이터 접근성은 곧 정치적 발언권의 문제다.

**한계와 미해결 질문.** (1) 표본이 작고(총 20명) 미국 맥락이며, 도출된 것은 효과 검증이 아니라 설계 지침이다. (2) 생성형 AI로 '숫자→서사' 변환을 자동화할 수 있다는 함의가 있으나, 그 경우 서사를 누가 소유하는가 — AI가 당사자의 이야기를 대신 써주는 순간 자기옹호의 '자기'가 침식되는 것 아닌가 — 라는 질문이 열려 있다. (3) 정서적 장벽(데이터에 대한 위축감)을 다루는 개입 연구는 아직 없다.

### AI 기반 학습 효과성 실증 연구 {#learning-evidence}

**한국 사례.** 홍(Hong)과 김(Kim)은 고등학교 지적장애 학생 20명을 대상으로 ADDIE 모형에 따라 개발한 AI 기반 진로교육 프로그램을 6주 12회기 운영하고, 진로자기효능감과 학습몰입의 유의미한 향상을 보고했다(Hong & Kim, 2024, Education and Information Technologies). 사전-사후 단일집단 설계로 보고돼 있어 통제집단 대비 효과는 확인되지 않는다.

**사우디 사례.** Alsolami는 제다의 경도 지적장애 학령기 학생을 대상으로 AI 도구(개인화 학습, 시각 보조, 게임화 요소)를 활용한 단기 중재가 읽기·수학 등 학업기술을 개선했다고 보고했다(Alsolami, 2025, Research in Developmental Disabilities 156:104884). 원문 전문 접근이 제한되어 표본 크기와 효과크기 등 세부 통계는 검색 범위 내에서 확인하지 못했음을 밝혀둔다.

**리뷰 수준의 증거.** 발달장애 학생 대상 AI 지원 학습 플랫폼을 SWOT 틀로 검토한 리뷰가 있고(Bulut, 2025, Journal of Intellectual Disability Research), 특수교육 AI 전반의 체계적 문헌고찰들은 개인화·접근성·정서 지원의 잠재력을 인정하면서도 대규모 실증의 부족, 알고리즘 공정성과 데이터 프라이버시 문제, 교사 준비 부족, 특정 장애 집단의 과소대표를 공통 장벽으로 꼽는다(Dumitru et al., 2026, Journal of Special Education Technology 계열 통합 리뷰 포함).

**진단 범주 구분이 드러나는 지점.** 2022~2025년 실험연구를 고찰한 한 체계적 문헌고찰(11개 연구, 참여자 3,033명)은 모든 연구가 긍정적 결과를 보고했다고 밝혔는데, 이 리뷰의 대상은 **학습장애(LD, 난독증 중심)이지 지적장애가 아니다**(Brain Sciences, 2025, 10.3390/brainsci15080806). 학습장애 대상 증거가 지적장애 대상 증거보다 훨씬 크고 빠르게 축적되고 있으며, 담론에서 이 둘이 자주 뭉뚱그려진다는 점 자체가 이 분야의 구조적 문제다. 지적장애 대상 연구는 위의 한국·사우디 사례처럼 소표본·단기·비통제 설계가 주류다.

**한계와 미해결 질문.** (1) 지적장애 대상 AI 학습 효과 연구 중 통제집단을 갖춘 중규모 이상 연구는 검색 범위 내에서 확인되지 않았다. (2) 보고된 결과가 거의 전부 긍정적이라는 사실은 효과의 보편성보다 출판 편향과 신기술 효과(novelty effect)를 의심하게 한다 — 부정적·무효과 결과의 부재가 열린 질문이다. (3) 유지(maintenance)와 일반화(generalization) — 중재 종료 후 효과가 지속되고 교실 밖으로 전이되는가 — 를 추적한 연구가 없다. (4) '무엇이 효과의 활성 성분인가'도 미분리 상태다: AI의 적응성인가, 게임화인가, 단지 집중적 성인 관심인가.

---

## 한국 정책 현황과 공백 분석 {#korea-policy}

검색으로 확인된 사실과, 확인되지 않은 공백을 구분해 적는다.

**확인된 정책 기반.**

- **AI 디지털교과서(AIDT).** 2025년 수학·영어·정보와 '국어(특수교육)'에 우선 도입됐다(교육부; 대한민국 정책브리핑, 2024). 특수교육 기본 교육과정은 국정도서로 국어·수학을 초·중·고까지 개발하고, 생활영어·정보통신활용 교과는 제외됐다. 접근성 기능으로 화면해설·자막(시·청각 중심)과 다국어 번역이 명시된다. 다만 2025년 말~2026년 AIDT의 법적 지위가 '교과서'에서 '교육자료'로 조정되는 논란 속에 2026년 확대 계획의 실효성에 대한 우려가 보도되고 있다(교육언론 보도, 2025~2026).
- **디지털포용법.** 2025년 1월 21일 제정, 2026년 1월 22일 시행. 정보취약계층의 디지털 역량 교육, 교육 시설·전문인력, 역기능 대응 등을 규정하며, 장애유형별(발달장애 포함) 교육용 콘텐츠 개발과 보편적 학습설계 반영이 부속 과제로 언급된다(국회입법조사처, 2025; 법령 자료).
- **발달장애인법 제10조(의사소통지원).** 국가·지자체는 정책정보를 발달장애인이 이해하기 쉬운 형태로 작성·배포할 의무가 있고, 교육부장관은 의사소통도구 개발·전문인력 양성 의무를 진다(발달장애인 권리보장 및 지원에 관한 법률, 현행). '쉬운 정보(easy read)' 제작 기반이 법에 이미 존재한다는 뜻이다.
- **무인정보단말기(키오스크) 접근성.** 장애인차별금지법·지능정보화기본법 체계에서 2026년 1월 28일까지 공공·민간 키오스크의 정당한 편의 제공이 의무화되며, 검증 기준 10원칙에 '인지능력 보완'이 포함돼 있다(보건복지부 보도자료, 2025). 다만 2025년 11월 시행령 개정으로 소상공인 등에 완화된 이행 경로가 열려 장애계의 "권리 후퇴" 비판이 있다(에이블뉴스, 2025).
- **실태 데이터.** 2024년 디지털정보격차 실태조사에서 장애인의 디지털정보화 수준은 일반국민 대비 83.5%였고, 이 조사에 처음으로 AI 서비스 관련 부록 문항이 포함됐다(과기정통부·NIA, 2025 발표). 단, 이 수치는 장애인 전체 통계이며 **발달장애인(지적·자폐성) 별도 수치는 검색 범위 내에서 확인되지 않음**.
- **평생교육.** 국립특수교육원이 국가장애인평생교육진흥센터를 통해 발달장애인 평생교육과정을 운영한다. 2021년 조사 기준 장애인 평생교육에서 기초문자해득 교육 비중은 9.4%로 문화예술(39.8%), 직업능력(21.7%)에 비해 낮았다(국립특수교육원 조사; 특수교육 학술지 재인용).
- **국내 연구 동향.** 성인 발달장애인 대상 AI 기반 보완대체의사소통(AAC) 요구 분석 등 개별 연구는 존재한다(특수교육, 2025, KCI ART003177671).

**공백 분석.** 위 확인 사항을 종합하면 공백은 네 층위다.

1. **'감각 접근성' 편중.** AIDT의 접근성 기능(화면해설·자막)이나 키오스크 기준의 무게중심은 시각·청각·지체에 있다. 인지 접근성은 키오스크 10원칙에 한 항목으로 존재할 뿐, 쉬운 언어 인터페이스·단순화 모드 같은 구체 기준으로 성숙하지 못했다. 이는 2-3에서 본 국제 표준(WCAG)의 인지 영역 미성숙이 국내 제도에 그대로 이식된 구조다.
2. **발달장애인 특정 AI 리터러시·안전 교육의 부재.** 디지털포용법과 디지털역량교육 사업은 '정보취약계층 일반'을 다루며, 발달장애인의 인지 특성에 맞춘 생성형 AI 리터러시(AI 출력 검증, 과의존·기만 대응) 교육 정책은 **검색 범위 내에서 확인되지 않았다**.
3. **데이터 공백.** 발달장애인의 AI 이용 실태를 분리 측정한 국가 통계는 검색 범위 내에서 확인되지 않았다. 측정되지 않는 집단은 정책 우선순위에서 밀린다 — 2-2가 지적한 '알고리즘적 비가시성'의 행정 버전이다.
4. **당사자 참여 구조의 부재.** 발달장애인법의 쉬운 정보 의무는 '제공' 의무이지 '공동설계' 의무가 아니다. AIDT 개발·검정 과정에 발달장애 당사자가 참여했다는 근거는 검색 범위 내에서 확인되지 않았다. Babu & Joseph의 5대 최소기준(조달 감사, 데이터 포함, 공동설계, 거버넌스 대표성)에 비추면, 한국 제도는 대체로 첫 번째(사후적 편의 제공) 언저리에 있다.

---

## 예상하지 못했던 발견과 새로운 관점 {#findings}

**(1) "AI는 접근성 기술"이라는 통념의 역전.** 리서치 전에는 생성형 AI가 인지장애에 특히 유용한 기술이라는 담론을 검증하는 그림을 예상했다. 실제로 드러난 것은 이중 구조다: AI는 인지 접근성의 잠재적 해법이면서, 동시에 감사 연구(Dash et al., 2025)가 보여주듯 현존 LLM이 가장 소홀한 영역이 바로 발달·인지 범주다. '접근성을 위한 AI'와 'AI 자체의 접근성'은 별개의 문제이며, 후자가 방치된 채 전자만 홍보되고 있다.

**(2) 보호 담론과 당사자 경험의 정면충돌.** 윤리 문헌은 과의존·의인화·자동화 편향을 경고한다. 그런데 신경다양성 당사자 문헌(Moore, 2025 — ADHD 사례임을 재차 명시)은 정반대 방향을 보고한다: AI의 '판단 없는' 지원이 인간 지원보다 자율성을 덜 침해했고, 오히려 인간이 만든 제도 시스템이 완벽한 실행기능을 전제해 배제를 생산했다. 위험의 원천이 AI인가 제도인가에 대한 이 긴장은 현재 어느 쪽으로도 실증적으로 정리되지 않았다. "지적장애인을 AI로부터 보호해야 한다"는 직관과 "지적장애인은 이미 인간 시스템에 의해 배제되고 있다"는 관찰을 동시에 쥐고 있어야 한다.

**(3) 검증 주체의 전도라는 구조적 문제.** 지적장애인을 위한 텍스트 단순화 기술조차 그 품질 평가를 전문가와 크라우드워커가 대행해 왔다는 지적(Säuberli et al., 2024)은 개별 연구의 흠이 아니라 분야의 구조를 보여준다. '당사자를 위한 기술'의 성공 기준을 당사자가 정의하지 않는 한, 잘 만든 배제가 반복된다. 이는 윤리 원칙의 문제라기보다 연구 방법론 인프라(인지적으로 접근 가능한 평가 도구, 동의 절차, 보상 체계)의 문제이며, Wu 등의 이해도 4중 측정 같은 방법론적 혁신이 원칙 선언보다 실질적 기여일 수 있다.

**(4) 증거의 '범주 미끄러짐(category slippage)'.** 학습장애(LD) 대상의 비교적 탄탄한 실증(11개 실험, 3,033명)과 지적장애(ID) 대상의 얇은 실증(소표본 비통제 연구 몇 건)이 정책·산업 담론에서 "장애학생에게 AI가 효과적"이라는 하나의 문장으로 합쳐지는 경향이 확인됐다. 이 미끄러짐은 지적장애 대상 연구 투자의 필요성을 가리는 효과를 낸다. 지적장애 분야는 '효과가 있다'가 아니라 '아직 제대로 검증되지 않았다'가 정직한 요약이다.

**(5) 서사(narrative)가 인지 접근성의 공통 열쇠로 반복 등장.** 서로 독립적인 연구 갈래들 — 데이터 시각화 공동설계의 "숫자를 서사로"(Wu et al., 2024), Easy Read의 언어 단순화, 자기옹호의 스토리텔링 전통 — 이 모두 같은 지점을 가리킨다: 지적장애인의 인지 접근성에서 결정적인 것은 정보량 축소가 아니라 **추상을 경험에 정박시키는 서사적 변환**이다. 이는 '쉽게 = 짧게·단순하게'라는 통념보다 훨씬 풍부한 설계 원리이며, 생성형 AI가 실제로 잘하는 일(형식 변환, 서사화)과 맞닿아 있다는 점에서 실용적 함의가 크다.

---

## 날자꾸러미(날꾸) 관점과의 교차점 {#nalkku-view}

날꾸가 서 있는 자리 — 유추사고력 기반 문해력 프로그램, 성장주체로서의 학습자, AI를 개별화 지원 도구로 보는 관점 — 를 이번 리서치에 겹쳐 보면, 가장 크게 공명하는 지점은 위 4-(5)의 발견이다. 유추는 낯선 추상을 익숙한 경험에 정박시키는 인지 조작이고, 국제 문헌이 수렴하는 "숫자를 서사로", "일상의 미감으로" 원리와 사실상 같은 설계 철학이다. 날꾸의 유추 중심 접근은 국내 프로그램의 독자 노선이 아니라, 인지 접근성 연구의 최전선과 독립적으로 같은 결론에 도달한 사례로 읽을 수 있다.

'성장주체로서의 학습자'라는 날꾸의 학습자관도 SDT 기반 설계 문헌(2-1) 및 자기옹호 데이터 연구(2-5)와 정렬된다. 특히 자기결정 기술이 학업을 넘어 고용·지역사회 성과를 예측한다는 축적된 증거는, 문해력 프로그램이 '기능 훈련'이 아니라 '주체 형성'을 겨냥하는 것의 정당화 근거가 된다.

어긋나는 — 정확히는 날꾸에 긴장을 거는 — 지점은 두 가지다. 첫째, 국제 담론의 무게중심은 '학습자 개인의 향상'에서 '환경과 시스템의 재설계'(인지정의, 조달 감사, 거버넌스)로 이동하고 있다. AI를 개별화 지원 도구로 보는 관점은 이 흐름에서 보면 절반이다 — 개인을 아무리 지원해도 키오스크·행정·플랫폼이 신경전형적 전제로 설계되면 격차는 남는다. 날꾸의 프로그램 층위와 별개로, 이 리서치의 결론은 개인 지원 담론만으로는 불충분하다는 쪽이다.

둘째, 근거 수준의 문제. AI 개별화 학습이 지적장애 학생에게 효과적이라는 실증은 아직 소표본·단기·비통제 연구 수준이다(2-6). 날꾸가 AI를 도구로 통합할 때 "연구로 입증된 효과"를 전제하기보다, 스스로 통제된 평가를 설계해 증거를 생산하는 쪽이 문헌 상태에 부합한다. 마지막으로, 국제 문헌이 요구하는 당사자 공동설계의 수준(설계 테이블 참여, 평가 기준의 당사자 정의)은 통상적인 '학습자 피드백 수렴'보다 훨씬 높다는 점도 기록해 둔다. 이는 날꾸에 대한 비판이 아니라, 이 분야 전체에 걸린 기준선의 상향이다.

---

## 전체 참고문헌 {#references}

### 시드 자료
1. Umucu, E. et al. (2025). Artificial Intelligence and Health Equity for People with Disabilities: An Integrated Framework for Disability-Inclusive AI Design. *INQUIRY: The Journal of Health Care Organization, Provision, and Financing*. https://pmc.ncbi.nlm.nih.gov/articles/PMC12374087/
2. Babu, A. & Joseph, A. P. (2025). Repositioning intellectual disability in the ethics of digital mental health technologies. *Frontiers in Psychiatry*, 16:1691940. https://www.frontiersin.org/journals/psychiatry/articles/10.3389/fpsyt.2025.1691940/full
3. Guasch, D., Rodrigo, C., Francisco, V. & Hervás, R. (2025). Roadmap to inclusive Artificial Intelligence for persons with intellectual disability. *Journal of Accessibility and Design for All*. https://www.jacces.org/index.php/jacces/article/view/625
4. Moore, M. (2025). Executive Dysfunction by Design: A Cognitive Accessibility Analysis of AI Support vs. Healthcare Barriers. *Proceedings of ASSETS '25 (ACM SIGACCESS)*. https://dl.acm.org/doi/10.1145/3663547.3749831 ※ ADHD 당사자 경험 보고 — 지적장애 아님
5. Wu, K. et al. (2023). Empowering People with Intellectual and Developmental Disabilities through Cognitively Accessible Visualizations. *arXiv:2309.12194*. https://arxiv.org/pdf/2309.12194
6. Hong, H. & Kim, Y. (2024). Applying artificial intelligence in career education for students with intellectual disabilities: The effects on career self-efficacy and learning flow. *Education and Information Technologies*. https://link.springer.com/article/10.1007/s10639-024-12809-6
7. Alsolami, A. S. (2025). The effectiveness of using artificial intelligence in improving academic skills of school-aged students with mild intellectual disabilities in Saudi Arabia. *Research in Developmental Disabilities*, 156:104884. https://doi.org/10.1016/j.ridd.2024.104884
8. (2026). Bridging gaps with technology: A bibliometric review of inclusive education through educational technology. *Contemporary Educational Technology*. https://www.cedtech.net/download/bridging-gaps-with-technology-a-bibliometric-review-of-inclusive-education-through-educational-17980.pdf

### 보강 자료 — 국제
9. Dash, D., Bangera, Y., Bangera, M., Vadithya, G. & Panda, S. (2025). Who Gets Left Behind? Auditing Disability Inclusivity in Large Language Models. *arXiv:2509.00963*. https://arxiv.org/abs/2509.00963
10. Wu, K., Quadri, G. J., Wang, A. Z., Osei-Tutu, D. K., Petersen, E., Koushik, V. & Szafir, D. A. (2024). Our Stories, Our Data: Co-designing Visualizations with People with Intellectual and Developmental Disabilities. *arXiv:2408.16072*. https://arxiv.org/abs/2408.16072
11. Säuberli, A., Holzknecht, F., Haller, P., Deilen, S., Schiffl, L. F., Hansen-Schirra, S. & Ebling, S. (2024). Digital Comprehensibility Assessment of Simplified Texts among Persons with Intellectual Disabilities. *ACM CHI 2024*. https://dl.acm.org/doi/fullHtml/10.1145/3613904.3642570
12. Catala, A. (2020). Metaepistemic Injustice and Intellectual Disability: a Pluralist Account of Epistemic Agency. *Ethical Theory and Moral Practice*. https://link.springer.com/article/10.1007/s10677-020-10120-0
13. (2024). Exploring Large Language Models to generate Easy to Read content. *Frontiers in Computer Science*, 6:1394705. https://www.frontiersin.org/journals/computer-science/articles/10.3389/fcomp.2024.1394705/full
14. Xia, Q., Chiu, T. K. F. et al. (2022). A self-determination theory (SDT) design approach for inclusive and diverse artificial intelligence (AI) education. *Computers & Education*. https://dl.acm.org/doi/10.1016/j.compedu.2022.104582
15. Wehmeyer, M. L., Palmer, S. B., Williams-Diehm, K., Shogren, K. A., Davies, D. K. & Stock, S. (2011). Technology and Self-Determination in Transition Planning. *Journal of Special Education Technology*. https://journals.sagepub.com/doi/abs/10.1177/016264341102600103
16. Bulut, M. (2025). AI-Supported Learning Platforms for Students With Developmental Disabilities: A SWOT Analysis Approach. *Journal of Intellectual Disability Research*. https://onlinelibrary.wiley.com/doi/10.1111/jir.70108
17. (2025). The Effectiveness of Artificial Intelligence-Based Interventions for Students with Learning Disabilities: A Systematic Review. *Brain Sciences*, 15(8):806. https://doi.org/10.3390/brainsci15080806 ※ 학습장애(LD) 대상 — 지적장애 아님
18. Dumitru, C., Abdulsahib, G. M., Khalaf, O. I. & Bennour, A. (2026). Integrating artificial intelligence in supporting students with disabilities in higher education: An integrative review. *SAGE*. https://journals.sagepub.com/doi/10.1177/10554181251355428
19. (2025). Autoethnographic Insights from Neurodivergent GAI "Power Users". *ACM CHI 2025*. https://dl.acm.org/doi/10.1145/3706598.3713670
20. (2025). Reimagining digital mental health literacy from the Global South: a call for epistemic justice and innovation equity. *Frontiers in Psychiatry*, 16:1611988. https://www.frontiersin.org/journals/psychiatry/articles/10.3389/fpsyt.2025.1611988/full
21. (2025). 20 Years (2004–2024) Exploring Research Trend in Intellectual Disabilities towards Inclusion: A Bibliometric Study. *Journal of Education and Learning (EduLearn)*. https://eric.ed.gov/?id=EJ1478896

### 보강 자료 — 한국 정책
22. 교육부·대한민국 정책브리핑 (2024). 2025년 수학·영어·정보·국어(특수교육) 'AI 디지털교과서' 우선 도입. https://www.korea.kr/news/policyNewsView.do?newsId=148916075
23. 국회입법조사처 (2025). 『디지털포용법』 제정에 따른 전 국민 디지털 역량 강화 과제. https://www.nars.go.kr/report/view.do?cmsCode=CM0155&brdSeq=47195
24. 발달장애인 권리보장 및 지원에 관한 법률 제10조(의사소통지원). 국가법령정보센터. https://www.law.go.kr/LSW/lsInfoP.do?lsiSeq=195992
25. 보건복지부 (2025). 장벽 없는 키오스크, 합리적 제도개선으로 장애인 정보접근권 강화(보도자료). https://www.mohw.go.kr/board.es?mid=a10503000000&bid=0027&list_no=1487865&act=view
26. 에이블뉴스 (2025). "장애인 권리 후퇴" 반발에도, '합리적' 이유로 소상공인 키오스크 접근권 완화. https://www.ablenews.co.kr/news/articleView.html?idxno=225848
27. 과학기술정보통신부·한국지능정보사회진흥원 (2025). 2024 디지털정보격차 실태조사. https://www.index.go.kr/potal/main/EachDtlPageDetail.do?idx_cd=1367
28. 국립특수교육원. 국가장애인평생교육진흥사업 · 발달장애인 평생교육과정. https://www.nise.go.kr/sub/info.do?m=050608&s=nise&page=050608
29. (2025). 성인발달장애인 대상 AI 기반 보완대체의사소통 시스템 요구 분석. *특수교육* (이화여대 특수교육연구소, KCI). https://www.kci.go.kr/kciportal/ci/sereArticleSearch/ciSereArtiView.kci?sereArticleSearchBean.artiId=ART003177671
30. 한국장애인개발원 (2022). 디지털 시대 장애인 정보격차 해소를 위한 방안 마련 연구. https://www.koddi.or.kr/data/research01_view.jsp?brdNum=7415173

※ 일부 문헌(13, 17, 19, 20, 21, 8)은 저자명을 원문에서 직접 확인하지 못해 저널·연도·링크로 표기했다. 인용 시 원문에서 저자를 확인할 것을 권한다.

