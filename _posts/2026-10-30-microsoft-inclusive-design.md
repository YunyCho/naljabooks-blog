---
layout: post
lang: ko-KR
content_type: article
title: "사람이 제품에 맞춰야 할까요? Microsoft 포용 디자인이 던지는 질문"
description: "Microsoft 포용 디자인의 세 가지 원칙과 인지 다양성, Xbox Adaptive Controller와 Immersive Reader 사례를 살펴봅니다. 사람과 환경 사이의 장벽을 발견하고 접근성과 포용 디자인의 관계를 이해합니다."
date: 2026-10-30
updated: 2026-10-30
last_modified_at: 2026-10-30
author:
  name: "도서출판 날자 · 날자꾸러미 편집부"
  url: "https://naljabooks.com"
  type: Organization
category: "배움과 일상"
topics: [learning-rights, easy-information, developmental-learning]
tags: ["Microsoft 포용 디자인", "포용 디자인", "접근성", "인지 다양성", "인지 접근성", "당사자 참여"]
seo:
  primary_query: "Microsoft 포용 디자인"
  search_intent: "Microsoft 포용 디자인의 원칙과 사례, 접근성과의 차이를 이해하고 싶다."
  secondary_queries: ["포용 디자인이란", "포용 디자인과 접근성 차이", "Microsoft 인지 포용 디자인"]
related:
  - intellectual-disability-online-form-accessibility
  - why-self-advocate-review-must-start-at-planning
  - why-easy-text-alone-is-not-enough
toc:
  - { id: principles, title: "포용 디자인은 누구를 위한 디자인일까요?" }
  - { id: mismatch, title: "불편은 사람 안에만 있지 않습니다" }
  - { id: cognition, title: "생각하는 방식의 다양성도 설계의 출발점입니다" }
  - { id: examples, title: "실제 제품에서는 어떻게 나타날까요?" }
  - { id: accessibility, title: "포용 디자인과 접근성은 같은 말일까요?" }
  - { id: questions, title: "좋은 의도 다음에 필요한 질문" }
sources:
  - title: "Microsoft Inclusive Design 공식 홈페이지"
    organization: "Microsoft"
    year: "2026년 확인"
    url: "https://inclusive.microsoft.design/"
  - title: "Inclusive 101: 포용 디자인 입문"
    organization: "Microsoft"
    year: "2026년 확인"
    url: "https://inclusive.microsoft.design/articles/inclusive-101-guidebook"
  - title: "Inclusive Design for Cognition: 인지 포용 가이드"
    organization: "Microsoft"
    year: "2026년 확인"
    url: "https://inclusive.microsoft.design/articles/inclusive-design-for-cognition-guidebook"
  - title: "Creating for Guidance: 다양한 안내 방식"
    organization: "Microsoft"
    year: "2026년 확인"
    url: "https://inclusive.microsoft.design/articles/creating-for-guidance"
  - title: "Xbox Adaptive Controller 개발 소개"
    organization: "Xbox Wire · Microsoft"
    year: "2018"
    url: "https://news.xbox.com/en-us/2018/05/17/accessible-gaming-with-the-xbox-adaptive-controller/"
  - title: "AbleGamers의 개발 협력 기록"
    organization: "AbleGamers"
    year: "2026년 확인"
    url: "https://ablegamers.org/engineering-research-2/"
  - title: "Microsoft의 Immersive Reader 개발 기록"
    organization: "Microsoft"
    year: "2026년 확인"
    url: "https://news.microsoft.com/features/winning-hackathon-project-is-now-helping-millions-of-people-worldwide-to-read-and-write/"
  - title: "CAST: 보편적 학습설계 소개"
    organization: "CAST"
    year: "2026년 확인"
    url: "https://www.cast.org/resources/about-universal-design-for-learning/"
---

어떤 사람이 서비스를 이용하다가 중간에 멈췄습니다. 안내를 기억하지 못해 다음 단계로 넘어가지 못한 것입니다.

우리는 쉽게 “사용자가 설명을 기억하지 못했다”고 말합니다. 그런데 질문을 조금 바꿔 볼 수 있습니다.

“이 서비스는 왜 앞 화면의 설명을 기억해야만 사용할 수 있을까?”

두 질문은 같은 상황을 바라보지만, 해결책은 달라집니다. 첫 번째 질문이 사람의 어려움에 주목한다면, 두 번째 질문은 서비스가 만든 조건까지 살핍니다. 필요한 설명을 다시 보여 주거나, 같은 화면에서 확인할 수 있도록 바꾸는 방법이 떠오르기도 합니다.

이 가상의 장면은 Microsoft가 이야기하는 **포용 디자인(Inclusive Design)**의 관점을 이해하는 데 도움이 됩니다. 사람이 제품에 적응하지 못하는 이유를 개인에게만 묻지 않고, 제품이 처음부터 누구를 기준으로 만들어졌는지 되묻는 것입니다.

## 포용 디자인은 누구를 위한 디자인일까요? {#principles}

Microsoft는 포용 디자인을 인간의 다양한 능력과 경험을 활용하고, 그 다양성이 발휘되도록 하는 방법론으로 설명합니다.

이는 모든 사람에게 똑같은 물건을 주는 일과 다릅니다. 같은 경험에 참여하더라도 사람마다 필요한 경로와 지원이 다를 수 있기 때문입니다.

설계자가 자신의 감각, 몸, 언어, 경험을 ‘보통’이라고 생각하면 그 조건에 맞지 않는 사람은 문 앞에서부터 어려움을 겪을 수 있습니다. 잘 만들어진 디자인은 편리한 장식을 더하기 전에, 누가 그 문에 들어오지 못하고 있는지 살핍니다.

Microsoft가 소개하는 포용 디자인의 핵심은 세 가지입니다.

### 1. 배제를 알아차립니다

제품이 편리한지 묻기 전에, 누가 시작하지 못하는지, 어디에서 멈추는지, 무엇 때문에 다른 사람의 도움을 받아야 하는지 살핍니다.

이미 사용 중인 사람의 만족도만으로는 답을 다 찾을 수 없습니다. 시작하지 못한 사람은 이용 통계에 잘 드러나지 않을 수 있기 때문입니다.

### 2. 다양한 경험에서 배웁니다

누군가를 대신해 상상하는 것만으로는 부족합니다. 실제로 장벽을 겪는 사람의 이야기를 듣고, 그 사람이 일상에서 찾아낸 방법을 배워야 합니다.

Microsoft의 입문 자료는 안대를 쓰거나 귀를 막아 보는 짧은 체험만으로 장애 당사자의 경험을 이해했다고 생각하지 말라고도 이야기합니다. 당사자의 경험은 일시적인 체험보다 훨씬 풍부하고 복잡하기 때문입니다.

### 3. 한 사람의 필요에서 시작해 더 넓게 살핍니다

어떤 사람을 위해 만든 기능이 다른 사람에게도 도움이 되는 경우가 있습니다. 자막은 청각장애가 있는 사람의 접근에 중요하며, 소리가 잘 들리지 않는 환경에 있는 사람에게도 도움이 될 수 있습니다.

그렇다고 서로의 삶이 같다는 뜻은 아닙니다. 어떤 해결책이 다른 상황에도 통하는지는 직접 확인해야 합니다. 또한 더 많은 사람에게 이익이 된다는 이유가 없더라도, 한 사람이 참여할 수 있도록 장벽을 없애는 일 자체가 중요합니다.

## 불편은 사람 안에만 있지 않습니다 {#mismatch}

Microsoft는 사람과 환경 사이의 ‘맞지 않음’에 주목합니다.

예를 들어 한 손으로 조작하기 어려운 기기가 있다고 생각해 봅시다. 한 팔을 사용하는 사람, 팔을 다친 사람, 아기를 안고 있는 사람은 서로 매우 다른 삶을 살지만, 특정 순간에는 한 손 조작이라는 비슷한 필요를 가질 수 있습니다.

Microsoft는 이렇게 지속적·일시적·상황적 제약 사이의 관련성을 살피는 도구를 Persona Spectrum이라고 부릅니다.

여기서 주의할 점도 있습니다. 어떤 기능적 장벽이 비슷하다고 해서 장애를 겪는 삶의 사회적·경제적 부담이 같아지는 것은 아닙니다. 관련된 필요를 발견하되, 서로 다른 경험의 무게를 지우지 않아야 합니다.

## 생각하는 방식의 다양성도 설계의 출발점입니다 {#cognition}

포용 디자인은 보거나 듣고 움직이는 방식뿐 아니라 생각하고 배우고 기억하는 방식에도 관심을 둡니다.

Microsoft의 인지 가이드는 새로운 것을 배우는 일, 집중, 의사결정, 기억하기, 의사소통을 설계자가 살펴야 할 영역으로 제시합니다.

무엇보다 제품의 기능보다 사람의 목적에서 출발합니다. 이 사람은 무엇을 하고 싶을까요? 그 목표에 이르기 위해 어떤 단계를 거쳐야 할까요? 그 단계는 무엇을 기억하고, 얼마나 집중하고, 어떤 결정을 내리도록 요구할까요?

어떤 사람은 새로운 도구를 바로 눌러 보며 익힙니다. 다른 사람은 먼저 설명서를 보고 싶을 수 있습니다. 같은 사람도 익숙한 일에는 바로 도전하지만 중요한 일을 처음 할 때는 자세한 안내를 원할 수 있습니다.

따라서 좋은 안내는 모든 사람에게 같은 양의 도움을 강요하기보다, 필요할 때 찾고 자신에게 맞게 선택할 수 있어야 합니다. 이는 사람을 고정된 ‘학습 유형’으로 나누자는 이야기가 아닙니다.

## 실제 제품에서는 어떻게 나타날까요? {#examples}

Microsoft의 Xbox Adaptive Controller는 기존 게임 조작기를 사용하기 어려운 사람들의 참여를 넓히기 위해 개발된 장치입니다. Microsoft에 따르면 장애가 있는 플레이어와 여러 기관이 개발 과정에 참여했고, 외부 스위치와 입력장치를 연결해 개인에게 맞는 조작 구성을 만들 수 있도록 했습니다. 협력기관인 AbleGamers도 개발 협력을 소개합니다.

여기서 중요한 것은 버튼의 크기만이 아닙니다. 모두에게 같은 손의 움직임과 자세를 요구하는 대신, 조작 방식을 조합할 수 있도록 한 것입니다. 물론 추가 장비의 비용이나 설치, 게임 자체의 접근성은 별도로 살펴야 할 문제입니다.

또 다른 사례는 Immersive Reader입니다. Microsoft의 설명에 따르면 이 도구는 난독증을 고려한 프로젝트에서 출발해 읽어 주기, 글자 간격 조절, 줄 강조 등의 기능으로 발전했습니다. 같은 글을 읽더라도 접근하는 방식을 조절할 수 있게 한 것입니다. 다만 도구의 존재나 사용 경험만으로 모든 사람의 읽기 능력이 향상된다고 단정할 수는 없습니다.

## 포용 디자인과 접근성은 같은 말일까요? {#accessibility}

가깝지만 같은 말은 아닙니다.

Microsoft는 접근성을 다양한 사람이 경험에 접근하고 이용할 수 있도록 하는 품질이자 전문 분야로, 포용 디자인을 그러한 경험을 만들어 가는 방법으로 설명합니다.

당사자의 이야기를 듣고 함께 설계하는 과정은 중요합니다. 그러나 그 과정을 거쳤다는 이유만으로 모든 접근성 기준을 충족했다고 말할 수는 없습니다. 실제 사용성 시험과 구체적인 접근성 검토가 함께 필요합니다.

교육 분야에서 말하는 보편적 학습설계, 즉 UDL도 포용 디자인과 만나는 지점이 많습니다. 하지만 UDL은 학습을 위한 별도의 틀이며, Microsoft의 포용 디자인과 같은 이름으로 바꿔 쓸 수는 없습니다.

## 좋은 의도 다음에 필요한 질문 {#questions}

Microsoft의 자료를 읽으며 특히 눈에 들어온 점은, 포용을 완성된 상태가 아니라 계속해서 확인해야 하는 과정으로 본다는 것입니다.

하지만 ‘당사자와 함께했다’는 말만으로 충분할까요? 누가 참여했고, 의견이 실제로 무엇을 바꾸었는지, 참여에 필요한 지원과 보상이 있었는지 물어야 합니다.

한 사람에게 편안한 화면이 다른 사람에게는 불편할 수도 있습니다. 선택지가 많아져도 설정하기가 너무 어렵다면 또 다른 장벽이 생깁니다. 제품이 아무리 잘 만들어져도 가격이나 언어, 지원 인력 때문에 이용하지 못할 수도 있습니다.

그래서 포용을 이야기할 때는 “모두를 위한 디자인입니다”라는 선언보다 더 구체적인 질문이 필요합니다.

**누가 이 경험에 참여할 수 있게 되었을까요? 그리고 누가 아직도 어려움을 겪고 있을까요?**

Microsoft의 포용 디자인은 이 질문을 제품을 만드는 처음부터 끝까지 놓치지 않게 하는 하나의 방법입니다. 정답을 대신 알려 주기보다, 우리가 미처 보지 못했던 사람과 조건을 발견하도록 돕는다는 점에서 의미가 있습니다.

※ 이 글은 Microsoft의 공개 자료와 협력기관의 설명을 바탕으로 정리한 해설입니다. 제품 소개나 사용자 경험과 특정 효과의 과학적 입증은 구분해 읽어야 합니다.
