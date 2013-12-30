class CopyDomainToServers < ActiveRecord::Migration
  def self.up
    Website.all.each do |w|
      w.servers.each do |s|
        s.update_attribute(:domain, w.domain)
      end
    end
  end

  def self.down
  end
end
