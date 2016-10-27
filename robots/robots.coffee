###
Robots!
Copyright © 2012-2016 Martin Tournoij <martin@arp242.net>
See below for full copyright

http://arp242.net/robots/
###


# TODO Many of these should be user-definable settings
_boxsize = 14
_gridsizex = 59
_gridsizey = 22

# Various globals for convencience
_gridheight = _gridsizey * _boxsize
_gridwidth = _gridsizex * _boxsize
_grid = document.getElementById 'grid'
_gridcon = _grid.getContext '2d'
_playerpos = [0, 0]
_junk = []
_robots = []
_level = 0
_numrobots = 10
_maxlevels = 4
_waiting = false
_keybinds = null
_spritesize = 14
_dead = false

_sprite = null
_loaded = false

# Options
_hardcore = false
_autoteleport = false


###
Load options from localStorage or set defaults
###
LoadOptions = ->
	_hardcore = if localStorage.getItem('hardcore') is 'true' then true else false
	_autoteleport = if localStorage.getItem('autoteleport') is 'true' then true else false
	_graphics = localStorage.getItem 'graphics'
	_graphics = (parseInt(Math.random() * 3) + 1) + '' unless _graphics

	_sprite = new Image
	_loaded = false
	_sprite.onload = -> _loaded = true

	if _graphics is '1'
		_sprite.src = 'graphics/classic.png'
	else if _graphics is '2'
		_sprite.src = 'graphics/dalek.png'
	else if _graphics is '3'
		_sprite.src = 'graphics/cybermen.png'

	document.getElementById('graphics').selectedIndex = parseInt(_graphics, 10) - 1
	document.getElementById('autoteleport').checked = _autoteleport
	document.getElementById('hardcore').checked = _hardcore

	if localStorage.getItem('keybinds') is '1'
		document.getElementById('keybinds0').style.display = 'none'
		document.getElementById('keybinds1').style.display = 'block'
		document.getElementById('keyset').selectedIndex = 1

		_keybinds = [
			[121, -> MovePlayer ['up', 'left']], # y
			[107, -> MovePlayer ['up']], # k
			[117, -> MovePlayer ['up', 'right']], # u
			[104, -> MovePlayer ['left']], # h
			[108, -> MovePlayer ['right']], # l
			[98,  -> MovePlayer ['down', 'left']], # b
			[106, -> MovePlayer ['down']], # j
			[110, -> MovePlayer ['down', 'right']], # n

			[46, -> MovePlayer []], # .
			[119, ->  Wait()], # w
			[116, -> Teleport()], # t
		]
	else
		document.getElementById('keybinds0').style.display = 'block'
		document.getElementById('keybinds1').style.display = 'none'
		document.getElementById('keyset').selectedIndex = 0

		_keybinds = [
			[55, -> MovePlayer ['up', 'left']], # 7
			[56, -> MovePlayer ['up']], # 8
			[57, -> MovePlayer ['up', 'right']], # 9
			[52, -> MovePlayer ['left']], # 4
			[54, -> MovePlayer ['right']], # 6
			[49,  -> MovePlayer ['down', 'left']], # 1
			[50, -> MovePlayer ['down']], # 2
			[51, -> MovePlayer ['down', 'right']], # 3

			[53, -> MovePlayer []], # 5
			[119, -> Wait()], # w
			[116, -> Teleport()], # t
		]

###
Draw an empty grid aka playfield
###
DrawGrid = (bgcolor='#fff') ->
	_gridcon.fillStyle = bgcolor
	_gridcon.fillRect 0, 0, _gridwidth, _gridheight

###
Draw a bunch of robots at a random locations
###
InitRobots = ->
	for i in [1.._numrobots]
		while true
			x = GetRandomCoord 'x'
			y = GetRandomCoord 'y'

			if not RobotAtPosition(x, y) and (x isnt _playerpos[0] and y isnt _playerpos[1])
				break

		DrawRobot null, x, y
###
0: player
1: robot
2: junk
3: dead player
###
DrawSprite = (num, x, y) ->
	_gridcon.drawImage _sprite,
		_spritesize * num, 0,
		_spritesize, _spritesize,
		x * _boxsize, y * _boxsize,
		_boxsize, _boxsize

###
Draw a robot
###
DrawRobot = (num, x, y) ->
	# Robots has been destroyed
	return if _robots[num] is null

	# Add a new robot
	if num is null
		num = _robots.length
		_robots.push [x, y]
	# Move existing
	else
		#unless RobotAtPosition  _robots[num][0], _robots[num][1]
		ClearGrid _robots[num][0], _robots[num][1]

	DrawSprite 1, x, y
	_robots[num] = [x, y]

###
Two robots collided. BBBOOOOOMMM!!
###
DestroyRobots = (x, y) ->
	ClearGrid x, y
	DrawJunk x, y
	_junk.push [x, y]

	i = 0
	for r in _robots
		if r and r[0] is x and r[1] is y
			_robots[i] = null
			_numrobots -= 1
			UpdateScore()
		i += 1

DrawJunk = (x, y) ->
	DrawSprite 2, x, y

###
Move robots around
###
MoveRobots = ->
	i = 0
	for r, i in _robots
		if r is null
			continue

		x = r[0]
		y = r[1]

		if _playerpos[0] > x
			x += 1
		else if _playerpos[0] < x
			x -= 1

		if _playerpos[1] > y
			y += 1
		else if _playerpos[1] < y
			y -= 1

		if RobotAtPosition _playerpos[0], _playerpos[1]
			return Die()
		else if JunkAtPosition x, y
			ClearGrid _robots[i][0], _robots[i][1]
			_robots[i] = [x, y]
			DestroyRobots x, y
		else
			DrawRobot i, x, y

	# Check for collisions
	for r, i in _robots
		if r is null
			continue

		c = RobotAtPosition r[0], r[1], true
		if c isnt false and c isnt i
			DestroyRobots r[0], r[1]
	DrawAllSprites()

###
Draw our handsome protagonist
###
DrawPlayer = (x, y) ->
	ClearGrid _playerpos[0], _playerpos[1]
	DrawSprite 0, x, y
	_playerpos = [x, y]

###
Get random coordinates
TODO: How random is Math.random()?
###
GetRandomCoord = (axis) ->
	axis = if axis is 'x' then _gridsizex else _gridsizey

	parseInt(Math.random() * (axis - 1) + 1, 10)

###
Set position of player or robot inside the grid
###
SetPosition = (obj, x, y) ->
	obj.style.left = x + 'px'
	obj.style.top = y + 'px'

###
Deal with keyboard events
###
HandleKeyboard = (event) ->
	if event.ctrlKey or event.altKey
		return

	code = event.keyCode || event.charCode

	# Escape key
	return CloseAllWindows() if code is 27

	for [keyCode, action] in _keybinds
		if keyCode is code
			event.preventDefault()
			action()

###
Deal with mouse events
###
HandleMouse = (event) ->
	if event.target.id is 'options'
		ShowWindow 'options'
	else if event.target.id is 'help'
		ShowWindow 'help'
	else if event.target.id is 'about'
		ShowWindow 'about'
	else if event.target.className is 'close'
		CloseAllWindows()
	else if event.target.className is 'save'
		localStorage.setItem 'keybinds', document.getElementById('keyset').selectedIndex
		localStorage.setItem 'graphics', document.getElementById('graphics').selectedIndex + 1
		localStorage.setItem 'autoteleport', document.getElementById('autoteleport').checked
		localStorage.setItem 'hardcore', document.getElementById('hardcore').checked
		LoadOptions()
		CloseAllWindows()
		DrawGrid()

		wait_until_loaded = setInterval ->
			if _loaded
				clearInterval wait_until_loaded
				DrawAllSprites()
		, 100

###
Draw all the sprites
###
DrawAllSprites = ->
	DrawPlayer _playerpos[0], _playerpos[1]

	for r, i in _robots
		DrawRobot i, r[0], r[1] if r isnt null

	for j in _junk
		DrawJunk j[0], j[1]

###
Close all windows
###
CloseAllWindows = ->
	l = document.getElementById 'layover'
	l.parentNode.removeChild l if l
	for win in document.getElementsByClassName 'window'
		win.style.display = 'none'

###
Show a window
###
ShowWindow = (name) ->
	div = document.createElement 'div'
	div.id = 'layover'
	document.body.appendChild div

	document.getElementById(name + 'window').style.display = 'block'

###
Our bold player decided to wait ... Let's see if that decision was wise ... or fatal!
###
Wait = ->
	_waiting = true

	while true
		MoveRobots()

		return Die() if RobotAtPosition _playerpos[0], _playerpos[1]

		if _numrobots is 0
			NextLevel()
			break

	_waiting = false

###
Teleport to a new location ... or to death!
###
Teleport = ->
	x = GetRandomCoord 'x'
	y = GetRandomCoord 'y'

	return Die() if RobotAtPosition(x, y) or JunkAtPosition(x, y)

	DrawPlayer x, y
	MoveRobots()

### Move the player around
###
MovePlayer = (dir) ->
	x = _playerpos[0]
	y = _playerpos[1]

	if 'left' in dir
		x -= 1
	else if 'right' in dir
		x += 1

	if 'up' in dir
		y -= 1
	else if 'down' in dir
		y += 1

	return false if x < 0 or x > _gridsizex - 1
	return false if y < 0 or y > _gridsizey - 1

	dangerous = false
	for i in [-1..1]
		for j in [-1..1]
			continue if x + i < 0 or x + i > _gridsizex - 1
			continue if y + j < 0 or y + j > _gridsizey - 1
			dangerous = true if RobotAtPosition x + i, y + j

	if not _hardcore and dangerous
		if not MovePossible()
			Flash()
		return false

	return false if JunkAtPosition x, y
	DrawPlayer x, y
	MoveRobots()

	return NextLevel() if _numrobots <= 0

	if not _hardcore and not MovePossible()
		if  _autoteleport
			Teleport()
		else
			Flash()

###
Flash the game screen
###
Flash = ->
	DrawGrid '#333'
	DrawAllSprites()

	setTimeout ->
		DrawGrid '#fff'
		DrawAllSprites()
	, 100

###
Check if there is a possible move left
###
MovePossible = ->
	for x1 in [-1..1]
		for y1 in [-1..1]
			dangerous = false
			if _playerpos[0] + x1 < 0 or _playerpos[0] + x1 > _gridsizex - 1
				continue
			if _playerpos[1] + y1 < 0 or _playerpos[1] + y1 > _gridsizey - 1
				continue

			for x2 in [-1..1]
				for y2 in [-1..1]
					if RobotAtPosition _playerpos[0] + x1 + x2, _playerpos[1] + y1 + y2
						dangerous = true

			if not dangerous
				return true

	return false

###
Check of there if a robot at the position
###
RobotAtPosition = (x, y, retnum) ->
	for r, i in _robots
		if r and r[0] is x and r[1] is y
			return if retnum then i else true

	return false

###
Check if there is "junk" at this position
###
JunkAtPosition = (x, y) ->
	for j in _junk
		return true if j[0] is x and j[1] is y

	return false

###
Clear (blank) this grid positon
###
ClearGrid = (x, y) ->
	_gridcon.fillRect(
		x * _boxsize,
		y * _boxsize,
		_boxsize, _boxsize
	)

###
Oh noes! Our brave hero has died! :-(
###
Die = ->
	if _dead
		return
	_dead = true

	ClearGrid _playerpos[0], _playerpos[1]
	DrawSprite 3, _playerpos[0], _playerpos[1]

	curscore = parseInt document.getElementById('score').innerHTML, 10
	scores = localStorage.getItem 'scores'
	scores = JSON.parse scores
	if not scores
		scores = []

	d = new Date
	d = d.toLocaleDateString()
	scores.push [curscore, d, true]
	scores.sort (a, b) ->
		return -1 if a[0] > b[0]
		return 1 if a[0] < b[0]
		return 0

	scores = scores.slice 0, 5

	restart = document.createElement 'div'
	restart.id = 'restart'

	if _sprite.src.search('cybermen') isnt -1
		restart.innerHTML = 'Upgraded!'
	else if _sprite.src.search('dalek') isnt -1
		restart.innerHTML = 'Exerminated!'
	else
		restart.innerHTML = 'AARRrrgghhhh....'

	restart.innerHTML += '<br><br>' +
		'Your highscores:<br>'

	for s in scores
		restart.innerHTML += '<span class="row' + (if s[2] then ' cur' else '') + '">' +
			'<span class="score">' + s[0] + '</span>' + s[1] + '</span>'

	restart.innerHTML += '<br>Press any key to try again.'
	document.body.appendChild restart

	scores = scores.map (s) ->
		s[2] = false
		return s
	
	localStorage.setItem 'scores', JSON.stringify scores

	document.body.removeEventListener 'keypress', HandleKeyboard, false

	window.addEventListener 'keypress', ((e) ->
		if e.ctrlKey or e.altKey
			return

		e.preventDefault()
		window.location.reload()
	), false

###
Woohoo! A robot is no more, so lets update the score.
###
UpdateScore = ->
	score = parseInt(document.getElementById('score').innerHTML, 10)
	score += 10
	score += 1 if _waiting

	document.getElementById('score').innerHTML = score

###
Keep IE happy (also shorter to type!)
###
log = (msg) ->
	console.log msg if console and console.log

###
Advance to the next level
###
NextLevel = ->
	_level += 1
	_numrobots = 10 + _level * 10
	_waiting = false
	_junk = []

	DrawGrid()
	DrawPlayer GetRandomCoord('x'), GetRandomCoord('y')
	InitRobots()


###
TODO: Scrap this and detect features instead of browsers
###
CheckBrowser = ->
	old = false

	# Opera
	if window.opera
		if parseFloat(window.opera.version()) < 11.60
			old = true
	# Chrome
	else if window.chrome
		if parseInt(navigator.appVersion.match(/Chrome\/(\d+)/)[1], 10) < 18
			old = true
	# Safari
	else if navigator.vendor and navigator.vendor.match(/[aA]pple/)
		if parseFloat(navigator.appVersion.match(/Version\/(\d+\.\d+)/)[1]) < 5
			old = true
	# Firefox
	else if navigator.userAgent.match /Firefox\/\d+/
		if parseFloat(navigator.userAgent.match(/Firefox\/([\d\.]+)/)[1]) < 10
			old = true
	# IE
	else if  navigator.appName is 'Microsoft Internet Explorer'
		if parseInt(navigator.appVersion.match(/MSIE (\d+)/)[1], 10) < 9
			old = true

	if old
		div = document.createElement 'div'
		div.id = 'oldbrowser'
		div.innerHTML = 'Robots requires a fairly new browser with support for canvas, JSON, localStorage, etc.<br>' +
			'Almost all modern browsers support this, but a few may not (IE8, for example, does not).<br>' +
			'Tested versions are Opera 12, Firefox 14, Chrome 20, Internet Explorer 9'

		document.body.insertBefore div, _grid

###
Start the game!
###
InitGame = ->
	_numrobots = 10

	LoadOptions()

	# Why doesn't Javascript have sleep() ? :-(
	sleep = setInterval(->
		if _loaded
			clearInterval sleep
			InitGame2()
	, 100)

InitGame2 = ->
	DrawGrid()
	DrawPlayer GetRandomCoord('x'), GetRandomCoord('y')
	InitRobots()
	window.addEventListener 'keypress', HandleKeyboard, false
	window.addEventListener 'click', HandleMouse, false

CheckBrowser()
InitGame()


# The MIT License (MIT)
#
# Copyright © 2012-2016 Martin Tournoij
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# The software is provided "as is", without warranty of any kind, express or
# implied, including but not limited to the warranties of merchantability,
# fitness for a particular purpose and noninfringement. In no event shall the
# authors or copyright holders be liable for any claim, damages or other
# liability, whether in an action of contract, tort or otherwise, arising
# from, out of or in connection with the software or the use or other dealings
# in the software.
