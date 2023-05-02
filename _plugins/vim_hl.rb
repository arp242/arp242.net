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

Jekyll::Hooks.register :documents, :post_render do |post|
  # TODO: get absolute directory to Jekyll? And don't do this for every post.
  dir = '.vim-hl'
  FileUtils.mkdir_p dir

  default = post.data['filetype']
  post.output.gsub!(/<pre( class="(full )?ft-(\w+)")?><code>(.*?)<\/code><\/pre>/m) do |m|
    full = $2
    ft   = $3
    ft   = default if ft.nil? || ft == ''
    code = $4

    next m if ft.nil? || ft == '' || ft == 'NONE'

    begin
      name = post.id
    rescue
      name = 'pages-' + post.relative_path
    end
    cache = "./#{dir}/#{name.gsub(/\//, '')}-#{Digest::MD5.hexdigest(ft+code)}"
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
          +'let g:html_no_doc=1' \
          +'let g:html_no_links=1' \
          +'set rtp+=.vim' \
          +'set ft=#{ft}' \
          +'runtime syntax/2html.vim' \
          +'g/^\\(<!--\\|<\\/\\?pre\\(>\\| \\)\\)/d' \
          +wqa /tmp/vim-hl`
      FileUtils.mv('/tmp/vim-hl.html', cache)
    end

    next "<pre class='hl #{full} ft-#{ft}'><code>#{File.read cache}</code></pre>"
  end
end
