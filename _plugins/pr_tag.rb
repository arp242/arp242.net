# Title: FreeBSD PR tag for Jekyll
# Author: Nicole Reid http://cooltrainer.org
# Description: Easily link to FreeBSD problem reports.
#
# Syntax {% pr [category/]prnumber ['link text'] ['title text'] %}
#
# Example:
# {% pr ports/151677 'the fix' 'Filename handling fix for cuetools.sh' %}
# {% pr ports/151677 %}
#
# Output:
# <a href='http://freshports.org/www/subsonic' title='Filename handling fix for cuetools.sh'>the fix</a>
# <a href='http://www.freebsd.org/cgi/query-pr.cgi?pr=ports/151677' title='Problem Report ports/151677'>ports/151677</a>
#

module Jekyll

  class PRTag < Liquid::Tag
    @pr = nil

    def initialize(tag_name, markup, tokens)
      if markup =~ /((\w+\/?)\d+)(\s+((?:"|')([^"']+)(?:"|')))?(\s+((?:"|')([^"']+)(?:"|')))?/i
        @pr = $1
        @link = $5
        @title = $8
        if !@link
		  @link = @pr
		end
		if !@title
		  @title = "Problem Report #{@pr}"
		end
      end
      super
    end

    def render(context)
      output = super
      if @pr
        pr =  "<a class='pr' href='http://www.freebsd.org/cgi/query-pr.cgi?pr=#{@pr}' title='#{@title}'>#{@link}</a>"
      else
        "Error processing input, expected syntax: {% pr [category/]prnumber ['link text'] ['title text'] %}"
      end
    end
  end
end

Liquid::Template.register_tag('pr', Jekyll::PRTag)

