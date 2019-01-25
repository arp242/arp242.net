class Jekyll::MarkdownHeader < Jekyll::Converters::Markdown
	def convert(content)
		super
			.gsub(/<h(\d) id="(.*?)">(.*?)<\/h\d>/, '<h\1 id="\2">\3 <a href="#\2"></a></h\1>')
			.gsub(/<div class="footnotes">/, '<div class="postscript"><strong>Footnotes</strong>')
			.gsub(/<a href="#fn:(\d+)" class="footnote">\d+<\/a>/, '<a href="#fn:\1" class="footnote">[\1]</a>')
	end
end
