class OutputSource < Liquid::Tag
  def render(context)
    return File.open(context['page']['path']) do |fp|
      d = fp.read
      d = $POSTMATCH if d =~ Jekyll::Document::YAML_FRONT_MATTER_REGEXP
      d = Liquid::Template.parse(d).render(context)

      # Remove kramdown hints: {:class="ft-html"}
      d = d.gsub(/\{:[a-z]+?="[a-zA-Z -]+"\}\n/, '')

      # Replace manual <pre> tags with intended blocks.
      d = d.gsub(/<pre.*?>\n(.*?)\n<\/pre>/m) do |m|
        $1.split("\n").map {|v| '    ' + v}.join("\n")
      end

      # Strip all remaining HTML.
      d = d.gsub(/<\/?[^>]*>/, '')

      # Render <hr> a bit nicer.
      d = d.gsub(/^---$/, '~'*50 + "\n" + '~'*50)

      # Render paragraphs on single line.
      # TODO: doesn't deal with hanging lists. Should look if we can parse as
      # markdown as output again, or something.
      # TODO: also doesn't deal well with footnotes.
      # lines = d.split("\n")
      # d = lines.each_with_index.map do |l, i|
      #   next l+"\n"         if l[..3] == '    ' || l[0] == '-'
      #   next "\n"           if l == ''
      #   next l.strip+"\n"   if lines[i+1].nil?
      #   next l.strip + ' '  if lines[i+1] != '' && lines[i+1][0] != '-'
      #   next l.strip + "\n"
      # end.join('')

      # TODO: replace internal .html links to .txt links
      # TODO: make a /index.txt too
      # TODO: smart quotes?
      # TODO: Jekyll removes the BOM from the layout https://github.com/jekyll/jekyll/issues/2853
      next d.strip
    end
  end
end

Liquid::Template.register_tag('output_source', OutputSource)
