---
title: "Anthology4Tech"
description: "Technical essays, notes, and explorations."
---
Welcome to Anthology4Tech — a curated collection of technical insights.

---
title: "Anthology4Tech"
layout: "home"
---

<section class="hero">
  <h1>Structured Insight for Modern Work</h1>
  <p>Sample articles, premium content, and subscriber-only releases.</p>
  <a class="cta" href="/subscribe">Unlock Full Access</a>
</section>

<section class="samples">
  <h2>Sample Articles</h2>
  <div class="sample-list">
    {{ range first 3 (where .Site.RegularPages "Section" "samples") }}
      <article>
        <h3><a href="{{ .RelPermalink }}">{{ .Title }}</a></h3>
        <p>{{ .Summary }}</p>
      </article>
    {{ end }}
  </div>
</section>

<section class="subscribe">
  <h2>Become a Subscriber</h2>
  <p>
    Gain access to full articles, archives, diagrams, frameworks, and upcoming drops.
  </p>
  <a class="cta" href="/subscribe">Subscribe via PayPal</a>
</section>

<section class="drops">
  <h2>Drop Calendar</h2>
  {{ range (where .Site.RegularPages "Section" "drops") }}
    <article>
      <h3>{{ .Title }}</h3>
      <p>{{ .Params.releaseDate }}</p>
      <a href="{{ .RelPermalink }}">View Details</a>
    </article>
  {{ end }}
</section>
