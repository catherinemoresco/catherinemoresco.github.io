---
layout: page
title: Blog
permalink: /blog/
---

<div class="home">

  <ul class="post-list">
    {% for post in site.posts %}
      <li>
        <span class="post-meta">{{ post.date | date: "%b %-d, %Y" }} &middot; {{ post.categories[0] |upcase}}</span>

        <a class="post-link" href="{{ post.url | prepend: site.baseurl }}">
          <h2>{{ post.title }}</h2>
          <h5>{{ post.subtitle }}</h5>
        </a>
<!-- For once I start using tag plugin:         {% for tag in post.tags %}
        <div class="pill">{{tag}} </div>
        {% endfor %} -->
      </li>
    {% endfor %}
  </ul>

  <p class="rss-subscribe">subscribe <a href="{{ "/feed.xml" | prepend: site.baseurl }}">via RSS</a></p>

</div>
