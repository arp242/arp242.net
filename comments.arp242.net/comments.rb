#!/usr/bin/env ruby

require 'sqlite3'
require 'json'
require 'net/smtp'
require 'yaml'

require 'sinatra'

set :protection, :origin_whitelist => ['http://arp242.net', 'http://192.168.178.2:4000']

post '/new-comment' do
	content_type :json
	headers 'Access-Control-Allow-Origin' => 'http://arp242.net'

	if params[:turingtest] != '42'
		return { :success => false, :err => 'You failed the turing test' }.to_json
	end

	begin
		db = SQLite3::Database.new "comments.sqlite3"
		db.execute('insert into comments (entry, name, email, text) values (?, ?, ?, ?)',
			params[:id].split('/').pop, params[:name], params[:email], params[:text])
	rescue SQLite3::Exception
		return { :success => false, :err => 'Server error' }.to_json
	ensure
		db.close if db
	end

	begin
		Net::SMTP.start('localhost', 25) do |smtp|
			smtp.open_message_stream('martin@arp242.net', ['martin@arp242.net']) do |f|
				f.puts 'From: martin@arp242.net'
				f.puts 'To: martin@arp242.net'
				f.puts 'Subject: New comment at arp242.net'
				f.puts ''
				f.puts params.inspect
			end
		end
	rescue
		# Do nothing for now...
	end

	return { :success => true }.to_json
end


get '/:id' do
	content_type :json
	headers 'Access-Control-Allow-Origin' => 'http://arp242.net'

	begin
		db = SQLite3::Database.new "comments.sqlite3"
		db.results_as_hash = true
		comments = db.execute('select name, `text`, posted from comments where entry = ? order by posted asc',
			params[:id])
	rescue SQLite3::Exception
		return { :success => false, :err => 'Server error' }.to_json
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

	comments.each do |c|
		c['text'] = esc.call c['text']
		c['name'] = esc.call c['name']
		c['posted'] = c['posted'].split(' ')[0]
	end

	return { :success => true, :comments => comments }.to_json
end
