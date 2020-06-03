# Apply some basic syntax highlight with ... Vim. Worst or best method? You tell
# me haha. I don't care much for Rouge and the end result for this looks much
# nicer, IMHO.
#
# Usage: set default in frontmatter:
#
#    ---
#    filetype: python
#    ---
#
# Add ft-filetype class to override default or to use highlighting if you don't
# have a default:
#
#   {:class="ft-ruby"}
#       foo = 'bar'
#       puts bar
#
# Use ft-NONE to override the default in frontmatter and disable it.
#
# The results are cached in .vim-hl, as it's comparatively slow.
#
# Note: this loads user vimrc on purpose, so we get plugins that add/change
# filetypes.

require 'digest'
require 'fileutils'

Jekyll::Hooks.register :posts, :post_render do |post|
  # TODO: get absolute directory to Jekyll? And don't do this for every post.
  FileUtils.mkdir_p './.vim-hl'

  default = post.data['filetype']
  post.output.gsub!(/<pre( class="ft-(\w+)")?><code>(.*?)<\/code><\/pre>/m) do |m|
    ft = $2
    ft = default if ft.nil? || ft == ''
    code = $3

    next m if ft.nil? || ft == ''
    next m if ft == 'NONE'
    next m if ft == 'cli'  # TODO: implement this.

    cache = "./.vim-hl/#{post.id.sub(/\//, '')}-#{Digest::MD5.hexdigest(ft+code)}"
    if not File.file?(cache)
      # Don't build anything on Netlify, as it doesn't have Vim.
      next m unless ENV['NETLIFY'].nil?

      puts "Writing #{cache} with ft=#{ft}"
      code = code.gsub(/&amp;/, '&').gsub(/&gt;/, '>').gsub(/&lt;/, '<')

      # TODO: use proper tmp file and cleanup.
      File.write('/tmp/vim-hl', code)

      # TODO: don't use shell.
      `\
        vim -E \
          +'let g:html_no_progress=1' \
          +'set ft=#{ft}' \
          +'runtime syntax/2html.vim' \
          +'g/^<pre id=/1,.d' \
          +'g/^<\\/pre>/.,$d' \
          +wqa /tmp/vim-hl`
      FileUtils.mv('/tmp/vim-hl.html', cache)
    end

    # TODO: add patch to make this an option so we don't need to do this.
    c = File.read(cache).gsub(/<a href=".*?">(.*?)<\/a>/, '\1')
    next "<pre class='hl ft-#{ft}'><code>#{c}</code></pre>"
  end

  # CLI output.
  # TODO: doesn't deal well with line continuations; should probably make a Vim
  # syntax file for this.
  # post.output.gsub!(/<pre class="hl-cli"><code>.*?<\/code><\/pre>/m) { |m|
  #   # Remove <pre><code> tags.
  #   m = m[26..-14]

  #   m.gsub!(/^[^\$#\n].+?$/, '<span class="output">\0</span>')
  #   m.gsub!(/^\$ .*/, '<span class="cmd">\0</span>')
  #   m.gsub!(/^# .*/, '<span class="Comment">\0</span>')

  #   next "<pre class='hl hl-cli'><code>#{m}</code></pre>"
  # }
end

