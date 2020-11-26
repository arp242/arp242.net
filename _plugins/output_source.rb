class OutputSource < Liquid::Tag
  def render(context)
    return File.open(context['page']['path']) do |fp|
      d = fp.read
      d = $POSTMATCH if d =~ Jekyll::Document::YAML_FRONT_MATTER_REGEXP
      d = Liquid::Template.parse(d).render(context)

      # Remove kramdown hints
      # {:class="ft-html"}
      d = d.gsub(/\{:[a-z]+?="[a-zA-Z-]+"\}\n/, '')

      # TODO: render <hr> a bit nicer
      # TODO: replace internal .html links to .txt links
      # TODO: make a /index.txt too
      # TODO: find/fix some more inline HTML
      next d
    end
  end
end

Liquid::Template.register_tag('output_source', OutputSource)
