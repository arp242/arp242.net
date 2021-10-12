module Jekyll
  class GoPageGenerator < Generator
    safe true

    def generate(site)
      pkgs = %w{
		acidtab alwayscache autofox border cantuse colorcount goimport
		goimport/goimport gosodoff har har/cmd/unhar hubhub info orgstat sconfig
		singlepage termtext trackwall transip-dynamic uni uni/v2

		blackmail errors follow gadget goatcounter goatcounter/v2 guru isbot
		json ps tz z18n zcache zcert zdb zhttp zli zlog zpack zprof zrun zsrv
		zstd zstripe ztpl zvalidate}
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
