class Search
  def initialize(website)
    @website = website
  end

  def query(q)
    {
      :products => products(q)
    }
  end

  def products(q)
    q.blank? ? [] : @website.products.where("title like ?", "%#{q}%")
  end

  def members(params)
    Search.among(@website.members, params) do
      where(:email)    { "email like :email" }
      where(:username) { "username like :username" }
      where(:approved) { "approved = :approved" }
      where(:name)     { "concat(first_name, ' ', last_name) like :name" }
      where(:phone)    { "phone like :phone" }
      where(:postal) do
        "concat(postal_street, ', ', postal_zip, ' ', postal_city) like :postal"
      end
    end
  end

  def self.among(relation, params, &block)
    # The block you pass in will have access to the DSL methods below
    dsl = DSL.new(relation, params)
    dsl.instance_eval(&block)
    dsl.relation
  end

  # Domain specific language for building search query
  class DSL
    attr_reader :relation

    def initialize(relation, params)
      @relation = relation
      @params = params
    end

    # Usage:
    #   where(:name) { "concat(first_name, last_name) like :name" }
    # So you don't need to write:
    #   unless params[:name].nil? || params[:name] == ""
    #     @relation = @relation.where(
    #       "concat(first_name, last_name) like :name",
    #       name: "%#{params[:first_name]}%"
    #     )
    #   end
    def where(*args, &block)
      query = yield

      params = {}
      @params.each do |key, val|
        key = key.to_sym
        next unless args.include?(key)
        next if val.nil? || val == ""

        if query =~ /like/
          params[key] = "%#{val}%"
        else
          params[key] = val
        end
      end

      @relation = @relation.where(query, params) if params.present?

      self
    end
  end
end
