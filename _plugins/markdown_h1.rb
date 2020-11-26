module MarkdownH1
  def markdown_h1 title
    title + "\n" + '=' * title.length
  end
end

Liquid::Template.register_filter(MarkdownH1)
