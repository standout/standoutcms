class GenerateApiKeysForWebsites < ActiveRecord::Migration
  def self.up
    Website.all.each do |website|
      website.api_key = rand(2**256).to_s(36)[0..15] if website.api_key.blank?
      website.save
      puts "Website #{website.title} is saved"
    end
  end

  def self.down
  end
end
