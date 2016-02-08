#!/usr/bin/env lua

local cjson = require('cjson')
local https = require('ssl.https')

local projects = {}
local skip = {}
skip['download-gemist'] = ''

local url = "https://api.bitbucket.org/2.0/repositories/Carpetsmoker"
while true do
	local resp = {}
	https.request{
		url=url,
		sink=ltn12.sink.table(resp),
		protocol="tlsv1"
	}
	data = cjson.decode(table.concat(resp))

	for i, p in pairs(data['values']) do
		if not skip[p['name']] then
			table.insert(projects, {
				name=p['name'],
				description=p['description']:gsub("\r\n", "\n"),
				language=p['language'],
				link='http://code.arp242.net/' .. string.gsub(p['links']['html']['href'], "(.*/)(.*)", "%2"),
				updated_on=p['updated_on'],
			})
		end
	end

	if data['next'] then
		url = data['next']
	else
		break
	end
end

table.sort(projects, function(a, b) return a['updated_on'] > b['updated_on'] end)
html = ''
for k, p in pairs(projects) do
	local _, _, y, m, d = string.find(p['updated_on'], "(%d+)%-(%d+)%-(%d+)T")
	local date = os.date("%d %b %Y", os.time{year=y, month=m, day=d})

	html = html .. string.format([[
		<div class="weblog-brief lang-%s">
			<em>%s</em>
			<h2><a href="%s">%s</a></h2>
			<p>%s</p>
		</div>]], p['language'], date, p['link'], p['name'], p['description'])

	if k == 5 then
		fp = io.open('_index-code.html', 'w')
		fp:write(html)
		fp:close()
	end
end

fp = io.open('code/code.html', 'w')
fp:write([[
---
layout: default
title: Code projects
---

<div class="weblog-overview code-projects">
<a href="/" class="index-back">&#8592; Back</a>
]] .. html .. '</div>')
fp:close()
