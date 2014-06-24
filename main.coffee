jQuery.fn.empty = -> jQuery.trim($(this).val()) is ''

jQuery.fn.highlight = ->
	return if this.hasClass 'js-highlight'

	elem = this
	elem.addClass 'js-highlight'
	orig = elem.css 'background-color'

	elem.animate {
		backgroundColor: '#00dc3e'
	}, {
		duration: 400,
		done: ->
			(->
				elem.animate {
					backgroundColor: orig
				}, {
					duration: 400
					done: -> elem.removeClass 'js-highlight'
				}
			).timeout 200
	}


get = (cb) ->
	jQuery.ajax
		url: "http://comments.arp242.net/#{window.location.pathname.split('/').pop().replace /\.html$/, ''}"
		type: 'get'
		dataType: 'json'
		error: (xhr, status, err) ->
			#alert "Sorry, there was an error: `#{err}'"
		success: (data) ->
			return unless data.success
			#return alert "Sorry, there was an error: `#{data.err}'" unless data.success

			$('.comments-list').html ''
			data.comments.forEach (c) ->
				$('.comments-list').append """
					<h3>#{c.name} had time to spare on #{c.posted}, and wrote:</h3>
					<div>#{c.text}</div>
				"""

			cb.call null if cb

$('.feedbackform form').on 'submit', (e) ->
	return alert 'IE8 and lower doesn\'t work. Sorry about that :-(' unless 'withCredentials' of new XMLHttpRequest

	e.preventDefault()

	return alert 'You must fill in your name' if $('#comment-name').empty()
	return alert 'You must write a comment' if $('#comment-text').empty()
	return alert 'You failed the Turing test (you didn\'t enter 42)' if jQuery.trim($('#turingtest').val()) isnt '42'

	jQuery.ajax
		url: $(this).attr 'action'
		type: $(this).attr 'method'
		data: $(this).serialize()
		dataType: 'json'
		error: (xhr, status, err) ->
		alert "Sorry, there was an error"
		success: (data) =>
			return alert "Sorry, there was an error: `#{data.err}'" unless data.success

			$(this).find('input, textarea').val ''
			get -> $('.comments-list div:last').highlight()


#get() if $('.weblog-comments').length > 0
