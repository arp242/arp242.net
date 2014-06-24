# Title: FreeBSD port tag for Jekyll
# Author: Nicole Reid http://cooltrainer.org
# Description: Easily link to Freshports for FreeBSD ports.
#
# Syntax {% port portname ['link text'] ['title text'] %}
#
# Example:
# {% port www/subsonic "A link to www/subsonic on Freshports" "Subsonic" %}
#
# Output:
# <a href='http://freshports.org/www/subsonic' title='A link to www/subsonic on Freshports'>Subsonic</a>
#

module Jekyll

  class PortTag < Liquid::Tag
    @port = nil
    @title = ''
    @link = ''

    def initialize(tag_name, markup, tokens)
      if markup =~ /(\S+(?:\/\S+)?)(\s+((?:"|')([^"']+)(?:"|')))?(\s+((?:"|')([^"']+)(?:"|')))?/i
        @port = $1
        @link = $4
        @title = $7
        if !@link
		  @link = @port
		end
		if !@title
		  @title = @link
		end
      end
      super
    end

    def render(context)
      output = super
      if @port
        port =  "<a class='port' href='http://freshports.org/#{@port}' title='#{@title}'>#{@link}</a>"
      else
        "Error processing input, expected syntax: {% port category/portname ['link text'] ['title text'] %}"
      end
    end
  end
end

Liquid::Template.register_tag('port', Jekyll::PortTag)
