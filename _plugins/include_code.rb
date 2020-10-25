class Jekyll::Tags::IncludeCodeTag < Liquid::Tag
  def initialize(tag_name, path, tokens)
    @path = path.strip
    super
  end

  def render(context)
    cache = "./.include-code/#{context['page']['id'].gsub(/\//, '')}_#{@path.gsub(/\//, '-')}"

    # Don't build anything on Netlify, as it doesn't have the file.
    return "NOT FOUND: #{cache}" if !File.file?(cache) and !ENV['NETLIFY'].nil?

    text = File.readlines(@path).map { |l| '    ' + l }.join('')
    File.write(cache, text)
    return text
  end
end

Liquid::Template.register_tag('include_code', Jekyll::Tags::IncludeCodeTag)
