class Hatnote < Liquid::Block
  def render(context)
    text = super

    if context['page']['layout'] == 'post_text'
      return text.strip.gsub(/\[(.*?)\]\((.*?)\)[,.;]?/, '\1: \2')
    end

    text = context.registers[:site].find_converter_instance(
      Jekyll::Converters::Markdown
    ).convert(text.to_s)
    return '<div class="hatnote">' + text + '</div>'
  end
end

Liquid::Template.register_tag('hatnote', Hatnote)
