class CreateLanguages < ActiveRecord::Migration
  def self.up
    create_table :languages do |t|
      t.string :name
      t.string :short_code

      t.timestamps
    end

    # Create some default languages
    Language.create(:name => 'Svenska', :short_code => 'sv')
    Language.create(:name => 'English', :short_code => 'en')
    Language.create(:name => 'Danish', :short_code => 'da')
    Language.create(:name => 'German', :short_code => 'de')
    Language.create(:name => 'Norwegian', :short_code => 'no')

  end

  def self.down
    drop_table :languages
  end
end
