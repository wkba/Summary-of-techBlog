desc "This task is called by the Heroku cron add-on"

def Eureka
  target_url = 'https://developers.eure.jp'
  siteName=""
  siteURL =""
  title =[]
  description=[]
  date =[]
  url =[]
  count = 0
  charset = nil
  
  html = open(target_url) do |f|
    charset = f.charset
    f.read
  end

  doc = Nokogiri::HTML.parse(html, nil, charset)

  doc.xpath('//div[@class="mainLogo"]').each do |node|
    siteURL = node.css('a').attribute('href').text
    siteName = node.css('span').text
  end

  doc.xpath('//h2[@class="articleTitle"]').each do |node|
    title << node.css('a').text 
    url << node.css('a').attribute('href').text
    count = count + 1
    #p node.css('img').attribute('src').value
    # 記事のサムネイル画像
    #p node.css('a').attribute('href').value
    # p siteName + ":" + title +":"+ url
  end

  doc.xpath('//div[@class="articleText"]').each do |node|
    description << node.css('a').text
  end

  doc.xpath('//ul[@class="articleInfoList"]').each do |node|
    date << node.css('li').first.text
  end

  arr = Array.new(count){ Array.new(6) }
  count.times do |n|
    arr[n][0]=siteName
    arr[n][1]=siteURL
    arr[n][2]=title[n]
    arr[n][3]=description[n]
    arr[n][4]=Time.parse(date[n])
    arr[n][5]=url[n]
  end
  return arr
end

def Gunosy
  target_url = 'http://gunosy.github.io'
  siteName=""
  siteURL =""
  title =[]
  description=[]
  date =[]
  url =[]
  count = 0
  charset = nil
  
  html = open(target_url) do |f|
    charset = f.charset
    f.read
  end

  doc = Nokogiri::HTML.parse(html, nil, charset)

  doc.xpath('//h1[@class="title"]').each do |node|
    siteURL = node.css('a').attribute('href').text
    siteName = node.css('a').text
  end

  doc.xpath('//li').each do |node|
    count = count + 1
    title << node.css('a').text 
    url << node.css('a').attribute('href').text
    description << "test"
  end

  doc.xpath('//span[@class="date"]').each do |node|
    date << node.text
  end
  
  arr = Array.new(count){ Array.new(6) }
  count.times do |n|
    arr[n][0]=siteName
    arr[n][1]=siteURL
    arr[n][2]=title[n]
    arr[n][3]=description[n]
    arr[n][4]=Time.parse(date[n])
    arr[n][5]=url[n]
  end
  return arr
end

task :call_page => :environment do
  require 'net/http'
  require 'open-uri'
  require 'feed-normalizer'
  require 'nokogiri'
  require "date"

  eureka = Eureka()
  eureka.each do |item|
    Infomation.create(siteName:item[0], siteURL:item[1], title:item[2], description:item[3], date:item[4], url:item[5], stocked:0, liked:0, hatebu:0)
  end

  gunosy = Gunosy()
  gunosy.each do |item|
    p item
    Infomation.create(siteName:item[0], siteURL:item[1], title:item[2], description:item[3], date:item[4], url:item[5], stocked:0, liked:0, hatebu:0)
  end

  fh = [
    "http://blog.mwed.info/feed.xml",
    "http://engineer.wantedly.com/feed.xml",
    "http://klabgames.tech.blog.jp.klab.com/atom.xml",
    "http://techblog.raccoon.ne.jp/atom.xml",
    "http://blog.livedoor.jp/techblog/atom.xml",
    "http://engineer.recruit-lifestyle.co.jp/techblog/feed.xml",
    "http://blog.wantedly.com/rss",
    "https://tech.recruit-mp.co.jp/feed",
    "https://tech.recruit-sumai.co.jp/feed",
    "http://tech.furyu.jp/blog/?feed=rss2",
    "http://tech.cygames.co.jp/feed",
    "http://blog.recruit-tech.co.jp/feed",
    "http://tech.camph.net/feed",
    "http://techblog.rakuten.co.jp/index.xml",
    "http://adtech.cyberagent.io/scalablog/feed",
    "http://blog.nanapi.co.jp/tech/feed",
    "http://developer.hatenastaff.com/rss",
    "http://techlife.cookpad.com/rss", 
    "http://blog.cybozu.io/rss",
    "http://labs.gree.jp/blog/rss",
    "http://alpha.mixi.co.jp/rss",
    "http://techlog.voyagegroup.com/rss",
    "http://techblog.yahoo.co.jp/index.xml",
    "http://ch.nicovideo.jp/dwango-engineer/blomaga/nico/feed",
    "http://rssblog.ameba.jp/ca-1pixel/rss20.xml"]

  # parse rss
  fh.each do |url|
      puts "URL: " + url
      begin
          #rss = open(url){|file| RSS::Parser.parse(file.read)}
          rss = FeedNormalizer::FeedNormalizer.parse open(url)
      rescue => ex
          puts ex.message
          next
      end
      puts "Site: " + rss.title.force_encoding("utf-8")
      puts "url: " + rss.url.force_encoding("utf-8")
      n = 0
      rss.entries.each do |item|
        n = n + 1
          #puts "Title: " + item.title
          #puts item.date
          # get hatebu count
          begin
               count = open("http://api.b.st-hatena.com/entry.count?url=" + item.url).read
           rescue => ex
               puts ex.message
               next
           end
          puts "gets: " + n.to_s  
          Infomation.create(siteName:rss.title.force_encoding("utf-8"), siteURL:rss.url.force_encoding("utf-8"), title:item.title.force_encoding("utf-8"), description:item.description.to_s.force_encoding("utf-8"), date:item.last_updated, url:item.url.force_encoding("utf-8") ,stocked:0,liked:0,hatebu:count)
          if n == 2 then
            break
          end
      end
  end
end