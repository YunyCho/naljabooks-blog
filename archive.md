---
layout: default
title: "전체 글"
description: "날자 아카이브에 공개된 모든 글을 최신순으로 모아 봅니다."
---

<section class="page-hero page-shell">
  <p class="eyebrow">Archive</p>
  <h1>전체 글</h1>
  <p>날자 아카이브에 공개된 글을 최신순으로 모았습니다. 홈에는 최신 글만 간결하게 두고, 쌓인 글은 이곳에서 이어서 볼 수 있습니다.</p>
</section>

<section class="archive-list-section page-shell" aria-labelledby="archive-list-title">
  <h2 id="archive-list-title" class="sr-only">전체 글 목록</h2>
  <div class="archive-list">
    {% for post in site.posts %}
      <article class="archive-list-item">
        <div>
          <p class="story-category">{{ post.category }}</p>
          <h3><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h3>
          <p>{{ post.description }}</p>
        </div>
        <div class="archive-list-meta">
          <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%Y.%m.%d" }}</time>
          {% if post.pinned %}
            <span>고정 선언문</span>
          {% endif %}
        </div>
      </article>
    {% endfor %}
  </div>
</section>
