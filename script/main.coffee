get_hash_key = (key) ->
	for pair in location.hash.substr(1).split(',')
		continue unless '=' in pair
		[k, v] = pair.split '='
		return v if k is key
	return ''


set_hash_key = (key, value) ->
	new_hash = ''

	for pair in window.location.hash.substr(1).split(',')
		continue unless '=' in pair
		[k, v] = pair.split '='
		new_hash += "#{pair}," unless k is key

	new_hash += "#{key}=#{value}," unless value is ''

	window.location.hash = "#{new_hash}"



filter = ->
	h = get_hash_key 'filter'
	if h is ''
		$('.weblog-brief').css 'display', 'block'
	else
		$(".weblog-brief:not(.lang-#{h})").css 'display', 'none'
		$(".weblog-brief.lang-#{h}").css 'display', 'block'


sort = ->
	h = get_hash_key 'sort'
	return if h is ''
	sorted = $('.weblog-brief').remove().toArray()
	sorted.sort (a, b) -> $(a).attr("data-#{h}").localeCompare $(b).attr("data-#{h}")
	sorted.reverse() if h is 'updated'
	$('.weblog-overview').append sorted


$(document).ready ->
	filter()
	sort()

	$('#code-filter').on 'change', -> set_hash_key 'filter', $(this).find(':selected').attr 'value'
	$('#code-sort').on 'change', -> set_hash_key 'sort', $(this).find(':selected').attr 'value'

	$("#code-filter option[value=\"#{get_hash_key 'filter'}\"]").attr 'selected', 'selected'
	$("#code-sort option[value=\"#{get_hash_key 'sort'}\"]").attr 'selected', 'selected'


window.addEventListener 'hashchange', ->
	filter()
	sort()
