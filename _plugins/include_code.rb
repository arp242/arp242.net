require 'fileutils'

class Jekyll::Tags::IncludeCodeTag < Liquid::Tag
  def initialize(tag_name, path, tokens)
    # Allow path to be "quoted" with ` – mostly so using _foo won't break syntax
    # highlight in Vim (_ being underscore).
    @path = path.gsub(/(^[ `]+|[ `]+$)/, '')
    super
  end

  def render(context)
    return File.readlines(@path).map { |l| '    ' + l }.join('')
  end
end
Liquid::Template.register_tag('include_code', Jekyll::Tags::IncludeCodeTag)
