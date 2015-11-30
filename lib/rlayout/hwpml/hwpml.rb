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
	  attr_accessor :head, :body, :tail, :bin_data_list_items, :bin_data_set
	  attr_accessor :para_styles, :char_styles, :styles
	  attr_accessor :block_list, :story, :images
	  
	  def initialize(path, options={})
	    @path                 = path
  	  @hwpml                = File.open(@path, 'r'){|f| f.read}
      if options[:output_path]
        @output_path        = options[:output_path] 
      else
        @output_path        = @path.gsub(".hml", "")
      end
      @doc                  = Nokogiri::XML(@hwpml)
      @bin_data_list_items  = @doc.xpath("//BINDATALIST/BINITEM")
      @bin_data_set         = doc.xpath("//BINDATASTORAGE/BINDATA")
      
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
	  	  
    def save_csv(table_csv, table_name)
      tables_path = @output_path + "/tables"
      system("mkdir -p #{tables_path}") unless File.exist?(tables_path)
      table_path  = tables_path + "/#{table_name}.csv"
      File.open(table_path, 'w'){|f| f.write table_csv.to_s}
    end
    
    # save long table to disk as csv or add short table to story
    def process_table(table_element, table_count, options={})
      row_count           = table_element.attributes["RowCount"].value.to_i
      column_count        = table_element.attributes["ColCount"].value.to_i
      cell_separator      = "|"
      long_table_row_count= options.fetch(:long_table_row_count, 3)
      long_table          = row_count > long_table_row_count ? true : false
      if long_table
        # for long table use csv with ","
        options[:cell_separator] = ","
        cell_separator  = ","
      end
      @rows_text        = ""
      table_element.children.each do |child|
        if child.name == "ROW"
          @rows_text += parse_table_row(child, options)
        end
      end
      table_name    = "table_#{table_count}"
      if long_table
  	    story_text  = "[format='csv', options='header']"
        story_text  += "\n|===\n"
        story_text  += "include::#{table_name}.csv[]\n"
  	    story_text  += "|===\n\n"
        save_csv(@rows_text, table_name)
      else # short table
        story_text  = ""
        # story_text = ".table_#{table_count}"
        story_text += "\n|===\n"
        story_text += @rows_text
  	    story_text += "|===\n\n"
      end
      @story += "\n"
      @story += "#{story_text}\n"
	  end
	  
	  def parse_table_row(row, options={})
	    row_text = ""
	    row.children.each_with_index do |cell, i|
	      row_text += parse_table_cell(cell, i, options)
      end
      row_text += "\n"
	  end
	  
	  def parse_table_cell(cell, i, options={})
	    col_span        = cell.attributes["ColSpan"]
	    row_span        = cell.attributes["RowSpan"]
	    cell_separator  = options.fetch(:cell_separator, "|")
	    col_span_text   = ""
	    row_span_text   = ""
	    col_span_text   = "#{col_span.value}+" if col_span.value != "1"
	    row_span_text   = "." + "#{row_span.value}+" if col_span.value != "1"
	    para_list       = cell.children.first 
	    p               = para_list.children.first
	    text            = p.children.first
	    char            = text.text
	    cell_text       = ""
	    if i == 0 && col_span_text == "" && row_span_text == "" && cell_separator == ","
	      # do not start the row with , for csv with no span
	      cell_text = "#{char}"
      else
	      cell_text = "#{col_span_text}#{row_span_text}#{cell_separator}#{char}"
	    end
	    cell_text
	  end
	  
	  def extract_image_info(image_element)
	    image_info = {}
	    image_field               = image_element.children.select {|child| child.name == "IMAGE"}
      bin_item_value            = image_field.first.attributes["BinItem"]
      bin_item_index            = bin_item_value.to_s.to_i - 1
      bin_data_list_item        = @bin_data_list_items.at(bin_item_index)
      file_type                 = bin_data_list_item.attributes["Format"]
      image_info[:file_type]    = file_type
      image_info[:bin_item_index]= bin_item_index
      image_info
	  end
	  
	  def save_images
	    images_path     = @output_path + "/images"
      system("mkdir -p #{images_path}") unless File.directory?(images_path)
	    @images.each_with_index do |image_info, i|
	      image_type      = image_info[:file_type]
	      image_path      = images_path + "/#{i+1}.#{image_type}"
        data            = @bin_data_set.at(image_info[:bin_item_index])        
        File.open(image_path, 'w'){|f| f.write Base64.decode64(data.text)}
      end
	  end
	  

    def save(options={})
      system("mkdir -p #{@output_path}") unless File.directory?(@output_path)
      save_style
      save_images
      story_path = @output_path + "/story.adoc"
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
    
	  def parse_block_list(options={})
	    @story        = ""
	    @tables       = []
	    table_count   = 1
	    @images     = []
	    picture_count = 1
	    @doc.xpath('//SECTION/P').each do | p_element|
	      p_element.children.each do |text_element|
	        text_element.children.each do |grand_child|
  	        type = grand_child.name if grand_child
            case type
            when "CHAR"
              style_ref   = p_element.attributes["Style"]
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
              text += grand_child.text
              text.gsub!(/\s+/, " ")              
              @story += text if text
            when "TABLE"
              # this determins whether to save table or put it in story
              options[:long_table_row_count] = 3
              process_table(grand_child, table_count, options)
              table_count += 1
            when "PICTURE"
              @story += "\n"
              image_info = extract_image_info(grand_child)
              @story += "image::#{picture_count}.#{image_info[:file_type]}\n"
              picture_count += 1
              #TODO
              # save_image
              @images << image_info
            when "LINE"
              @story += "\n"
              @story += "line"
          
            when "SECDEF"
              # puts "secdef"
            else
              # puts "something else"
            end
	        end
	      end
	      @story += "\n"
	      
      end
	    
	  end
	  

	end

  
end