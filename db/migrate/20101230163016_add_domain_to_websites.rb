class AddDomainToWebsites < ActiveRecord::Migration
  def self.up
    add_column :websites, :domain, :string
    
    Website.all.each do |w|
      w.update_attribute :domain, w.domains.first.name if w.domains.first
    end
    
  end

  def self.down
    remove_column :websites, :domain
  end
end