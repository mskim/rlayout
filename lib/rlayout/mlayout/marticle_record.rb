
# NSString *NSFontAttributeName;
# NSString *NSParagraphStyleAttributeName;
# NSString *NSForegroundColorAttributeName;
# NSString *NSUnderlineStyleAttributeName;
# NSString *NSSuperscriptAttributeName;
# NSString *NSBackgroundColorAttributeName;
# NSString *NSAttachmentAttributeName;
# NSString *NSLigatureAttributeName;
# NSString *NSBaselineOffsetAttributeName;
# NSString *NSKernAttributeName;
# NSString *NSLinkAttributeName;
# NSString *NSStrokeWidthAttributeName;
# NSString *NSStrokeColorAttributeName;
# NSString *NSUnderlineColorAttributeName;
# NSString *NSStrikethroughStyleAttributeName;
# NSString *NSStrikethroughColorAttributeName;
# NSString *NSShadowAttributeName;
# NSString *NSObliquenessAttributeName;
# NSString *NSExpansionAttributeName;
# NSString *NSCursorAttributeName;
# NSString *NSToolTipAttributeName;
# NSString *NSMarkedClauseSegmentAttributeName;

# sm left=0
# sm right=1
# sm center=2
# sm Justified=3
# sm Force=4

# typedef enum _NSTextAlignment {
#    NSLeftTextAlignment      = 0,
#    NSRightTextAlignment     = 1,
#    NSCenterTextAlignment    = 2,
#    NSJustifiedTextAlignment = 3,
#    NSNaturalTextAlignment   = 4
# } NSTextAlignment;

# framework 'cocoa'
# require 'utility'

module RLayout

  class MArticleRecord
    attr_accessor :dictionary, :attributes_array, :text_string, :att_string, :containers, :paragraph_style_manager    
    def initialize(dictionary, paragraph_style_manager)
      @dictionary=dictionary
      @paragraph_style_manager=paragraph_style_manager
      @containers=[]
      @dictionary['Containers'].each do |rect_string|
        @containers<< NSRectFromString(rect_string)
      end
      
      if @dictionary['Unicode']
          @text_string = NSString.alloc.initWithData(@dictionary['Unicode'], encoding:NSUnicodeStringEncoding)
          @att_string=attributedString_from_dictionary(@dictionary['Attribute'])
      else
        # puts "No @dictionary['Unicode']"
      end
    
      self
    end
    
    def serialize
      h={}
      h['Containers']=@dictionary['Containers'] if @dictionary['Containers']
      h['Unicode']=NSString.alloc.initWithData(@dictionary['Unicode'], encoding:NSUnicodeStringEncoding) if @dictionary['Containers']
      h['Attribute']=@dictionary['Attribute']
      h
    end
    
    # convert article_record into new format
    # chnages from MLayout format
    #   1. no more unicode encription, save them as readable format
    #   2. no more Containers, instead we can save inset, gutter and columns number
    #   3. better attstring saving
    # instead of saving by attributed string, I should have it by para_data
    def to_rlayout
      h={}
      h['string']=NSString.alloc.initWithData(@dictionary['Unicode'], encoding:NSUnicodeStringEncoding) if @dictionary['Containers']
      h['attribute']=@dictionary['Attribute']
      h['column']=@dictionary['GraphicContainer']['Column'] if @dictionary['GraphicContainer']['Column']
      h['gutter']=@dictionary['GraphicContainer']['Inter'][1] if @dictionary['GraphicContainer']['Inter']
      h.description
    end
    
    # convert article_record to para_data format
    def para_data_from_article_record(options={})
      if options[:paragraph_style_manager]
        
      else
        
      end
    end
    
    def html_from_article_record
      
    end
    
    def to_html
      t=""
      if @att_string
        text=@att_string.string 
        t=<<EOF
        <div class="smtext">#{text}</div>
EOF
      end
      t
    end
    
    
    def get_attrubutes_from_nsparagraphStyle(dictionary)
      atts={}
      paragraph_style=NSMutableParagraphStyle.alloc.init
      paragraph_style.setLineBreakMode(NSLineBreakByWordWrapping)
      paragraph_style.setLineSpacing(dictionary['LineSpacing'].to_f) if dictionary['LineSpacing']
      paragraph_style.setAlignment(dictionary['Alignment'].to_i) if dictionary['Alignment']
      # To do: we need to add more parastyle attributes here
      atts[NSParagraphStyleAttributeName]= paragraph_style
            
      if dictionary['CharStyle']
        @font_name=dictionary['CharStyle']['FontName']
        @font_size=dictionary['CharStyle']['FontSize']
        atts[NSFontAttributeName]= NSFont.fontWithName(@font_name, :size=>@font_size) 
        if dictionary['CharStyle']["Track"]
          atts[NSKernAttributeName]=dictionary['CharStyle']["Track"].to_f*@font_size/160
        end

        if dictionary['CharStyle']["NSColor"]
          atts[NSForegroundColorAttributeName]=color_from_hash(dictionary['CharStyle']["NSColor"]) 
        end
        
      end
      atts
    end
    
    def attributedString_from_dictionary(marticle_record)
      location=0
      puts "@text_string:#{@text_string}"
      puts "@text_string.length:#{@text_string.length}"
      att_string=NSMutableAttributedString.alloc.initWithString(@text_string, :atts=>{})
      marticle_record.each do |attributes|
        matts=attributes['Attrs']
        len=attributes['Len'].to_i
        range=NSMakeRange(location,len)
        @atts={}
      
        if matts['P_S']
          @atts=@paragraph_style_manager.atts_for_style_named(matts['P_S'])
        elsif matts['USN']
          encoded_text = NSString.alloc.initWithData(matts['USN'], encoding:NSUnicodeStringEncoding)
          # puts "encoded_text:#{encoded_text}"
          @atts=@paragraph_style_manager.atts_for_style_named(encoded_text)
        end

        if matts['NSParagraphStyle']
          @atts=get_attrubutes_from_nsparagraphStyle(matts['NSParagraphStyle'])
        end
        
        if matts['FontName']
          @fontSize=matts['FontSize'].to_f
          @atts[NSFontAttributeName] = NSFont.fontWithName(matts['FontName'], size:@fontSize)
          if matts['Track']
            @atts[NSKernAttributeName] = matts['Track'].to_f*@fontSize/160
            # puts "@atts[NSKernAttributeName]:#{@atts[NSKernAttributeName]}"
            # puts "in attributedString_from_dictionary"
          end
          if matts['FontScale']
            @font_scale=matts['FontScale'].to_f
            unless @font_scale == 100.0
              width=@fontSize*@font_scale/100
              fmatrix=[width,0,0,@fontSize,0,0]
              @atts[NSFontAttributeName] = NSFont.fontWithName(matts['FontName'], matrix:fmatrix)
            end
          end          
        end
        
       # if given font is not installed
       if @atts[NSFontAttributeName].nil?
         if matts['FontName']
           @font_name=matts['FontName'] if matts['FontName'] 
         else
           @font_name="Times-Roman"
         end
         
         if @font_size.nil?
           if matts['FontSize']
             @font_size=matts['FontSize'].to_f 
           else
             @font_size=12
           end
         end
         @atts[NSFontAttributeName]= NSFont.fontWithName(@font_name, :size=>@font_size) 
       end
       
       # if the value was not set, use default values
       unless @atts[NSFontAttributeName]
         @atts[NSFontAttributeName]=NSFont.fontWithName('Times-Roman', :size=>@font_size) 
       end
       
       if @atts[NSForegroundColorAttributeName].nil?
         if matts["BC"]
           @atts[NSForegroundColorAttributeName]= NSColor.blackColor 
         elsif matts["SMColor"]
           @atts[NSForegroundColorAttributeName]= color_from_string(matts["SMColor"]) if matts["SMColor"]
         else
           @atts[NSForegroundColorAttributeName]= NSColor.blackColor 
         end
       end
       #TODO what is the relation between 'Len','Unicode' and NSString
       # eventhough 'Len = 1', ns_string length is 0 and the range exception 
       # when I try to set the attributes  
       if att_string.string.length > 0
         att_string.setAttributes(@atts, range:range)
       end
       location+=len
      end
      att_string
    end
    
    def color_from_string(color_string)
      if color_string == nil
        return NSColor.whiteColor
      end

      if color_string==""
        return NSColor.whiteColor
      end

      if COLOR_NAMES.include?(color_string)
        return color_from_name(color_string)
      end

      if color_string =~ /^#/
        return color_from_hex(color_string)
      end
      # TODO
      # elsif color_string=~/^#   for hex color
      # RGB=
      ### RGB Colors
      #	"RGB=100,60,0" "RGB=100,60,0"
      # rgb(100,60,0)
      ### CMYK Colors
      #    "CMYK=100,60,0,20" 
      # cmyk(100,60,0,20)
      color_array=color_string.split("=")
      color_kind=color_array[0]
      color_values=color_array[1].split(",")
      if color_kind=~/RGB/
          @color = NSColor.colorWithCalibratedRed(color_values[0].to_f, green:color_values[1].to_f, blue:color_values[2].to_f, alpha:color_values[3].to_f)
      elsif color_kind=~/CMYK/
          @color = NSColor.colorWithDeviceCyan(color_values[0].to_f, magenta:color_values[1].to_f, yellow:color_values[2].to_f, black:color_values[3].to_f, alpha:color_values[4].to_f)
      elsif color_kind=~/NSCalibratedWhiteColorSpace/
          @color = NSColor.colorWithCalibratedWhite(color_values[0].to_f, alpha:color_values[1].to_f)
      elsif color_kind=~/NSCalibratedBlackColorSpace/
          @color = NSColor.colorWithCalibratedBlack(color_values[0].to_f, alpha:color_values[1].to_f)
      else
          @color = GraphicRecord.color_from_name(color_string)
      end
      @color
    end
    
    
  end
end