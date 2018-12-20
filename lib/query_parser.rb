#
# This module is included in the liquid drops that need support for filtering
# and searching.
#
#   Most of the heavy lifting is done in the tokenizer and this is just a bit of
#   setup and hooks to get the drop working the right way.
#
#   Since we are using the method missing approach to get this functionality you
#   could make shortcut filters if you wanted. Adding a "price_above__" if below
#   and parsing whatever came after it however you wanted.
#
#   Remember that the query_hash format IS SHARED!!! and used in other modules
#   as well, so don't change it lightly.
#
# Examples of calls you could do from a liquid view:
#
#  filter__type__excentric__size__32 => {:query => {:string => ''}, :filter => {:type => "excentric", :size => 32}}
#  filter__type__excentric__size__16to32 => {:query => {:string => ''}, :filter => {:type => "excentric", :size => 16..32}}
#  filter__type__excentric__size__above16 => {:query => {:string => ''}, :filter => {:type => "excentric", :size => 16..Inf}}
#  filter__type__excentric__size__below32 => {:query => {:string => ''}, :filter => {:type => "excentric", :size => -Inf..32}}
#
#  search__query_string__velvet_fur_coat => {:query => {:string => 'velvet fur coat'}, :filter => {}}
#  search__query_string__velvet_fur_coat__query_string__overwrite => {:query => {:string => 'overwrite'}, :filter => {}}
#
#  search_and_filter__query_string__velvet_fur_coat__type__excentric__size__32 => {:query => {:string => 'velvet fur coat'}, :filter => {:type => "excentric", :size => 32}}
#

module QueryParser

  require 'tokenizer'
  include Tokenizer

  def initialize(inst)
    @instance = inst
    @query_hash = {:query => {:string => ''}, :filter => {}}
  end

	# Hooks in and acts as method missing, argument is the method that was really called
  def liquid_method_missing(method_name)
    if @instance.respond_to? :search_and_filter
      results = @instance.search_and_filter(tokenizer(method_name.sub("filter__",""))) if method_name.start_with?("filter__")
      results = @instance.search_and_filter(tokenizer(method_name.sub("search__",""))) if method_name.start_with?("search__")
      results = @instance.search_and_filter(tokenizer(method_name.sub("search_and_filter__",""))) if method_name.start_with?("search_and_filter__")
    else
      results = []
    end

    return results.collect { |r| Kernel.const_get("#{@instance.search_class.name}Drop").new(r) }
  end

end
