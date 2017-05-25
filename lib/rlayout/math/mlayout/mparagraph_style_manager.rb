
module  RLayout
  
  class MParagraphStyle
    attr_accessor :atts, :fontName, :fontSize
    
    def initialize(hash)
      @atts=hash
      self
    end
    
    def style_name
      @atts["styleName"]
    end
    
    def font
      @atts[NSFontAttributeName]
    end

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
    
    # create attribute hash from MLayout style dictionary
    def self.atts_from_mstyle(hash)
      @atts={}
      
      if hash["StyleName"] 
        @atts["styleName"]=hash["StyleName"] 
      elsif hash["USN"] 
        @atts["styleName"] = NSString.alloc.initWithData(hash["USN"] , encoding:NSUnicodeStringEncoding)
      end
        
      if hash['CharStyle']
        fontName= hash['CharStyle']['FontName']
        fontSize= hash['CharStyle']['FontSize'].to_f
        @atts[NSFontAttributeName]= NSFont.fontWithName(fontName, :size=>fontSize) 
        
        # hash['Plain']= hash['CharStyle']['Plain']
        @atts[NSForegroundColorAttributeName] = color_from_hash(hash['CharStyle']['NSColor']) if hash['CharStyle']['NSColor']
        @atts[NSKernAttributeName] = hash['CharStyle']['Track'].to_f*fontSize/160 if hash['CharStyle']['Track']
        if hash['CharStyle']['FontScale']
          font_scale=hash['CharStyle']['FontScale'].to_f
          unless font_scale == 100.0
            width=fontSize*font_scale/100
            fmatrix=[width,0,0,fontSize,0,0]
            @atts[NSFontAttributeName] = NSFont.fontWithName(fontName, matrix:fmatrix)
            
          end
        end
        
        
      end
      
      
      if hash['fontName']
        fontName=hash['fontName'] 
        fontSize=hash['fontSize'].to_f if hash['fontSize']
        @atts[NSFontAttributeName]= NSFont.fontWithName(fontName, :size=>fontSize)
        @atts[NSKernAttributeName] = hash['Track'].to_f*fontSize/160 if hash['Track']
        if hash['FontScale']
          font_scale=hash['FontScale'].to_f
          unless font_scale == 100.0
            puts "we have scaled font, font_scale is :#{font_scale}"
            width=fontSize*font_scale/100
            puts "font_width:#{width}"
            fmatrix=[width,0,0,fontSize,0,0]
            @atts[NSFontAttributeName] = NSFont.fontWithName(fontName, matrix:fmatrix)
          
          end
        end
      end
      # @atts[NSFontAttributeName] = NSFont.fontWithName(fontName, size:fontSize)
      @atts[NSBaselineOffsetAttributeName]=hash['LockToBaselineGrid'] if hash['LockToBaselineGrid']
      # TO DO  
      #  @atts[NSUnderlineStyleAttributeName] = hash['Underline'] if hash['Underline']
      #  @atts[NSSuperscriptAttributeName] = hash['Superscript'] if hash['Superscript']
      #  @atts[NSBackgroundColorAttributeName] = hash['BackgroundColor'] if hash['BackgroundColor']
      #  @atts[NSAttachmentAttributeName] = hash['Attachment'] if hash['Attachment']
      #  @atts[NSLigatureAttributeName] = hash['Ligature'] if hash['Ligature']
      #  @atts[NSLinkAttributeName] = hash['Link'] if hash['Link']
      #  @atts[NSStrokeWidthAttributeName] = hash['StrokeWidth'] if hash['StrokeWidth']
      #  @atts[NSStrokeColorAttributeName] = hash['StrokeColor'] if hash['StrokeColor']
      #  @atts[NSUnderlineColorAttributeName] = hash['UnderlineColor'] if hash['UnderlineColor']
      #  @atts[NSStrikethroughStyleAttributeName] = hash['StrikethroughStyle'] if hash['StrikethroughStyle']
      #  @atts[NSStrikethroughColorAttributeName] = hash['StrikethroughColor'] if hash['StrikethroughColor']
      #  @atts[NSShadowAttributeName] = hash['Shadow'] if hash['Shadow']
      #  @atts[NSObliquenessAttributeName] = hash['Obliqueness'] if hash['Obliqueness']
      #  @atts[NSExpansionAttributeName] = hash['Expansion'] if hash['Expansion']
      #  @atts[NSCursorAttributeName] = hash['Cursor'] if hash['Cursor']
      #  @atts[NSToolTipAttributeName] = hash['ToolTip'] if hash['ToolTip']
      #  @atts[NSMarkedClauseSegmentAttributeName] = hash['MarkedClauseSegment'] if hash['MarkedClauseSegment']
      
      
      aStyle=NSParagraphStyle.defaultParagraphStyle
      ns_paragraph=NSMutableParagraphStyle.alloc.init
      ns_paragraph.setParagraphStyle(aStyle)
      ns_paragraph.setAlignment(0)
      ns_paragraph.setAlignment(hash['Alignment'].to_i) if hash['Alignment']
      ns_paragraph.setLineBreakMode(NSLineBreakByWordWrapping)
      ns_paragraph.setLineSpacing(hash['LineSpacing'].to_f) if hash['LineSpacing']
      
      if hash['NSParagraphStyle']
        ns_paragraph.setAlignment(hash['NSParagraphStyle']['Alignment']) if hash['NSParagraphStyle']['Alignment']
        ns_paragraph.setLineBreakMode(hash['NSParagraphStyle']['BreakByWord']) if hash['BreakByWord']
        ns_paragraph.setLineSpacing(hash['NSParagraphStyle']['LineSpacing'].to_f) if hash['LineSpacing']
        
      end
      
      # To do
      # BreakByWord
      # LockToBaselineGrid
      # Hyphenation
      # – setFirstLineHeadIndent:
      # – setHeadIndent:
      # – setTailIndent:
      # – setMaximumLineHeight:
      # – setMinimumLineHeight:
      # – setParagraphSpacing:
      # – setBaseWritingDirection:
      # – setLineHeightMultiple:
      # – setParagraphSpacingBefore:
      # – setDefaultTabInterval:
      @atts[NSParagraphStyleAttributeName] = ns_paragraph
      @atts
    end
    
    # create SMParaphStyle from MLayout style dictionary
    def self.para_style_from_mstyle(hash)
      atts=atts_from_mstyle(hash)
      MParagraphStyle.new(atts)
    end
    
    def to_hash
      # we need to flatten font, paragraph, color and other objects 
      style_atts={}
      
      return 
    end
        
    def convert_to_smstyle
      
    end
    

  end
  
  class MParagraphStyleManager
    attr_accessor :paragraph_styles
    def initialize(paragraph_styles)
      @paragraph_styles=paragraph_styles
      self
    end
    
    def self.mparagraph_style_manager_from_m_sytle_dictiionay(styles_dictionary)
      paragraph_styles=[]
      styles_dictionary.each do |paragraph_dictionary|
        paragraph_styles << MParagraphStyle.para_style_from_mstyle(paragraph_dictionary)
      end       
      MParagraphStyleManager.new(paragraph_styles)
    end
    
    def self.smparagraph_style_manager_from_m_sytle_file(path)
      paragraph_styles_dictionary=mdictionary=NSDictionary.dictionaryWithContentsOfFile(path)
      styles_dictionary=paragraph_styles_dictionary['ParagraphStyle']
      mparagraph_style_manager_from_m_sytle_dictiionay(styles_dictionary)
    end
    
    def to_hash
      paragraph_styles_list=[]
      @paragraph_styles.each do |style|
        paragraph_styles<< style_object.to_hash
      end
      paragraph_styles_list
    end
    
    def self.from_hash(paragraph_styles)
      MParagraphStyleManager.new(paragraph_styles)
    end
    
    def find_style_named(name)
      @paragraph_styles.each do |style_object|
        return fonund_style=style_object if style_object.style_name==name
      end
      nil
    end
    
    def atts_for_style_named(name)
      if style=find_style_named(name)
        return style.atts
      end
      nil
    end
    
    
    def to_hash
      
    end
    
    def defaults
      
    end
  end
end

__END__

require 'minitest/autorun'
require 'smpage'

include MLayout
describe "create MParagraphStyle object" do
  before do
    @atts={}
    @atts[NSFontAttributeName] = NSFont.fontWithName("Helvetica", size:12)
    @atts["styleName"] = "TestStyle"
    
    @para=MParagraphStyle.new(@atts)
  end
  
  it 'should create MParagraphStyle object' do
    assert_kind_of(MParagraphStyle,@para)
  end
  
  it 'should return name ' do
    assert_equal(@para.style_name, "TestStyle")
  end
  
  it 'should return atts ' do
    assert_kind_of(Hash, @para.atts)
    assert_kind_of(NSFont, @para.font)
    assert_equal("TestStyle", @para.style_name)
  end
end

describe 'should read current mlayout style_list ' do
  before do
    @path="/Users/Shared/Softmagic/M/Style/English.style"
    @styles_manager=MParagraphStyleManager.smparagraph_style_manager_from_m_sytle_file(@path)
  end
  it 'should create MParagraphStyleManager' do
    assert_kind_of(MParagraphStyleManager, @styles_manager)
  end
  it 'should have paragraph_styles' do
    assert_kind_of(Array, @styles_manager.paragraph_styles)
  end
  it 'should have paragraph_style lists' do
    assert_kind_of(MParagraphStyle, @styles_manager.paragraph_styles.first)
  end
end


describe 'Set text for SMTextBox' do
  before do
    @path="/Users/Shared/Softmagic/M/Style/card.style"
    @styles_manager=MParagraphStyleManager.smparagraph_style_manager_from_m_sytle_file(@path)
    
    @frame=NSRect.new(NSPoint.new(20,20), NSSize.new(550,100))
    @page=SMPage.new
    @path=(File.dirname(__FILE__) +'/test/pdf/para_style_test.pdf')
  end
  
  
  it 'should create a SMTextBox class' do
    y=10
    @styles_manager.paragraph_styles.each do |style|
      @frame=NSRect.new(NSPoint.new(20,y), NSSize.new(550,100))
      @textbox2=SMTextBox.new(frame:@frame, columns:1)
      string="style.style_name: #{style.style_name} "*10
      attString = NSAttributedString.alloc.initWithString string, attributes:style.atts
      
      @textbox2.set_content(ns_attributed_string:attString)
      @page.add_graphic(@textbox2)
      y+=80
    end
    @page.save_pdf(@path)
    assert(File.exists?(@path))
    system("open #{@path}")
  end
    
end
