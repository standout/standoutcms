class AddActiveLookToWebsite < ActiveRecord::Migration
  def self.up
    add_column :websites, :look_id, :integer
    
    Website.all.each do |w|
      unless w.looks.empty?
        w.update_attribute :look_id, w.looks.first.id
      end
    end
    
  end

  def self.down
    remove_column :websites, :look_id
  end
end