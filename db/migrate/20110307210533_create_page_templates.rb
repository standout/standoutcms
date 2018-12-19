class CreatePageTemplates < ActiveRecord::Migration
  def self.up
    create_table :page_templates, :force => true do |t|
      t.integer :look_id
      t.string :slug
      t.string :name
      t.boolean :default_template, :default => false
      t.boolean :partial, :default => false
      t.text :html
      t.timestamps
    end

    add_column :pages, :page_template_id, :integer

    # Convert existing looks into Page Templates.
    Look.all.each do |look|
      puts "Converting Look #{look.id} (#{look.title}) into a PageTemplate."

      connect_to_id = look.website.looks.first.id

      pt = PageTemplate.create!(
        :look_id => connect_to_id,
        :name => look.title,
        :slug => look.title.to_slug,
        :default_template => (look.website && look == look.website.looks.first),
        :partial => false,
        :html => look.html)

      # connect pages to this PageTemplate

      look.website.pages.where(look_id: look.id).each do |p|
        puts "Attaching PageTemplate #{pt.id} to Page #{p.id} - #{p.title}"
        if p.update_attribute :page_template_id, pt.id
           puts "Done."
        else
          puts "Failed."
        end
      end


        PageTemplate.create!(
          :look_id => connect_to_id,
          :name => look.title + ' blog',
          :slug => 'blogger',
          :default_template => (look.website && look == look.website.looks.first),
          :partial => false,
          :html => look.blogentry) if look.blogentry.to_s != ""
    end

    # Add blog_page_id to website settings
    add_column :websites, :blog_page_id, :integer
    add_column :websites, :blog_category_page_id, :integer

  end

  def self.down
    remove_column :pages, :page_template_id
    remove_column :websites, :blog_category_page_id
    remove_column :websites, :blog_page_id
    drop_table :page_templates
  end
end