class Infomation < ActiveRecord::Base
	validates :title, uniqueness: true
	validates :description, uniqueness: true
	validates :url, uniqueness: true


end
