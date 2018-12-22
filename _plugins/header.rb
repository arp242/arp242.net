class Jekyll::MarkdownHeader < Jekyll::Converters::Markdown
	def convert(content)
		super.gsub(/<h(\d) id="(.*?)">/, '<h\1 id="\2"><a href="#\2">§</a>')
	end
end
