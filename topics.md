---
layout: default
translation_key: topics
title: "발달장애 학습과 성장: 지적장애인의 배움과 권리 안내"
description: "발달장애 학습, 발달장애 성장, 발달장애 문해력 교육과 발달장애 AI 교육을 지적장애인의 학습권·문해력·유추·쉬운 정보 글과 연결합니다."
permalink: /topics/
---

<header class="page-hero page-shell reading-shell">
  <p class="eyebrow">Topic Guide</p>
  <h1>발달장애 학습과 성장: 지적장애인의 배움과 권리 안내</h1>
  <p>날자 아카이브는 발달장애 학습과 성장이라는 넓은 질문에서 출발해 지적장애인의 학습권, 문해력, 유추 학습, AI 시대의 권리와 쉬운 정보 문제를 연결해 설명합니다.</p>
</header>

<div class="prose page-shell reading-shell numbered-sections">
  {% for topic in site.data.topics %}
    <section id="{{ topic.id }}">
      <span>0{{ forloop.index }}</span>
      <h2>{{ topic.title }}</h2>
      {% if topic.id == "developmental-learning" %}
        <p><a href="https://law.go.kr/LSW/lsLawLinkInfo.do?chrClsCd=010202&amp;lsJoLnkSeq=1000462159">법률상 발달장애</a>는 지적장애인과 자폐성장애인 등을 포괄하는 넓은 범주입니다. {{ topic.description }}</p>
      {% else %}
        <p>{{ topic.description }}</p>
      {% endif %}
      <ul class="article-link-list">
        {% for post in site.posts %}
          {% if post.topics contains topic.id %}
            <li>
              <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
              <span>{{ post.description }}</span>
            </li>
          {% endif %}
        {% endfor %}
        {% if topic.id == "easy-information" %}
          <li><a href="{{ '/methodology/' | relative_url }}">자료와 정정 원칙</a><span>출처와 제품 관점을 구분하는 기준</span></li>
        {% endif %}
      </ul>
      {% if topic.id == "nalkku-program" %}
        <p>도서출판 날자의 제품 구성과 구독 안내는 <a href="https://naljabooks.com">공식 웹사이트</a>에서 확인할 수 있습니다.</p>
      {% endif %}
    </section>
  {% endfor %}
</div>
