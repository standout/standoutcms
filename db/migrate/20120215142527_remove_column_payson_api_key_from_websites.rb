class RemoveColumnPaysonApiKeyFromWebsites < ActiveRecord::Migration
  def change
    remove_column :websites, :payson_api_key
  end
end
