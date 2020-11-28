{{ page.title | markdown_h1 }}
Written on {{ page.date | date_to_string }}{% if page.updated %} − last updated on {{ page.updated | date_to_string }}
History: https://github.com/arp242/arp242.net/commits/master/{{ page.path }}{% endif %}
HTML version: {{ site.url }}{{ page.url | replace: '.txt', '.html' }}
{%- if page.hatnote %}
{% hatnote %}{{ page.hatnote }}{% endhatnote %}{% endif %}

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

{% output_source %}

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Personal website of Martin Tournoij (“arp242”); I write about programming and
various other things that interest me. CV: https://www.arp242.net/cv/

This document is licensed under a cc-by 4.0 license:
http://creativecommons.org/licenses/by/4.0
