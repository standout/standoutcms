module Liquid
  class ::InstagramPhotos < Block
    Syntax = /(\w+)\s+in\s+(#{QuotedFragment}+)\s*(reversed)?/

    def initialize(tag_name, markup, tokens)
      if markup =~ Syntax
        @variable_name = $1
        @collection_name = $2
        @name = "#{$1}-#{$2}"
        @reversed = $3
        @attributes = {}

        markup.scan(TagAttributes) do |key, value|
          @attributes[key] = value
        end

      else
        raise SyntaxError.new("Syntax Error in 'for loop' - Valid syntax: instagramphotos [item] in [collection]")
      end

      @nodelist = @for_block = []
      super
    end

    def unknown_tag(tag, markup, tokens)
      return super unless tag == 'else'
      @nodelist = @else_block = []
    end

    def render(context)
      context.registers[:for] ||= Hash.new(0)

      http = HTTPClient.new

      is_number = true if Float(@collection_name.to_s) rescue false

      if is_number # guessing that is is a user id
        json = JSON.parse(http.get_content("https://api.instagram.com/v1/users/#{@collection_name.to_s.parameterize}/media/recent?client_id=2a94f059062a4b2b9028e8f5ddcb5f20"))
      else
        json = JSON.parse(http.get_content("https://api.instagram.com/v1/tags/#{@collection_name.to_s.parameterize}/media/recent?client_id=2a94f059062a4b2b9028e8f5ddcb5f20"))
      end

      collection = json["data"]

      collection = collection.to_a if collection.is_a?(Range)

      return render_else(context) unless collection.respond_to?(:each)

      from = if @attributes['offset'] == 'continue'
        context.registers[:for][@name].to_i
      else
        context[@attributes['offset']].to_i
      end

      limit = context[@attributes['limit']]
      to    = limit ? limit.to_i + from : nil

      if @attributes['filter']
        collection = filter_collection(collection, @attributes['filter'])
      end

      if @attributes['without']
        collection = filter_out_from_collection(collection, @attributes['without'])
      end

      # Make sure we filter the collection first, then select from the filtered
      # subset.
      if @attributes['sample']
        collection = select_random_from_collection(collection, @attributes['sample'])
      end

      segment = slice_collection_using_each(collection, from, to)

      return render_else(context) if segment.empty?

      segment.reverse! if @reversed

      result = ''

      length = segment.length

      # Store our progress through the collection for the continue flag
      context.registers[:for][@name] = from + segment.length

      context.stack do
        segment.each_with_index do |item, index|
          context[@variable_name] = item
          context['forloop'] = {
            'name'    => @name,
            'length'  => length,
            'index'   => index + 1,
            'index0'  => index,
            'rindex'  => length - index,
            'rindex0' => length - index -1,
            'first'   => (index == 0),
            'last'    => (index == length - 1) }

          result << render_all(@for_block, context)
        end
      end
      result
    end

    def slice_collection_using_each(collection, from, to)
      segments = []
      index = 0
      yielded = 0
      collection.each do |item|

        if to && to <= index
          break
        end

        if from <= index
          segments << item
        end

        index += 1
      end

      segments
    end

    def filter_collection(promotions, filter)
      required = filter.gsub(/^('|")|('|")$/, '').gsub(/\s/, '').split(',')
      promotions.select{ |promotion| required & promotion.tags == required }
    end

    def filter_out_from_collection(promotions, filter)
      forbidden = filter.gsub(/^('|")|('|")$/, '').gsub(/\s/, '').split(',')
      promotions.select{ |promotion| forbidden & promotion.tags == [] }
    end

    def select_random_from_collection(promotions, nr_of_promos)
      nr_of_promos.gsub!(/^('|")|('|")$/, '')
      promotions.sample(nr_of_promos.to_i)
    end

    private

      def render_else(context)
        return @else_block ? [render_all(@else_block, context)] : ''
      end

  end
end

Liquid::Template.register_tag('instagramphotos', InstagramPhotos)


