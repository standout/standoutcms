class MigrateToNestedSet < ActiveRecord::Migration
  def self.up
    Website.all.each do |w|
      w.root_pages.each do |r|
        r.renumber_full_tree
      end
    end
  end

  def self.down
  end
end
