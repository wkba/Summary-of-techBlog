desc "This task is called by the Heroku cron add-on"
task :call_page => :environment do
   require 'net/http'
   require 'open-uri'
   require 'rss'
    fh = ["http://developer.hatenastaff.com/rss",
      "http://techlife.cookpad.com/rss", 
      "http://blog.cybozu.io/rss",
      "http://labs.gree.jp/blog/rss",
      "http://alpha.mixi.co.jp/rss",
      "http://techlog.voyagegroup.com/rss",
      "http://techblog.yahoo.co.jp/index.xml",
      "http://ch.nicovideo.jp/dwango-engineer/blomaga/nico/feed",
      "http://rssblog.ameba.jp/ca-1pixel/rss20.xml",
      "http://tech.kayac.com/atom.xml",
      "https://tech.recruit-mp.co.jp/feed",
      "http://engineer.recruit-lifestyle.co.jp/archive/feed.xml",
      "https://tech.recruit-sumai.co.jp/feed",
      "http://tech.furyu.jp/blog/?feed=rss2",
      "http://tech.cygames.co.jp/feed",
      "http://blog.recruit-tech.co.jp/feed",
      "http://klabgames.tech.blog.jp.klab.com/atom.xml",
      "http://techblog.raccoon.ne.jp/atom.xml",
      "http://blog.livedoor.jp/techblog/atom.xml",
      "http://tech.camph.net/feed",
      "http://techblog.rakuten.co.jp/index.xml",
      "http://adtech.cyberagent.io/scalablog/feed",
      "http://blog.nanapi.co.jp/tech/feed"]

    i = 0
    # parse rss
    fh.each do |url|

        puts "URL: " + url
        begin
            rss = open(url){|file| RSS::Parser.parse(file.read)}
        rescue => ex
            puts ex.message
            next
        end
        puts "Site: " + rss.channel.title
        i = 0
        rss.items.each do |item|
            #puts "Title: " + item.title
            #puts item.date
            # get hatebu count
            i = i + 1
            begin
              count = open("http://api.b.st-hatena.com/entry.count?url=" + item.link).read
            rescue => ex
              puts ex.message
               next
            end
            # puts "Hatebu Count: " + count
            Infomation.create(siteName:rss.channel.title, siteURL:rss.channel.link, title:item.title, description:item.description, date:item.pubDate.inspect, url:item.link ,stocked:0,liked:0,hatebu:count)
            if i == 5 then
              break
            end
        end
    end
 end