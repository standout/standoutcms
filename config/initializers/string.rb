class String

  # Transform a word or sentence to a lowercase fully compatible URL part.
  def to_slug
    #strip the string
    ret = self.strip

    ret.downcase!

    #blow away apostrophes
    ret.gsub!(/['`]/,"")

    # @ --> at, and & --> and
    ret.gsub!(/\s*@\s*/, " at ")
    ret.gsub!(/\s*&\s*/, " and ")


    #replace all non alphanumeric, underscore or periods with underscore
     ret.gsub!(/\s*[^A-Za-z0-9\.\-\/]\s*/, '_')

     #convert double underscores to single
     ret.gsub!(/_+/,"_")

     #strip off leading/trailing underscore
     ret.gsub!(/\A[_\.]+|[_\.]+\z/,"")
     ret
  end

  # Make sure a string is in UTF-8
  def force_utf8
    self.encode("UTF-8")
  rescue Encoding::UndefinedConversionError
    self
  end

end
