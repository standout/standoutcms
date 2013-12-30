#
# This is the tokenizer for search and filtering.
#
# To add support for more types or other special filters just add parsing for
# the different tokens where indicated below.
#
# Remember that these will be used in the where clause later and defaults to
# just passing whatever "pair" is to Arels intelligent where parser ...
#

module Tokenizer

	Inf = 1/0.0

  private

  def tokenizer(input_string)
    @query_hash = {:query => {:string => ''}, :filter => {}}
    # Split tokens and values by double underscore
    a = input_string.split('__')
    # Take a pair of values (from the front)
    pair = a.shift(2)
    # As long as we have pairs of values
    while pair.length == 2
      pair[0].downcase!
      # Match the free text search parameter
      # Overwrite! Only the last search string will be used
      if pair[0] == "query_string"
        @query_hash[:query][:string] = pair[1].gsub("_"," ")
      # Match all the filters
      else
        # Range detection
        if pair[1].include?("to")
          # Detect range n..m
          va = pair[1].split("to")
          pair[1] = va[0] if va.length == 1
          pair[1] = Range.new(va[0].to_i, va[1].to_i) if va.length == 2
        elsif pair[1].start_with?("below")
          # Detect range -Inf..n
          pair[1] = Range.new(-Inf, pair[1].sub("below","").to_i)
        elsif pair[1].start_with?("above")
          # Detect range n..Inf
          pair[1] = Range.new(pair[1].sub("above","").to_i, Inf)
        end

        # ------------------------------
        # ADD CASING FOR NEW TYPES HERE!
        # ------------------------------

        @query_hash[:filter].store(pair[0].to_sym, pair[1])
      end
      pair = a.shift(2)
    end
    return @query_hash
  end

end
