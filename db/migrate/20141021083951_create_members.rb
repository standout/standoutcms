class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.belongs_to :website, index: true
      t.boolean :approved, default: false
      t.string :email
      t.string :password_digest
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :postal_street
      t.string :postal_zip
      t.string :postal_city
      t.string :phone

      t.timestamps
    end

    add_index :members, [:website_id, :email],    unique: true
    add_index :members, [:website_id, :username], unique: true
  end
end
