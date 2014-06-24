require 'sqlite3'

module Jekyll
	class RenderTimeTag < Liquid::Tag

		def render(context)
			begin
				db = SQLite3::Database.new "comments/comments.sqlite3"
				db.results_as_hash = true
				comments = db.execute('select name, `text`, posted from comments where entry = ? order by posted asc',
					context.registers[:page]['url'].sub(/^\/?weblog\/(.*)\.html$/, '\1'))
			rescue SQLite3::Exception => exc
				# Do nothing
				return ''
			ensure
				db.close if db
			end

			esc = lambda do |s|
				s
					.sub('&', '&amp;')
					.sub('>', '&lt;')
					.sub('<', '&gt;')
					.sub('"', '&quot;')
			end

			html = ''
			comments.each do |c|
				c['text'] = esc.call c['text']
				c['name'] = esc.call c['name']
				c['posted'] = c['posted'].split(' ')[0]

				html += "
					<h3>#{c['name']} had time to spare on #{c['posted']}, and wrote:</h3>
					<div>#{c['text']}</div>
				"
			end

			return html
		end
	end
end

Liquid::Template.register_tag('comments', Jekyll::RenderTimeTag)
