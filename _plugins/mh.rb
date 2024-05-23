$mh_all = []

# "mh", or "margin header". This puts the header in the margin.
#
# mh2, mh3, mh4 → header level 2, 3, 4.
#
# Add custom id with by ending with:
#
#   , id: id
class MarginHeader < Liquid::Tag
  def initialize(tag_name, text, options)
    m = text.match(/, id: ([a-z][a-z0-9_-]*) *?$/)
    if m
      id = m[1]
      text = text[..(-m[0].length - 1)]
    else
      id = text.strip.downcase.gsub(/[^a-zA-Z0-9]/, '-').gsub(/-+/, '-')
    end

    @h = case tag_name
           when 'mh2'; 2
           when 'mh3'; 3
           when 'mh4'; 4
           else raise 'Unknown tag'
         end
    @id = id
    @text = text.strip

    $mh_all += [[@h, @id, @text]]
    super
  end

  def render(context)
    text = context.registers[:site].find_converter_instance(Jekyll::Converters::Markdown)
      .convert(@text).strip
      .delete_prefix('<p>').delete_suffix('</p>').strip
    return "<h#{@h} class='margin-header'><a href='##{@id}' id='#{@id}'>#{text}</a></h#{@h}>"
  end
end

class MarginHeaderTOC < Liquid::Tag
  def initialize(tag_name, text, options)
    $mh_all = []
  end

  def render(context)
    prev = 0
    return $mh_all.map do |h|
      text = ''
      text += "#{"\t" * prev}<ol class='toc-#{h[0]}'>\n" if h[0] > prev
      text += "#{"\t" * (prev - 1)}</ol>\n"              if h[0] < prev
      prev = h[0]

      c = context.registers[:site].find_converter_instance(Jekyll::Converters::Markdown)
        .convert(h[2]).gsub(/<\/?p>/, '').strip.gsub(/<br( ?\/)?>/, ', ')
      next text + "#{"\t" * prev}<li><a href='##{h[1]}'>#{c}</a></li>"
    end.join("\n") + "\n</ol>"
  end
end

Liquid::Template.register_tag('mh2', MarginHeader)
Liquid::Template.register_tag('mh3', MarginHeader)
Liquid::Template.register_tag('mh4', MarginHeader)
Liquid::Template.register_tag('mh_toc', MarginHeaderTOC)
