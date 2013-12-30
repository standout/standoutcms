class BlogCategory < ActiveRecord::Base
  attr_accessible :website_id, :name
  
  belongs_to :website
  has_many :posts, :order => 'created_at desc'

  after_destroy :disconnect_blogposts
  
  # Don't leave blogposts connected to this category after destruction
  def disconnect_blogposts
    self.posts.each do |post|
      post.update_attribute :blog_category_id, nil
    end
  end
  
  def to_liquid
    { "name"  => self.name,
      "posts" => self.posts.collect(&:to_liquid),
      "post_count" => self.posts.length }
  end

  
end
