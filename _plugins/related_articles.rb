class RelatedArticles < Liquid::Block
  def render(context)
    return '<div class="postscript"><strong>Related articles</strong>' +
      context.registers[:site].find_converter_instance(Jekyll::Converters::Markdown).convert(super.to_s) +
      '<div>'
  end
end

Liquid::Template.register_tag('related_articles', RelatedArticles)
