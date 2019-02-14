if (document.attachEvent ? document.readyState === 'complete' : document.readyState !== 'loading')
	load();
else
	document.addEventListener('DOMContentLoaded', load);

function load() {
	var toc = document.getElementById('toc'),
		btn = document.getElementById('toc-button');

	toc.className = 'toc-fixed toc-collapsed';
	readon.init({autoID: true});

	btn.addEventListener('click', function(e) {
		e.preventDefault();
		if (toc.className.indexOf('toc-collapsed') === -1) {
			btn.innerHTML = '»';
			toc.className = 'toc-fixed toc-collapsed';
		}
		else {
			btn.innerHTML = '«';
			toc.className = 'toc-fixed';
		}
	}, false);

	document.body.addEventListener('keydown', function(e) {
		if (e.keyCode !== 27) {
			return;
		}
		e.preventDefault();
		btn.click();
	}, false);

	// Get list of all headers.
	var headers = [];
	for (var i = 0; i<=1; i++) {
		var h = document.getElementsByTagName(['h3', 'h2'][i]);
		for (var j = 0; j < h.length; j++) {
			if (h[j].id !== '' ) {
				headers.push(h[j]);
			}
		}
	}
	// TODO: this is fairly slow.
	headers.sort(function(a, b) { return a.offsetTop > b.offsetTop; });

	var links = toc.getElementsByTagName('a'),
		active = null;

	var scroll = function(e) {
		// Don't run this too often.
		window.removeEventListener('scroll', scroll);
		setTimeout(function() {
			window.addEventListener('scroll', scroll, false)
		}, 100);

		for (var i=0; i<headers.length; i++) {
			if (headers[i].offsetTop >= window.scrollY) {
				for (var j=0; j<links.length; j++) {
					if (links[j].hash === '#' + headers[i].id) {
						if (active) {
							active.className = '';
						}
						active = links[j];
						links[j].className = 'active';
						break
					}
				}
				break;
			}
		}
	};
	window.addEventListener('scroll', scroll, false)
}
