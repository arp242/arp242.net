module Jekyll::NumberFormatFilter
	# Use %e instead of %d (leading 0 looks ugly)
	def number_format n
		n.to_s.
			reverse.
			gsub(/...(?=.)/,'\&,').
			reverse 
	end
end

Liquid::Template.register_filter(Jekyll::NumberFormatFilter)
