
module RLayout
  class MGFillRecord
    attr_accessor :dictionary
  
    def initialize(dictionary)
      @dictionary=dictionary
      self
    end

    def serialize
      @dictioanry
    end
    

    # 
    # rather than creating fill_record, return fill_options hash, so fill_record can be create at SMGraphic 
    def fill_options
      fill_options={}
      fill_type= 1
      fill_type= @dictionary['Fill'].to_i if @dictionary['Fill']
      fill_options[:fill_type]        = fill_type 
      fill_options[:fill_color]       = RLayout::Graphic.color_from_string(@dictionary['CO1']) if @dictionary['CO1']
      fill_options[:fill_other_color] = RLayout::Graphic.color_from_string(@dictionary['CO2']) if @dictionary['CO2']
      fill_options
    end
    
  end
  
  
  class MGLineRecord
    attr_accessor :dictionary
    def initialize(dictionary)
      @dictionary=dictionary
      self
    end
  
    # rather than creating line_record, return line_options hash , so line_record can be create at SMGraphic 
    def line_options
      line_options={}
      line_options[:line_width]     = @dictionary['Width'].to_f if @dictionary['Width']
      #{"Dash"=>"{{3, 3}, {3, 0}}", "Width"=>"2.00"}
      line_options[:dash]           = @dictionary['Dash'].gsub("{","").gsub("}","").split(',') if @dictionary['Dash']
      if @dictionary['Arrow']
        # start_arrow, :end_point, :end_arrow
        line_options[:start_arrow]  = @dictionary['Arrow']['StartArrow'] if @dictionary['Arrow']['ArrowHead']
        line_options[:EndArrow]     = @dictionary['Arrow']['EndArrow'] if @dictionary['Arrow']['EndArrow']
      # Arrow =                             {
      #     ArrowHead = "1.0";
      #     EndArrow = "star_s";
      #     StartArrow = arrow1;
      # };
      end
      line_options[:line_color]     = RLayout::Graphic.color_from_string(@dictionary['LC']) if @dictionary['LC']
      line_options
      
    end
    
    def serialize
      @dictioanry
    end
    
  end
  

  class MGraphic
  
    attr_accessor :dictionary, :paragraph_style_manager, :document_path
  
    def initialize(dictionary, paragraph_styles, options={})
      @dictionary=dictionary
      # @paragraph_style_manager=MParagraphStyleManager.new(paragraph_styles)
      @paragraph_style_manager =  MParagraphStyleManager.mparagraph_style_manager_from_m_sytle_dictiionay(paragraph_styles)
      # we need document_path for getting the full path of local_image
      @document_path=options[:document_path] if options[:document_path]
      self
    end
  
    def kind
      @dictionary['Class'] unless @dictionary.nil?
    end
    
    def to_json
      require 'json'
      @dictoinary.to_jason
    end
    
    def serialize_graphic
      @dictionary
    end    
    
    def html_position
      rect= NSRectFromString(dictionary['Bounds'])  
      "style=\"position:absolute; left:#{rect.origin.x.to_i}px; top:#{rect.origin.y.to_i}px; width:#{rect.size.width.to_i}px; height:#{rect.size.height.to_i}px;\""
    end
    
    def to_html
      text_runs=MArticleRecord.new(@dictionary['Article'], @paragraph_style_manager).to_html if @dictionary['Article']
      html=<<EOF
      <div class=\" #{dictionary['Class']}\" #{html_position}>
       #{text_runs}
      </div>
EOF
      html
    end
    
    # to_smgraphic
    # This method convert graphics of MLayout2.0 based graphic objects to new smgraphics format.
    # TO DO: SMTitleText handling
    def to_smgraphic(options={})         
      bleed_x=0
      bleed_x=options[:bleed_x] if options[:bleed_x]
      bleed_y=0
      bleed_y=options[:bleed_y] if options[:bleed_y]
      # bleed_x-=0.929188  #this seems to have creeped 
      # bleed_y-=0.00039  #this seems to have creeped 
      sm_graphic=nil
      @hash={}
      @hash[:inset]=0
      @hash[:inset]=@dictionary['Inset'].to_f if  @dictionary['Inset']              
      @hash[:frame]=NSRectFromString(@dictionary['Bounds'])
      @hash[:frame].origin.x-=bleed_x
      @hash[:frame].origin.y-=bleed_y  
      # 2016 8 9 mskim
      @hash[:x]       = @hash[:frame].origin.x.round(3)
      @hash[:y]       = @hash[:frame].origin.y.round(3)
      @hash[:width]   = @hash[:frame].size.width.round(3)
      @hash[:height]  = @hash[:frame].size.height.round(3)
      
      @hash[:line_options]=MGLineRecord.new(@dictionary['Frame']).line_options if @dictionary['Frame'] 
      @hash[:fill_options]=MGFillRecord.new(@dictionary['Fill']).fill_options if @dictionary['Fill']
      @hash[:shape_record]=@dictionary['Shape'] if @dictionary['Shape']
      @hash[:tag]         =@dictionary['Name']  if @dictionary['Name']
      @hash[:auto_layout]=nil
      @hash[:unique_id]=@dictionary['Number']   if  @dictionary['Number']              
      case @dictionary['Class']        
      when 'SMPageObject'
        sm_graphic= SMPage.new(@hash)
      when 'SMRectangle'
        if @dictionary['Article'] 
          @hash[:prev_link]=@dictionary['Article']['BeforeBox'] if @dictionary['Article']['BeforeBox']
          @hash[:next_link]=@dictionary['Article']['AfterBox']  if @dictionary['Article']['AfterBox']
          if @dictionary['GraphicContainer']
            @hash[:columns]=@dictionary['GraphicContainer']["Column"].to_i if @dictionary['GraphicContainer']["Column"]
            # @hash[:width]=@dictionary['GraphicContainer']["Cell"][0].to_f if @dictionary['GraphicContainer']["Cell"]
            @hash[:gutter]=NSSizeFromString(@dictionary['GraphicContainer']["Inter"]).width if @dictionary['GraphicContainer']["Inter"]
          end
          @hash[:ns_attributed_string]=MArticleRecord.new(@dictionary['Article'],@paragraph_style_manager).att_string
          # @hash[:m_article_dictionary]=@dictionary['Article']
          # puts "++++ :#{@dictionary['Name']}" if @dictionary['Name']
          # puts "@hash[:ns_attributed_string].class:#{@hash[:ns_attributed_string].class}"
          sm_graphic= Text.new(@hash)
        else
          sm_graphic= Rectangle.new(@hash)
        end
      when 'SMImage'
        if @dictionary['Image']
          @hash[:image_path]  = @dictionary['Image']['Path'].to_s           
          @hash[:local_image] = @document_path + "/" + @dictionary['Image']['PFN'].to_s if @dictionary['Image']['PFN']       
          @hash[:image_frame] = NSRectFromString(@dictionary['Image']['Frame'])
            # @hash[:image]=image
        end
        sm_graphic= Image.new(@hash)          
      # when 'SMTable'
      # when 'SMMath'
      when 'SMCircle'
       sm_graphic= Circle.new(@hash)
      when 'SMLine'          
        @hash[:start] =NSPointFromString(@dictionary['Start'])
        @hash[:start].x-= bleed_x
        @hash[:start].y-= bleed_y
        @hash[:end] =NSPointFromString(@dictionary['End'])    
        @hash[:end].x-= bleed_x
        @hash[:end].y-= bleed_y
        sm_graphic= Line.new(@hash)
      else
        sm_graphic= Rectangle.new(@hash)
      end
      sm_graphic
    end
  end
end