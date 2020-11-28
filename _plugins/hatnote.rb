class Hatnote < Liquid::Block
  def render(context)
    return '<div class="hatnote">' +
      context.registers[:site].find_converter_instance(Jekyll::Converters::Markdown).convert(super.to_s) +
      '</div>'
  end
end

Liquid::Template.register_tag('hatnote', Hatnote)
