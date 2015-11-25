# CHARSHAPE : char_style
# font, size 

# PARASHAPE : pargraph_style
# level, alignment, numbering, tab

# STYLE : actual style used. It combines char_style, and pargraph_style
# EngName,  name, char_style, pargraph_style, next, prv

# PICTURE
# actul data is stored at the end in the TAIL BINDATASTORAGE as  BINDATA with Id = "1"
# encoded in base64 and compress in which form?

module RLayout
	class Hwpml
	  attr_accessor :path, :output_path, :doc, :hwpml
	  attr_accessor :head, :body, :tail
	  attr_accessor :para_styles, :char_styles, :styles
	  attr_accessor :block_list, :story, :tables, :images
	  
	  def initialize(path, options={})
	    @path       = path
  	  @hwpml      = File.open(@path, 'r'){|f| f.read}
      if options[:output_path]
        @output_path  = options[:output_path] 
      else
        @output_path  = @path.gsub(".hml", "")
      end
      @doc = Nokogiri::XML(@hwpml)
      parse_char_styles
      parse_para_styles
      parse_styles
      parse_block_list
	    self
	  end
	  
	  def save_style
	    head = {}
	    head[:char_styles]  = char_styles
	    head[:para_styles]  = para_styles
	    head[:styles]       = styles
	    yaml = head.to_yaml
      yaml_path = @output_path +  "/style.yml"
      File.open(yaml_path, 'w'){|f| f.write yaml}
	  end
	  
	  def save_tables
	    @tables.each_with_index do |table, i|
	      tables_path = @output_path + "/tables"
	      system("mkdir -p #{tables_path}") unless File.exist?(tables_path)
	      table_path  = tables_path + "/#{i+1}.table"
	      File.open(table_path, 'w'){|f| f.write table.to_s}
      end
	  end
	  
	  def save_images
	    images_path     = @output_path + "/images"
      system("mkdir -p #{images_path}") unless File.directory?(images_path)
	    @images.each_with_index do |image, i|
	      image_path      = images_path + "/#{i+1}.bmp"
	      image_info      = image.children.select {|child| child.name == "IMAGE"}
	      bin_item_index  = image_info.first.attributes["BinItem"]
	      bin_item_index  = bin_item_index.to_s.to_i - 1
        bin_data_set    = doc.xpath("//BINDATASTORAGE/BINDATA")
        data            = bin_data_set.at(bin_item_index)        
        File.open(image_path, 'w'){|f| f.write Base64.decode64(data.text)}
      end
	  end
	  
    def save(options={})
      puts "@output_path:#{@output_path}"
      system("mkdir -p #{@output_path}") unless File.directory?(@output_path)
      puts "File.directory?(@output_path):#{File.directory?(@output_path)}"
      save_style
      save_tables
      save_images
      story_path = @output_path + "/story.md"
      File.open(story_path, 'w'){|f| f.write @story}
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
	    @doc.xpath('//PARASHAPE').each do | para_style |
        attributes = {}
	      para_style.keys.each do |key|
          attributes[key] = para_style[key]
        end
        @para_styles << attributes
      end
	  end
	  
	  def parse_styles
	    @styles = []
  	  @doc.xpath('//STYLE').each do | style |
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
	  
	  # parse top level blocks in BODY/SECTION: paragraphs,tables etc
    # We parse P's in SECTION only ('//SECTION/P/TEXT')
    # They shoud contain one of the following child.
    #SECDEF, COLDEF, TABLE, PICTURE, CONTAINER, OLE, EQUATION, 
    #TEXTART, LINE, RECTANGLE, ELLIPSE, ARC, POLYGON, CURVE, 
    #CONNECTLINE, UNKNOWNOBJECT, FIELDBEGIN, FIELDEND, BOOKMARK, 
    #HEADER, FOOTER, FOOTNOTE, ENDNOTE, AUTONUM, NEWNUM, 
    #PAGENUMCTRL, PAGEHIDING, PAGENUM, INDEXMARK, COMPOSE, 
    #DUTMAL, HIDDENCOMMENT, BUTTON, RADIOBUTTON, CHECKBUTTON, COMBOBOX, 
    #EDIT, LISTBOX, SCROLLBAR
    
	  def parse_block_list
	    @story        = ""
	    @tables       = []
	    table_count   = 1
	    @images     = []
	    picture_count = 1
	    @doc.xpath('//SECTION/P').each do | top_level_block|
	      grand_child = top_level_block.children.first.children.first
	      type = grand_child.name if grand_child
        case type
        when "CHAR"
          style_ref   = top_level_block.attributes["Style"]
          style_index = style_ref.value.to_i
          style       = @styles[style_index]
          text  = ''
          case style['EngName']
          when 'Normal', 'Body'
          when 'Outline 1'
            text  = '# '
          when 'Outline 2'
            text  = '## '
          when 'Outline 3'
            text  = '### '
          when 'Outline 4'
            text  = '#### '
          when 'Outline 5'
            text  = '##### '
          when 'Outline 6'
            text  = '###### '
          when 'Outline 7'
            text  = '####### '
          end
          top_level_block.children.each do |child|
            grand_child = child.children.first
            text += grand_child.text if grand_child
          end
          @story += text.gsub!(/\s+/, " ") 
        when "TABLE"
          @story += "\n"
          @story += "Table_#{table_count}\n"
          table_count += 1
          @tables << grand_child
        when "PICTURE"
          @story += "\n"
          file_type = "jpg"
          @story += "image::#{picture_count}.#{file_type}\n"
          picture_count += 1
          @images << grand_child
        when "LINE"
          @story += "\n"
          @story += "line"
          
        when "SECDEF"
          puts "secdef"
        else
          puts "something else"
        end
	      @story += "\n"
      end
	    
	  end
	  

	end

  
end