#!/usr/bin/env python

import base64
import os

from bs4 import BeautifulSoup

files = ['preface.html', 'pr01s01.html', 'pr01s02.html', 'pr01s03.html',
         'pr01s04.html', 'pr01s05.html', 'pr01s06.html', 'context.html',
         'philosophychapter.html', 'ch01s01.html', 'ch01s02.html',
         'ch01s03.html', 'ch01s04.html', 'ch01s05.html', 'ch01s06.html',
         'rule_of_optimization.html', 'ch01s07.html', 'ch01s08.html',
         'ch01s09.html', 'historychapter.html', 'ch02s01.html', 'genesis.html',
         'hackers.html', 'linux_reaction.html', 'ch02s03.html', 'ch02s04.html',
         'contrastchapter.html', 'ch03s01.html', 'ch03s02.html', 'vms.html',
         'mac_os_contrast.html', 'os_2.html', 'nt_contrast.html', 'beos.html',
         'mvs.html', 'linux.html', 'ch03s03.html', 'design.html',
         'modularitychapter.html', 'ch04s01.html', 'ch04s02.html',
         'compactness.html', 'orthogonality.html', 'spot_rule.html',
         'ch04s03.html', 'c_thin_glue.html', 'ch04s04.html',
         'gimp_plugins.html', 'unix_and_oo.html', 'ch04s06.html',
         'textualitychapter.html', 'ch05s01.html', 'png.html', 'ch05s02.html',
         'ch05s03.html', 'ch05s04.html', 'transparencychapter.html',
         'ch06s01.html', 'audacity.html', 'fetchmail_v.html', 'ch06s02.html',
         'zen_of_transparency.html', 'ch06s03.html',
         'multiprogramchapter.html', 'ch07s01.html', 'ch07s02.html',
         'plumbing.html', 'ch07s03.html', 'ch07s04.html',
         'minilanguageschapter.html', 'ch08s01.html', 'ch08s02.html',
         'regexps.html', 'fetchmailrc.html', 'awk.html',
         'emacs_lisp_study.html', 'javascript.html', 'ch08s03.html',
         'macroexpansion.html', 'generationchapter.html', 'ch09s01.html',
         'bayes_spam.html', 'fetchmailconf.html', 'ch09s02.html',
         'htmlgen.html', 'configurationchapter.html', 'ch10s01.html',
         'ch10s02.html', 'ch10s03.html', 'ch10s04.html', 'ch10s05.html',
         'ch10s06.html', 'fetchmail_environment.html', 'ch10s07.html',
         'interfacechapter.html', 'ch11s01.html', 'ch11s02.html',
         'ch11s03.html', 'ch11s04.html', 'ch11s05.html', 'ch11s06.html',
         'ch11s07.html', 'ch11s08.html', 'ch11s09.html',
         'optimizationchapter.html', 'ch12s01.html', 'ch12s02.html',
         'ch12s03.html', 'ch12s04.html', 'binary_caches.html',
         'complexitychapter.html', 'ch13s01.html', 'ch13s02.html',
         'vi_complexity.html', 'emacs_editing.html', 'ch13s03.html',
         'ch13s04.html', 'implementation.html', 'languageschapter.html',
         'ch14s01.html', 'why_not_c.html', 'ch14s03.html', 'ch14s04.html',
         'c_language.html', 'cc_language.html', 'sh.html', 'perl.html',
         'tcl.html', 'python_language.html', 'java.html',
         'emacs_lisp_language.html', 'ch14s05.html', 'ch14s06.html',
         'toolschapter.html', 'ch15s01.html', 'ch15s02.html',
         'vi_literacy.html', 'ch15s03.html', 'ch15s04.html', 'ch15s05.html',
         'ch15s06.html', 'ch15s07.html', 'ch15s08.html', 'reusechapter.html',
         'ch16s01.html', 'ch16s02.html', 'ch16s03.html', 'ch16s04.html',
         'ch16s05.html', 'ch16s06.html', 'ch16s07.html', 'community.html',
         'portabilitychapter.html', 'c_evolution.html', 'ch17s02.html',
         'ietf_process.html', 'ch17s04.html', 'ch17s05.html', 'ch17s06.html',
         'ch17s07.html', 'documentationchapter.html', 'ch18s01.html',
         'ch18s02.html', 'ch18s03.html', 'ch18s04.html', 'ch18s05.html',
         'db_toolchain.html', 'ch18s06.html', 'opensourcechapter.html',
         'ch19s01.html', 'ch19s02.html', 'patching.html', 'naming.html',
         'develpractice.html', 'distpractice.html', 'communication.html',
         'ch19s03.html', 'ch19s04.html', 'ch19s05.html', 'futurechapter.html',
         'ch20s01.html', 'plan9.html', 'ch20s03.html', 'ch20s04.html',
         'ch20s05.html', 'ch20s06.html', 'apa.html', 'apb.html', 'apc.html',
         'revhistory.html', 'unix_koans.html', 'introduction.html',
         'ten-thousand.html', 'script-kiddie.html', 'two_paths.html',
         'methodology-consultant.html', 'gui-programmer.html', 'zealot.html',
         'unix-nature.html', 'end-user.html']

alt = {
    'graphics/kiss.png': 'KISS: Keep It Simple Stupid',
}

for f in files:
    if not os.path.exists('taop.orig/' + f):
        continue

    print('<!-- FILE: {} -->'.format(f))

    doc = open('./taop.orig/' + f, 'rb').read().replace(b'\xa0', b' ')
    soup = BeautifulSoup(doc.decode('iso-8859-1'), 'html.parser')

    # Don't need navigation.
    soup.find(class_='navheader').extract()
    soup.find(class_='navfooter').extract()

    # Extract footnotes.
    footnotes = []
    notes = soup.find(class_='footnotes')
    if notes is not None:
        for fn in notes.extract().find_all(class_='footnote'):
            footnotes += [fn]

    # Useless sections.
    for s in ['part', 'sect1', 'sect2', 'sect3', 'sect4']:
        for sect in soup.find_all(class_=s):
            sect.unwrap()

    # Fix up the headers
    # - The four book dividers are h1, make this h2
    # - Chapters are h3, make this h4
    # - Sections in chapters are h4 and h5, make this h5 and h6.
    first = True
    for title in soup.find_all(class_='titlepage'):
        for h in [1, 2, 3, 4, 5]:
            header = title.find('h{}'.format(h))
            if header is None:
                continue

            if 'subtitle' in header.get('class'):
                header.unwrap()
                continue

            new = soup.new_tag('h{}'.format(h + 1))
            new['id'] = header.find('a').get('id')
            new.string = header.text

            # First header of the file should have ID of filename.
            if first and not f.endswith('chapter.html'):
                new['id'] = f.replace('.html', '')
                first = False
            title.replace_with(new)

    # Remove links without href.
    for a in soup.find_all('a'):
        if a.get('href') is None:
            a.unwrap()

    # Don't need to add double emphasis.
    for s in soup.find_all('span', class_='emphasis'):
        s.unwrap()

    # Transform blockquote tables.
    for tbl in soup.find_all('div', class_='blockquote'):
        quote = tbl.find('blockquote')
        if quote is None:
            quote = soup.new_tag('blockquote')
            for p in tbl.find_all('p'):
                quote.append(p)
        quote['class'] = None

        author = tbl.find(class_='author')
        if author is not None:
            author = author.extract()
            author['class'] = None
            author.string = '– ' + author.text
            quote.append(author)

        tbl.replace_with(quote)

    # Transform "epigraph"
    for epi in soup.find_all(class_='epigraph'):
        new = soup.new_tag('blockquote')
        new['class'] = 'epigraph'

        text = soup.new_tag('p')
        text.string = epi.find('p').text

        author = soup.new_tag('span')
        author.string = '– ' + \
            epi.find(class_='attribution').text.replace('--', '').strip()

        new.append(text)
        new.append(author)
        epi.replace_with(new)

    # Remove toc; we only need one.
    toc = soup.find(class_='toc')
    if toc is not None:
        toc.extract()

    # Don't need chapter div.
    for c in soup.find_all(class_='chapter'):
        c.unwrap()

    # Add alt tag to images, and inline them to create a standalone document.
    for img in soup.find_all('img'):
        if img.get('alt') is None:
            img['alt'] = alt.get(img['src'])
        img['src'] = 'data:image/png;base64,{}'.format(
            base64.b64encode(open('./taop.orig/' + img['src'], 'rb').read()))

    doc = soup.body.prettify()
    # tt -> code
    doc = doc.replace('<tt', '<code').replace('</tt>', '</code>')
    print(doc[7:-7])

    for f in footnotes:
        print(f.prettify().replace('<tt', '<code').replace('</tt>', '</code>'))
    print()
    print()
