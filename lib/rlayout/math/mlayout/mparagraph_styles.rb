
module RLayout
  class MCharStyle
    attr_accessor :dictionary, :char_styles, :atts
    
    def initialize(dictionary)
      @dictionary=dictionary
      @atts={}
      @fontName=@dictionary["FontName"]
      @fontSize=@dictionary["FontSize"]
      @atts[NSFontAttributeName]= NSFont.fontWithName(@fontName, :size=>@fontSize) if (@dictionary["FontName"] && @dictionary["FontSize"])
      if @dictionary["NSColor"]
        @atts[NSForegroundColorAttributeName]=color_from_hash(@dictionary["NSColor"]) 
      else
        @atts[NSForegroundColorAttributeName]=NSColor.blackColor
      end
      
      if @dictionary["Track"]
        atts[NSKernAttributeName]=@dictionary["Track"].to_f*@fontSize/160
        puts "atts[NSKernAttributeName]:#{atts[NSKernAttributeName]}"
        
      end
      # atts[NSLigatureAttributeName]=
      # atts[NSAttachmentAttributeName]=
      # 
      # 
      # atts[NSBackgroundColorAttributeName]=
      # atts[NSBaselineOffsetAttributeName]=
      # atts[NSLinkAttributeName]=
      # atts[NSParagraphStyleAttributeName]=
      # atts[NSUnderlineStyleAttributeName]=
      # atts[NSSuperscriptAttributeName]=
      # 
      # puts @dictionary
      # @dictionary.keys
      self
    end
    
  end
  

  class MParagraphStyle
    attr_accessor :dictionary, :style_name, :atts

    def initialize(dictionary)
      # puts "dictionary:#{dictionary}"
      @dictionary=dictionary
      @paragraph_style_hash={}
      @atts=atts
      @style_name=@dictionary['StyleName']
      # puts "style_name:#{@style_name}"  
      self
    end
    
    def atts
      MCharStyle.new(@dictionary['CharStyle']).atts
    end
    # returns attrubuts hash of paragraph style from MLayout file    
    def self.atts_of_style_named_from_mlayout_file(path, style_name:para_style_name)
      styles=MParagraphStyle.read_paragraph_styles_of_mlayout_file(path)
      styles.each do |style|
          return MParagraphStyle.new(style).atts 
      end
      return atts={}
    end
    
    # read and returns paragraph styles hash from MLayout file    
    def self.read_paragraph_styles_of_mlayout_file(path)
      mdictionary_path=path + '/m.layout'
      mdictionary=NSDictionary.dictionaryWithContentsOfFile(mdictionary_path)
      paragraph_styles=mdictionary['ParagraphStyle']
    end
    
     
    # read and returns paragraph styles hash from /users/Shared/Softmagic/M/Style/    
    def self.read_paragraph_styles_from_shared_user(path)
      mdictionary_path=path
      mdictionary=NSDictionary.dictionaryWithContentsOfFile(mdictionary_path)
      paragraph_styles=mdictionary['ParagraphStyle']
    end
           
  end
end  
