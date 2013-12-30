class AddDomainAliasesToWebsite < ActiveRecord::Migration
  def change
    add_column :websites, :domainaliases, :string
  end
end
