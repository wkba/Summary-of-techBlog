require 'open-uri'
require 'nokogiri'
require 'Time'

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
  #p arr[n]

end

   return arr
 end

