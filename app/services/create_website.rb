class CreateWebsite < Struct.new(:website)
  def self.call(website, *args)
    new(website).call(*args)
  end

  def call
    if saved = website.save
      after_create
    end

    saved
  end

  def after_create
    self.look = Look.create(website: website, title: "Standard")

    create_template("standard") do |pt|
      pt.html = read_liquid_template("base")
    end

    create_template("cart")

    create_template("checkout")

    create_template("product")

    create_template("product_category")

    create_partial("header")

    create_partial("footer")

    Page.create do |p|
      p.website = website
    end
  end

  private

  attr_accessor :look

  # Infers name and html from slug,
  # you can override by passing in a block
  def create_template(slug, &block)
    page_template = PageTemplate.new do |pt|
      pt.look = look
      pt.slug = slug
    end

    yield page_template if block_given?

    page_template.html ||= read_liquid_template(slug)
    page_template.name ||= slug.humanize

    page_template.save
  end

  # Partials have partial:true and their html file begins with underscore
  def create_partial(slug, &block)
    create_template(slug) do |page_template|
      page_template.partial = true
      page_template.html = read_liquid_template("_#{slug}")
      yield page_template if block_given?
    end
  end

  def read_liquid_template(name)
    File.read("#{Rails.root}/lib/liquid_templates/templates/#{name}.liquid")
  end
end
