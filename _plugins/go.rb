module Jekyll
  class GoPageGenerator < Generator
    safe true

    def generate(site)
      pkgs = %w{goimport goimport/goimport gosodoff sconfig uni uni/v2}
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

      slash = p.index '/'
      self.data['pkg'] = "arp242.net/#{p}"
      self.data['git'] = "https://github.com/arp242/#{slash.nil? ? p : p[0..slash-1]}"
    end
  end
end
