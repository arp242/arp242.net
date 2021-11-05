---
title: "Running Go CLI programs in the browser with WASM"
date: 2020-02-05
tags: ['Go']
---

Turns out it's almost shockingly easy to run Go CLI programs in the browser with
WebAssembly (WASM); as an example I'll use my [uni][uni] program. Building is as
easy as:

    GOOS=js GOARCH=wasm go build -o wasm/main.wasm

The resulting binary is rather large (5.1M); TinyGo can be used to create
smaller builds, but it [doesn't support `os.Args` yet][os.args], so it won't
work here. After gzip compression it's only 1.3M, so that's manageable (and
still smaller than many "text-only" websites).

[uni]: https://github.com/arp242/uni
[os.args]: https://github.com/tinygo-org/tinygo/issues/541

We then need to load the `main.wasm` binary:

{:class="ft-html"}
    <html>
    <head>
        <meta charset="utf-8">
    </head>
    <body>
        <script src="wasm_exec.js"></script>
        <script>
            const go = new Go();
            WebAssembly.instantiateStreaming(fetch("main.wasm"), go.importObject).then((result) => {
                go.run(result.instance);
            });
        </script>
    </body>
    </html>

Copy the `wasm_exec.js` file from the Go source repo (`$(go env
GOROOT)/misc/wasm/wasm_exec.js`), or [GitHub][wasm_exec.js].

[wasm_exec.js]: https://github.com/golang/go/blob/master/misc/wasm/wasm_exec.js

You can't load the HTML file the local filesystem as the browser will refuse to
load the wasm file; you'll have to use a webserver which serves wasm files with
the correct MIME type, for example with Python:

{:class="ft-python"}
    #!/usr/bin/env python3
    import http.server
    h = http.server.SimpleHTTPRequestHandler
    h.extensions_map = {'': 'text/html', '.wasm': 'application/wasm', '.js': 'application/javascript'}
    http.server.HTTPServer(('127.0.0.1', 2000), h).serve_forever()

Going to http://localhost:2000 will fetch the file and run `uni`; the JS console
should display:

{:class="ft-NONE"}
    uni: no command given
    exit code 1

As if we typed `uni` on the CLI. To give it some arguments set `go.argv`:

{:class="ft-html"}
    <script>
            const go = new Go();
            WebAssembly.instantiateStreaming(fetch("main.wasm"), go.importObject).then((result) => {
                // Remember that argv[0] is the program name.
                go.argv = ['uni', '-q', 'identify', 'wasm'];
                go.run(result.instance);
            });
    </script>

Which will give the expected output in the console:

{:class="ft-NONE"}
    'w'  U+0077  119    77          &#x77;     LATIN SMALL LETTER W (Lowercase_Letter)
    'a'  U+0061  97     61          &#x61;     LATIN SMALL LETTER A (Lowercase_Letter)
    's'  U+0073  115    73          &#x73;     LATIN SMALL LETTER S (Lowercase_Letter)
    'm'  U+006D  109    6d          &#x6d;     LATIN SMALL LETTER M (Lowercase_Letter)

Now it's a simple matter of connecting an `input` element to `go.argv`; this
also fetches the `main.wasm` just once and re-runs it, instead of re-fetching it
every time:

{:class="ft-html"}
    <input id="input" style="font: 16px monospace">
    <script src="wasm_exec.js"></script>
    <script>
        fetch('main.wasm').then(response => response.arrayBuffer()).then(function(bin) {
                input.addEventListener('keydown', function(e) {
                    if (e.keyCode !== 13)  // Enter
                        return;

                    e.preventDefault();

                    const go = new Go();
                    go.argv = ['uni'].concat(this.value.split(' '));
                    this.value = '';
                    WebAssembly.instantiate(bin, go.importObject).then((result) => {
                        go.run(result.instance);
                    });
                });
            });
    </script>

Overwrite the `global.fs.writeSync` from `wasm_exec.js` to display the output in
the HTML page instead of the console:

{:class="ft-html"}
    <script>
        fetch('main.wasm').then(response => response.arrayBuffer()).then(function(bin) {
                input.addEventListener('keydown', function(e) {
                    if (e.keyCode !== 13)  // Enter
                        return;

                    e.preventDefault();

                    const go = new Go();
                    go.argv = ['uni'].concat(this.value.split(' '));
                    this.value = '';

                    // Write stdout to terminal.
                    let outputBuf = '';
                    const decoder = new TextDecoder("utf-8");
                    global.fs.writeSync = function(fd, buf) {
                        outputBuf += decoder.decode(buf);
                        const nl = outputBuf.lastIndexOf("\n");
                        if (nl != -1) {
                            window.output.innerText += outputBuf.substr(0, nl + 1);
                            window.scrollTo(0, document.body.scrollHeight);
                            outputBuf = outputBuf.substr(nl + 1);
                        }
                        return buf.length;
                    };

                    WebAssembly.instantiate(bin, go.importObject).then((result) => {
                        go.run(result.instance);
                    });
                });
            });
    </script>

And that's pretty much it; 30 lines of JavaScript to run CLI applications in the
browser :-) The only change I had to make to `uni` Go code was [adding a build
tag][btag].

[btag]: https://github.com/arp242/uni/commit/bfd9a565343bce6469c67ea2ae3accad597afcb4#diff-c5818bddd7e55bf1374be45465e95062

---

There are plenty of other things that can be improved: some better styling,
reading from stdin, keybinds, loading indicator, etc. The [full version][wasm]
does some of that. Take a look at [index.html][index.html] and
[term.js][term.js] in case you're interested. It could still be improved
further, but I thought this was "good enough" for a basic demo :-)

[wasm]: https://arp242.github.io/uni-wasm/
[index.html]: https://github.com/arp242/uni/blob/master/wasm/index.html
[term.js]: https://github.com/arp242/uni/blob/master/wasm/term.js

{% related_articles %}
- [WebAssembly on the Go wiki](https://github.com/golang/go/wiki/WebAssembly)
{% endrelated_articles %}
