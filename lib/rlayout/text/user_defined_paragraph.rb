
# marker is a regex expression, it is used to parse the paragraph
# ex.  == Some marker for section /^==\s+/

# removed_marker is removed once it is parsed
#  ex.  # Some where,  # is removed when from string
#  ex.  ## Some where,  ## is removed when from string

#  child is a paragraph within the same text_block,  has different paragraph style
#  ex.  1.Some where, child is included in same text block
#          a. they a parsed with parent
#          b. they a parsed with parent

module RLayout

	class List < Paragraph
	  attr_reader :marker, :removed_marker, :name
	  attr_reader :child_marker, :child_indent, :first_child_margin

	  def initialize(options={})
	    super
	    @marker           = options[:marker]
	    @removed_marker   = options[:removed_marker]
	    @child_marker     = options[:child_marker]
	    self
	  end
	end

  # class OrderedList < List
  #
  # end
  #
  # class UnorderedList < List
  #
  # end

end
