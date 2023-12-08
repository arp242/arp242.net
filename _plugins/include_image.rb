require 'base64'

class IncludeImage < Liquid::Tag
  def initialize(tag_name, path, options)
    @path = path.strip
    super
  end

  def render(context)
    type = case @path.split('.').last
             when 'png';          'image/png'
             when 'jpg', 'jpeg';  'image/jpeg'
             when 'webp';         'image/webp'
             when 'svg';          'image/svg+xml'
             else                 raise 'Unknown type'
           end
    return "data:#{type};base64,#{File.open(@path) { Base64.strict_encode64(_1.read) }}"
  end
end
Liquid::Template.register_tag('include_image', IncludeImage)
