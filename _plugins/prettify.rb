module Jekyll::PrettifyFilter
	def prettify s
		s.tr '-', ' '
	end
end

Liquid::Template.register_filter(Jekyll::PrettifyFilter)
