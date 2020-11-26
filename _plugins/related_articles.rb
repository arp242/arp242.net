class RelatedArticles < Liquid::Block
  def render(context)
    text = super

    if context['page']['layout'] == 'post_text'
      return "Related articles\n----------------" + text.gsub(/- \[(.*?)\]\((.*?)\)/, '\1: \2')
    end

    text = context.registers[:site].find_converter_instance(
      Jekyll::Converters::Markdown
    ).convert(text.to_s)
    return '<div class="postscript"><strong>Related articles</strong>' + text + '<div>'
  end
end

Liquid::Template.register_tag('related_articles', RelatedArticles)
