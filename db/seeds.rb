# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#!/usr/local/bin/ruby
# coding: utf-8

require 'open-uri'
require 'rss'

# open url list
fh = ["http://developer.hatenastaff.com/rss",
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
        rss = open(url){|file| RSS::Parser.parse(file.read)}
    rescue => ex
        puts ex.message
        next
    end
    puts "Site: " + rss.channel.title

    rss.items.each do |item|
        #puts "Title: " + item.title
        #puts item.date
        # get hatebu count
        begin
             count = open("http://api.b.st-hatena.com/entry.count?url=" + item.link).read
         rescue => ex
             puts ex.message
             next
         end
        # puts "Hatebu Count: " + count
        Infomation.create(siteName:rss.channel.title, siteURL:rss.channel.link, title:item.title, description:item.description, date:item.pubDate.inspect, url:item.link ,stocked:0,liked:0,hatebu:count)
    end
end
