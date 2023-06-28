# Based on: https://github.com/GSI/jekyll_image_encode
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
             else                 raise 'Unknown type'
           end
    encoded = File.open(@path) { |fp| Base64.strict_encode64(fp.read) }
    return "data:#{type};base64,#{encoded}"
  end
end
Liquid::Template.register_tag('include_image', IncludeImage)
