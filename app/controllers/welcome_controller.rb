require 'open-uri'
require 'rss'

class WelcomeController < ApplicationController

  # before_action :authenticate_user! , only: [:addLike]
  PER = 10
  @status = "new"
  @status_ja = "新着順"
  def index
    # updateRSS
    ajax_action unless params[:ajax_handler].blank?


    if logged_in? then
      @user_id = session[:user_id]
    end

  	if params[:sort] == nil then
  		@status = "new"
  	else
  		@status = params[:sort]
  	end
  	@info = setInfo(@status)
    @statusJa= setStatus(@status)
  end

  def ajax_action
    
  end



  def hatebu
    @info = Infomation.page(params[:page]).per(PER).order(:hatebu).reverse_order
 
  end


  def add
  	if params[:sort] == nil then
  		@status = "new"
  	else
  		@status = params[:sort]
  	end
  	@info = setInfo(@status)
  	render 'index'
  end

  def addLike
    like =BlogInfo.create(user_id: params[:user_id], entry_id: params[:entry_id],like: "true",url: params[:url],title: params[:title],siteName: params[:siteName],date: params[:date]) 
    render :nothing => true
  end
  def anLike
    BlogInfo.delete_all(["user_id = ? and title = ? and like = ?",params[:user_id], params[:title], "true"]) 
    render :nothing => true
  end

  def addLater
    later =LaterBlog.create(user_id: params[:user_id], entry_id: params[:entry_id],later: "true",url: params[:url],title: params[:title],siteName: params[:siteName],date: params[:date]) 
    render :nothing => true
  end
  def anLater
    LaterBlog.delete_all(["user_id = ? and title = ? and later = ?",params[:user_id], params[:title], "true"]) 
    render :nothing => true
  end




  private

  def setInfo(status)
    if logged_in? then
      @user_id = session[:user_id]
      like_list_id =  BlogInfo.where("user_id = ? and like = ?",@user_id,"true")
      later_list_id =  LaterBlog.where("user_id = ? and later = ?",@user_id,"true")
      id_arr = []
      like_list_id.each do |n|
        id_arr << n.entry_id
      end
      later_list_id.each do |n|
        id_arr << n.entry_id
      end
    end
    info = Infomation.page(params[:page]).per(PER).order(:date).reverse_order
    if status== "new" then
      info = Infomation.page(params[:page]).per(PER).order(:date).reverse_order.where.not(id: id_arr)
    elsif status == "hatebu"
      info = Infomation.page(params[:page]).per(PER).order(:hatebu).reverse_order.where.not(id: id_arr)
    elsif status == "like"
      info = BlogInfo.page(params[:page]).per(PER).order(:date).reverse_order.where("user_id = ? and like = ?",@user_id,true)
    elsif status == "later"
      info = LaterBlog.page(params[:page]).per(PER).order(:date).reverse_order.where("user_id = ? and later= ?",@user_id,true)
    end
    return info
  end

  def setStatus(status)
    if status== "new" then
      return "新着順"
    elsif status == "hatebu"
      return "はてぶ順"
    elsif status == "like"
      return "LIKE"
    elsif status == "later"
      return "後で読む"
    elsif status == "read"
      return "既読list"
    else
      return ""
    end
  end

  def updateRSS
    fh = ["http://developer.hatenastaff.com/rss",
      "http://techlife.cookpad.com/rss", 
      "http://blog.cybozu.io/rss",
      "http://labs.gree.jp/blog/rss",
      "http://alpha.mixi.co.jp/rss",
      "http://techlog.voyagegroup.com/rss",
      "http://techblog.yahoo.co.jp/index.xml",
      "http://ch.nicovideo.jp/dwango-engineer/blomaga/nico/feed",
      "http://rssblog.ameba.jp/ca-1pixel/rss20.xml"
     ]

     fh =[fh[rand(9)]]
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

        rss.items.each do |item|
            #puts "Title: " + item.title
            #puts item.date
            # get hatebu count
            # i = i + 1
            # begin
            #   count = open("http://api.b.st-hatena.com/entry.count?url=" + item.link).read
            # rescue => ex
            #   puts ex.message
            #   next
            # end
            count = 0
            # puts "Hatebu Count: " + count
            Infomation.create(siteName:rss.channel.title, siteURL:rss.channel.link, title:item.title, description:item.description, date:item.pubDate.inspect, url:item.link ,stocked:0,liked:0,hatebu:count)
            if i == 1 then
              break
            end
        end
    end
  end
end