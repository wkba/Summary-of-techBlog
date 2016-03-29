class LaterBlog < ActiveRecord::Base
	validates :entry_id, uniqueness: true
end
