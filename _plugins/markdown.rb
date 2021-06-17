class CustomMarkdown < Jekyll::Converters::Markdown
  # Add post_convert hook to modify HTML content before layout (#8368)
  def convert(content)
    super
      .gsub(/<h(\d) id="(.*?)">(.*?)<\/h\d>/, '<h\1 id="\2">\3 <a href="#\2"></a></h\1>')
      .gsub(/<div class="footnotes" role="doc-endnotes">/, '<div class="postscript" role="doc-endnotes"><strong>Footnotes</strong>')
      .gsub(/<a href="#fn:(.+?)" class="footnote" rel="footnote">(\d+)<\/a>/, '<a href="#fn:\1" class="footnote" rel="footnote">[\2]</a>')
      .gsub(/<t([dh]) style="text-align: (left|right|center)">/, '<t\1 class="\2">')
      .gsub(/<\/table>\n+<p>Table: (.*?)<\/p>/, '<caption>\1</caption></table>')
      .gsub(/<pre(.*?)>/, "<div class='pre-wrap'>\n<pre\\1>")
      .gsub(/<\/pre>/, "</pre>\n</div>")
  end
end
