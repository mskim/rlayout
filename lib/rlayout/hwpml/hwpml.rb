
module RLayout
	class Hwpml
	  attr_accessor :doc, :path, :hwpml
	  attr_accessor :head, :body, :tail
	  attr_accessor :para_styles, :char_styles, :styles
	  attr_accessor :block_list
	  
	  def initialize(options={})
      if options[:path]
	      @path   = options[:path]
  	    @hwpml  = File.open(@path, 'r'){|f| f.read}
      elsif options[:hwpml]
        @hwpml  = options[:hwpml]
      end
      @doc = Nokogiri::XML(@hwpml)
      parse_char_styles
      parse_para_styles
      parse_styles
      parse_block_list
	    self
	  end
	  
	  def parse_char_styles
	    @char_styles = []
	    @doc.xpath('//CHARSHAPE').each do | char_style |
        attributes = {}
	      char_style.keys.each do |key|
          attributes[key] = char_style[key]
        end
        @char_styles << attributes
      end
     
	  end
	  
	  def parse_para_styles
	    @para_styles = []
	    @doc.xpath('//CHARSHAPE').each do | para_style |
        attributes = {}
	      para_style.keys.each do |key|
          attributes[key] = para_style[key]
        end
        @para_styles << attributes
      end
	  end
	  
	  def parse_styles
	    @styles = []
  	  @doc.xpath('//CHARSHAPE').each do | style |
  	    attributes = {}
	      style.keys.each do |key|
          attributes[key] = style[key]
        end
        @styles << attributes
      end  	 
	  end
	  
	  # return section
	  def sections_list
	   
	  end
	  
	  # parse top level blocks: paragraphs,tables etc
	  def parse_block_list
	    @block_list = []
	    # get only the top level blocks
	    # we don't want ("//P"), we want ('//SECTION/P') top lebel 'P' only
	    #SECDEF, COLDEF, TABLE, PICTURE, CONTAINER, OLE, EQUATION, 
	    #TEXTART, LINE, RECTANGLE, ELLIPSE, ARC, POLYGON, CURVE, 
	    #CONNECTLINE, UNKNOWNOBJECT, FIELDBEGIN, FIELDEND, BOOKMARK, 
	    #HEADER, FOOTER, FOOTNOTE, ENDNOTE, AUTONUM, NEWNUM, 
	    #PAGENUMCTRL, PAGEHIDING, PAGENUM, INDEXMARK, COMPOSE, 
	    #DUTMAL, HIDDENCOMMENT, BUTTON, RADIOBUTTON, CHECKBUTTON, COMBOBOX, 
	    #EDIT, LISTBOX, SCROLLBAR
	    @doc.xpath('//SECTION/P/TEXT').each do | top_level_block |
        if is_table?(top_level_block)
	        @block_list << parse_table(top_level_block)
        else
          @block_list << parse_text_block(top_level_block)
        end
      end
	  end
	  
	  def parse_table(block_element)
	    "table"
	  end
	  
	  def parse_text_block(block_element)
	    "text_block"
	  end
	  
	  def is_table?(element)
	    element.children.each do |table_child|
	      return true if table_child.name == "TABLE"
      end
      false
	  end
	  
	  def is_text_paragraph?(element)
	   
	  end
	end

  
end