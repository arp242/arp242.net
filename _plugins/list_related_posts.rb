class Jekyll::Tags::ListRelatedPostsTag < Liquid::Tag
  def render(context)
    list = context['page']['tags'].map do |t|
      next '' if context['site']['tags'][t].length == 1

      next "<strong>Other #{t} posts</strong><ul class='posts'>" +
        context['site']['tags'][t].map do |p|
          next '' if p.id == context['page'].id
          "<li><span>#{self.fmt_date p.date}</span> <a href='#{p.url}'>#{p['title']}</a></li>"
        end.shuffle.join("\n") + '</ul>'
    end.join('')

    '<div class="page related-posts">' + list + '</div>' if list.length > 0
  end

  def fmt_date date
    fmt = date.strftime('%d %b %Y').strip
    fmt[0] = "\u00a0" if fmt[0] == '0'
    return fmt
  end
end

Liquid::Template.register_tag('list_related_posts', Jekyll::Tags::ListRelatedPostsTag)
