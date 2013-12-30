class UpgradeVestalVersionsToRails3 < ActiveRecord::Migration
  def up
    rename_column :versions, :changes, :modifications
  end

  def down
    rename_column :versions, :modifications, :changes
  end
end
