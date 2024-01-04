class Aside < Liquid::Block
  def render(context)
    return '<aside>' +
      context.registers[:site].find_converter_instance(Jekyll::Converters::Markdown).convert(super.to_s) +
      '</aside>'
  end
end

class AsideNote < Liquid::Block
  def render(context)
    return '<aside class="note"><strong title="Note">🛈</strong>' +
      context.registers[:site].find_converter_instance(Jekyll::Converters::Markdown).convert(super.to_s) +
      '</aside>'
  end
end

class AsideWarning < Liquid::Block
  def render(context)
    return '<aside class="warn"><strong title="Warning">⚠</strong>' +
      context.registers[:site].find_converter_instance(Jekyll::Converters::Markdown).convert(super.to_s) +
      '</aside>'
  end
end

Liquid::Template.register_tag('aside', Aside)
Liquid::Template.register_tag('note', AsideNote)
Liquid::Template.register_tag('warning', AsideWarning)
