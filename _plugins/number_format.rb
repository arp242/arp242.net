module Jekyll::NumberFormatFilter
  def number_format n
    n.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse
  end
end
Liquid::Template.register_filter(Jekyll::NumberFormatFilter)
