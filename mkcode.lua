#!/usr/bin/env lua
--
-- Get info from BitBucket and generate code/*.html; unfortunatly the BitBucket
-- profile rather sucks these days (no descriptions ... ?!)
-- 
-- Why lua? Well, I wanted to learn lua...
-- 

local cjson = require('cjson')
local https = require('ssl.https')
local lfs = require('lfs')

local projects = {}
local skip = {}
--skip['download-gemist'] = ''

-- Fix the dates. I don't want small updates to a README to count
local fixed_dates = {}
fixed_dates['spamdb-curses'] = '2012-11-07T'
fixed_dates['Frederick'] = '2014-11-01T'
fixed_dates['robots'] =  '2012-09-02T'
fixed_dates['pkg_sanity'] = '2013-08-25T'


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
		-- Use last commit date, and not last update of settings
		local updated
		if fixed_dates[p['name']] then
			updated = fixed_dates[p['name']]
		else
			local resp = {}
			https.request{
				url=p['links']['commits']['href'],
				sink=ltn12.sink.table(resp),
				protocol="tlsv1"
			}
			updated = cjson.decode(table.concat(resp))['values'][1]['date']
		end

		-- Fetch README
		local resp = {}
		https.request{
			url=p['links']['html']['href'] .. '/raw/tip/README.markdown',
			sink=ltn12.sink.table(resp),
			protocol="tlsv1"
		}
		local readme = table.concat(resp)

		if not skip[p['name']] then
			table.insert(projects, {
				name=p['name'],
				description=p['description']:gsub("\r\n", "\n"),
				language=p['language'],
				link=string.gsub(p['links']['html']['href'], "(.*/)(.*)", "%2"),
				updated_on=updated,
				readme=readme,
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
			<h2><a href="/code/%s/">%s</a></h2>
			<p>%s</p>
		</div>]], p['language'], date, p['link'], p['name'], p['description'])

	-- Only show last 5 updates on front page
	if k == 5 then
		fp = io.open('_index-code.html', 'w')
		fp:write(html)
		fp:close()
	end

	lfs.mkdir('code/' .. p['link'])
	fp = io.open('code/' .. p['link'] .. '/index.markdown', 'w')
	fp:write('---\n')
	fp:write('layout: code\n')
	fp:write('title: ' .. p['name'] .. '\n')
	fp:write('link: ' .. p['link'] .. '\n')

	-- Special hack to insert more links
	if p['readme']:find('\n-----------------------------------------\n', nil, true) then
		head = p['readme']:match('.-\n%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-\n')
		links = ''
		for title, link in head:gmatch('%- %[(.-)%]%((http.-)%)') do
			links = links .. string.format('<li><a href="%s">%s</a></li>', link, title)
		end
		fp:write('extra_links: ' .. links .. '\n')

		p['readme'] = p['readme']:gsub('.-\n%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-\n', '', 1)
	end

	fp:write('---\n\n' .. p['readme'])
	fp:close()
end

fp = io.open('code/index.html', 'w')
fp:write([[---
layout: default
title: Code projects
---

<div class="weblog-overview code-projects">
<a href="/" class="index-back">&#8592; Back</a>
]] .. html .. '</div>')
fp:close()
