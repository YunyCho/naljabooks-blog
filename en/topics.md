---
layout: default
lang: en
translation_key: topics
title: "Topics: learning, literacy, rights, analogy, and AI"
description: "Explore Nalja Archive's English articles by topic, including learning rights, literacy, analogy, intellectual disability, and AI."
permalink: /en/topics/
---
{% assign legacy_english_posts = site.posts | where: "lang", "en" %}
{% assign english_posts = site.english | concat: legacy_english_posts | sort: "date" | reverse %}

<header class="page-hero page-shell reading-shell">
  <p class="eyebrow">Topic guide</p>
  <h1>Learning, literacy, rights,<br>analogy, and AI</h1>
  <p>These topics connect research and educational practice with the everyday lives, choices, and participation of people with intellectual disabilities.</p>
</header>

<div class="prose page-shell reading-shell numbered-sections">
  {% for topic in site.data.topics %}
    <section id="{{ topic.id }}">
      <span>0{{ forloop.index }}</span>
      <h2>{{ topic.title_en }}</h2>
      <p>{{ topic.description_en }}</p>
      <ul class="article-link-list">
        {% for post in english_posts %}
          {% if post.topics contains topic.id %}
            <li>
              <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
              <span>{{ post.description }}</span>
            </li>
          {% endif %}
        {% endfor %}
      </ul>
    </section>
  {% endfor %}
</div>
