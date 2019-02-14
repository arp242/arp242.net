(function() {
	var alpha = 'abcdefghijklmnopqrstuvwxyz';
	var ids = [];
	var opts = {
		autoID: false,
		anchors: 'p[id], h1[id], h2[id], h3[id], h4[id], h5[id], h6[id]',
		textNotify: 'Loaded (approximate) position of last view.',
		textClose: 'close',
	};

	var init = function(o) {
		if (o !== null)
			for (var k in o)
				if (o.hasOwnProperty(k))
					opts[k] = o[k];

		var foundR, foundN = false;
		for (var i=0; i<document.styleSheets.length; ++i)
			for (var j=0; j<document.styleSheets[i].cssRules.length; ++j) {
				switch (document.styleSheets[i].cssRules[j].selectorText) {
					case '.readon-remembered': foundR = true;  break;
					case '.readon-notify':     foundN = true; break;
				}
				if (foundR && foundN)
					break;
			}

		if (!foundR)
			document.styleSheets[0].insertRule('.readon-remembered { background-color: yellow; }', 0);

		if (!foundN)
			document.styleSheets[0].insertRule('.readon-notify {' +
				'position: fixed;' +
				'bottom: 0px;' +
				'left: 0px;' +
				'right: 0px;' +
				'padding: 16px;' +
				'text-align: center;' +
				'background-color: #f7f7f7;' +
				'color: #252525;' +
				'border-bottom: 1px solid #b7b7b7;' +
				'box-shadow: 0px 0 3px rgba(0,0,0,.5);' +
			'}', 0);

		if (document.attachEvent ? document.readyState === 'complete' : document.readyState !== 'loading')
			ready();
		else
			document.addEventListener('DOMContentLoaded', ready, false);
	};

	var ready = function() {
		if (opts.autoID)
			generateIDs(
				typeof opts.autoID === 'string' ? opts.autoID : null,
				opts.anchors.replace(/\[id]/g, ''));

		ids = queryAll(opts.anchors);

		var remember = window.localStorage.getItem('readon');
		if (remember) {
			var r = document.getElementById(remember);
			if (!r)
				console.warn('readon: element with ID ‘' + remember + '’ not found')
			else
				loadRemember(r);
		}

		// Start listening after everything is fully positioned.
		var add = function() {
			window.addEventListener('scroll', scroll, false);
			window.addEventListener('resize', scroll, false);
		};
		if (document.readyState === 'complete')
			add();
		else
			window.addEventListener('load', add, false);
	};

	var loadRemember = function(remember) {
		var notify = document.createElement('div'),
			close = document.createElement('a');
		close.addEventListener('click', function(e) {
			e.preventDefault();
			document.body.removeChild(notify);
		}, false);

		notify.className = 'readon-notify';
		notify.innerHTML = opts.textNotify + ' ';

		close.href = '#';
		close.innerHTML = '<sup>[' + opts.textClose + ']</sup>';
		notify.appendChild(close);
		document.body.appendChild(notify);

		remember.className += ' ' + 'readon-remembered'
		console.log('readon.js: scroll to ‘#' + remember.id + '’ at offset ' + remember.offsetTop);
		window.scrollTo(0, remember.offsetTop);
	};

	// Add ids to every paragraph that doesn't have one yet.
	var generateIDs = function(scope, anchors) {
		var target = document.body;
		if (scope !== null)
			target = document.querySelector(scope);

		//var elems = target.getElementsByTagName('p');
		var elems = queryAll(anchors);
		for (var i=0; i<elems.length; i++) {
			if (elems[i].id !== '')
				continue;

			var id = 'a' + fnv1a(elems[i].innerHTML, 1);
			// Account for collisions; there are a few in book-length documents.
			if (window[id]) {
				var j = 0;
				while (window[id])
					id = alpha[++j] + id.substr(1);
			}

			elems[i].id = id;
		}
	};

	var scroll = function(e) {
		// Don't run this too often; only unbind scroll event, as resize event
		// is likely to change pixel positions even on small updates.
		window.removeEventListener('scroll', scroll);
		setTimeout(function() { window.addEventListener('scroll', scroll, false); }, 200);

		// TODO: we can probably optimize this a wee bit by not starting from 0
		// all the time?
		var found;
		for (var i=0; i<ids.length; i++)
			if (ids[i].offsetTop + ids[i].clientHeight >= window.scrollY) {
				found = ids[i];
				break;
			}
		if (found !== undefined)
			window.localStorage.setItem('readon', found.id);
	};

    // Get Array of HTMLElements from querySelectorAll().
    var queryAll = function (q) {
        var nodes = document.querySelectorAll(q),
			arr = [];

        arr.length = nodes.length;
        for (var i = 0; i < nodes.length; i++) {
            if (!(nodes[i] instanceof HTMLElement)) {
                arr.length--;
                continue;
            }
            arr[i] = nodes[i];
        }

        return arr;
    };

	// https://github.com/sindresorhus/fnv1a/blob/master/index.js
	var fnv1a = function(text) {
		var hash = 2166136261;
		for (var i=0; i < text.length; i++) {
			hash ^= text.charCodeAt(i);
			hash += (hash << 1) + (hash << 4) + (hash << 7) + (hash << 8) + (hash << 24);
		}
		return hash >>> 0;
	};

	// Export.
	window.readon = {init: init};
})();
