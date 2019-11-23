# Based on: https://github.com/GSI/jekyll_image_encode

module ImageEncodeCache
  @@cached_base64_codes = Hash.new

  def cached_base64_codes
    @@cached_base64_codes
  end

  def cached_base64_codes= val
    @@cached_base64_codes = val
  end
end

class Jekyll::Tags::ImageEncodeTag < Liquid::Tag
  include ImageEncodeCache

  def initialize(tag_name, path, options)
    @path = path.strip
    super
  end

  def render(context)
    require 'base64'

    encoded = File.open(@path) do |fp|
      unless self.cached_base64_codes.has_key? @path
        self.cached_base64_codes.merge!(@path => Base64.strict_encode64(fp.read))
      end
      next self.cached_base64_codes[@path]
    end

      type = case @path.split('.').last
               when 'png'
                 'image/png'
               when 'jpg', 'jpeg'
                 'image/jpeg'
               else
                 raise 'Unknown type'
               end

    return "data:#{type};base64,#{encoded}"
  end
end

Liquid::Template.register_tag('base64', Jekyll::Tags::ImageEncodeTag)
