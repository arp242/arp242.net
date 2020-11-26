{{ page.title | markdown_h1 }}
Written on {{ page.date | date_to_string }}{% if page.updated %} − last updated on {{ page.updated | date_to_string }} {% endif %}
HTML version: {{ site.url }}{{ page.url | replace: '.txt', '.html' }}
{% if page.hatnote %}{% hatnote %}{{ page.hatnote }}{% endhatnote %}{% endif %}

                                          <->

{% output_source %}
