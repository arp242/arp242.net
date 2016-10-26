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

by_class = (klass) -> (k for k in document.getElementsByClassName klass)
by_id = (id) -> document.getElementById id

filter = ->
	lang = get_hash_key 'filter-lang'
	status = get_hash_key 'filter-status'

	got_one = false
	by_class('weblog-brief').forEach (elem) ->
		show = true
		if lang isnt ''
			show = elem.className.indexOf("lang-#{lang} ") >= 0
		if status isnt ''
			show = show and elem.className.indexOf("status-#{status}") >= 0

		got_one = got_one or show
		elem.style.display = if show then 'block' else 'none'

	console.log got_one
	if got_one
		by_class('no-results').forEach (elem) -> elem.parentNode.removeChild elem
	else
		nr = document.createElement 'div'
		nr.className = 'weblog-brief no-results'
		nr.innerHTML = '<strong>No results with these filters.</strong>'
		by_class('weblog-overview')[0].appendChild nr

sort = ->
	h = get_hash_key 'sort'
	return if h is ''

	sorted = by_class 'weblog-brief'
	sorted.forEach (elem) -> elem.parentNode.removeChild elem
	sorted.sort (a, b) ->
		a.attributes["data-#{h}"].value.localeCompare b.attributes["data-#{h}"].value
	sorted.reverse() if h is 'updated'
	by_class('weblog-overview')[0].appendChild s for s in sorted

main = ->
	# TODO
	#by_class('weblog-article img').picture_zoomer()

	return unless by_class('code-projects').length
	filter()
	sort()

	by_id('code-filter-lang').addEventListener 'change', ->
		set_hash_key 'filter-lang', this.options[this.selectedIndex].value
	by_id('code-filter-status').addEventListener 'change', (e) ->
		set_hash_key 'filter-status', this.options[this.selectedIndex].value
	by_id('code-sort').addEventListener 'change', (e) ->
		set_hash_key 'sort', this.options[this.selectedIndex].value

	for opt in by_id('code-filter-lang').options
		hk = get_hash_key 'filter-lang'
		opt.selected = true if opt.value is hk
	for opt in by_id('code-filter-status').options
		hk = get_hash_key 'filter-status'
		opt.selected = true if opt.value is hk
	for opt in by_id('code-sort').options
		hk = get_hash_key 'sort'
		opt.selected = true if opt.value is hk

document.addEventListener 'DOMContentLoaded', -> main()

window.addEventListener 'hashchange', ->
	filter()
	sort()


# Simple "zooming lightbox" that doesn't suck.
#
# Basic usage:
#   $('.body img').picture_zoomer()
#
#   // Faster animation
#   $('.body img').picture_zoomer(200)
#
#   // Don't animate
#   $('.body img').picture_zoomer(0)
#
# The url for the large version is either 'data-large', or the image src

#jQuery.fn.picture_zoomer = (speed=400) ->
#  $(this).on 'click', (e) ->
#    e.preventDefault()
#    if $(this).is('img')
#      zoom $(this), speed
#    else
#      zoom $(this).find('img'), speed
#
#
#get_scroll = -> document.documentElement.scrollTop or document.body.scrollTop
#
#zoom = (img, speed) ->
#  large = $(new Image())
#  large.attr 'src', (img.attr('data-large') or img.attr('src'))
#  offset = img.offset()
#
#  large.on 'load', ->
#    width = large.prop 'width'
#    height = large.prop 'height'
#
#    # Don't make it larger than the window
#    w_width = $(window).width() - 25
#    w_height = $(window).height() - 25
#    if width > w_width
#      height = height / (width / w_width)
#      width = w_width
#    if height > w_height
#      width = width / (height / w_height)
#      height = w_height
#
#    large.css
#      width: img.width()
#      height: img.height()
#      left: offset.left
#      top: offset.top
#      position: 'absolute'
#      'box-shadow': '0 0 8px rgba(0, 0, 0, .3)'
#      'z-index': 5000
#    $(document.body).append large
#
#    large.animate {
#      width: width
#      height: height
#      left: ($(window).width() - width) / 2
#      top: ($(window).height() + $('#menu').height() - height) / 2 + get_scroll()
#    }, {
#      duration: speed
#    }
#
#    # Close
#    close = ->
#      large.animate {
#        width: img.width()
#        height: img.height()
#        left: offset.left
#        top: offset.top
#      }, {
#        duration: speed
#        complete: -> large.remove()
#      }
#    $(document.body).one 'click', close
#    $(document).on 'keydown.photo_viewer', (e) ->
#      return unless e.keyCode is 27 # Esc
#      close()
#      $(document).off 'keydown.photo_viewer'
