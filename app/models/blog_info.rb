class BlogInfo < ActiveRecord::Base
	validates :entry_id, uniqueness: true
end
