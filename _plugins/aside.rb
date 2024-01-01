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

# For zshglob:
#
# {% index key %}
# {% index key text_to_display %}
class Index < Liquid::Tag
  def initialize(tag_name, index, options)
    index = index.strip.split ' '
    @index = index[0]
    @text = index[1..].join ' '
    @text = @index if @text == ''
    super
  end

  def render(context)
    text = context.registers[:site].find_converter_instance(Jekyll::Converters::Markdown)
      .convert(@text).strip
      .delete_prefix('<p>')
      .delete_suffix('</p>')
      .strip
    return "<aside><a href='##{@index}' id='#{@index}'>#{text}</a></aside>"
  end
end

Liquid::Template.register_tag('index', Index)
