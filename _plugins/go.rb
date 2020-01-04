module Jekyll
  class GoPageGenerator < Generator
    safe true

    def generate(site)
      pkgs = %w{sconfig autofox goimport goimport/goimport hubhub info orgstat
        singlepage trackwall transip-dynamic uni gosodoff colorcount alwayscache
        cantuse border}
      pkgs.each do |p|
        site.pages << GoPage.new(site, site.source, p)
      end
    end
  end

  class GoPage < Page
    def initialize(site, base, p)
      @site = site
      @base = base
      @dir  = '/'
      @name = p + '.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'go.html')
      self.data['pkg'] = p
    end
  end
end
