class AddProposedParentIdToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :proposed_parent_id, :integer
  end

  def self.down
    remove_column :pages, :proposed_parent_id
  end
end
