module RLayout

#  illegular shaped text flow
#  each Container Object implements "overlapping_graphics"
#  "overlapping_graphics" finds "Graphic/Container objects" that are sitting on top of current textContainer
#  It is done by asking each @parent_graphics up to the Page for list of overlapping graphics that are sitting on top(by @graphics index as z-depth)
#  Only the overlapping graphics are set as "push content underneath" mode are considersed,  
#  overlapping graphics that are "jsut floating" do not affect the text flow.
#  after collecting overlapping graphics, change the textContainer to flow text avoiding othose graphics.

# FIT_FONT_SIZE   = 0   # keep given font size
# FIT_TO_BOX      = 1   # change font size to fit text into box 
# FIT_EACH_LINE   = 2   # adjust font size for each line to fit text into lines.
#                       # So, fewer the text, larger the font size becomes in for each line
#                       # And reduce the size of the lines propotionally to fit the entire lines in text box.
                      
FIT_STYLE_RUN   = 3
MININUM_LINES_FOR_SPLIT = 2

  class Paragraph < Text
    attr_accessor  :linked
    def initialize(parent_graphic, options={})
      text_options = nil
      if options[:markup]
        @current_style = DEFAULT_STYLES
        if options[:current_style]
          @current_style = options[:current_style] 
        end
        text_options = @current_style[options[:markup]]
        text_options[:text_markup] = options[:markup]        
        options.merge! text_options if text_options
      end
      # options[:line_width] = 2
      # options[:line_color] = 'red'
      if options[:drop_cap]
      end
      options[:text_fit_type] = 0
      super
      @klass = "Paragraph"
      self
    end
    
    def isFlipped
      true
    end
    
    def text_line_height
      @text_layout_manager.text_line_height 
    end
    
    def text_string
      @text_layout_manager.att_string.string
    end
    
    def text_markup
      @text_layout_manager.text_markup      
    end
    
    def overflow?
      @text_layout_manager.text_overflow
    end
        
    def underflow?
      @text_layout_manager.text_underflow
    end
    
    # split paragraph into two, second paragraph with overflowing lines
    # return second paragraph
    def split_overflowing_lines
      return @text_layout_manager.split_overflowing_lines
    end
    
    # split item at given posiotion
    def split_at(position)
      return @text_layout_manager.split_at(position)
    end
        
    def layout_text(layout_options)
      return unless @text_layout_manager
      # options={:proposed_width=>width}
      @text_layout_manager.layout_ct_lines(layout_options)
    end
    
    def overlapping_graphics
      []
    end
    
    def adjust_height
      @graphics.first.adjust_height
    end
    
    def self.generate(number)
      para_array = []
      number.times do 
        para_data = ParagraphModel.body(5)
        para_array << Paragraph.new(nil, :para_data=>para_data)
      end
      para_array
    end
  end
    
  
  class ParagraphModel
    attr_accessor :markup, :string 
    # attr_accessor :x,:y,:width, :height
    attr_accessor :footnote, :index
    
    def initialize(options={})
      @string   = options.fetch(:string, "")
      @markup   = options.fetch(:markup, "p")
      self
    end
        
    def self.from_string(string,options={})
      options[:string =>string]
      ParagraphModel.new(options)
    end
    
    def self.from_para_data(array)
      options = {:markup=>array[0], :string=>array[1]}
      options[:foot_note]=array[2] if array.length > 2
      ParagraphModel.new(options)
    end
    
    def self.sample_text(count=10)
      Lorem::Base.new('words',count).output
    end
    
    def self.title
      {:string=>ParagraphModel.sample_text(6), :markup=>"title" }
    end
    
    def self.subtitle
      {:string=>ParagraphModel.sample_text(10), :markup=>"subtitle" }
    end
    
    def self.author
      {:string=>ParagraphModel.sample_text(2), :markup=>"author" }
    end
    
    def self.leading
      {:string=>ParagraphModel.sample_text(20), :markup=>"leading" }
    end
    
    def self.head(count = 20)
      {:string=>ParagraphModel.sample_text(count), :markup=>"head" }
    end
    
    def self.subhead(count = 20)
      {:string=>ParagraphModel.sample_text(count), :markup=>"subhead" }
    end
    
    def self.body(count = 20)
      {:string=>ParagraphModel.sample_text(count), :markup=>"p" }
    end
    
    def self.heading
      heading = {}
      heading[:title]     = ParagraphModel.sample_text(6)
      heading[:subtitle]  = ParagraphModel.sample_text(10)
      heading[:author]    = ParagraphModel.sample_text(3)
      heading
    end
    
    def self.news_article_heading
      heading = {}
      heading[:title]     = ParagraphModel.sample_text(6)
      heading[:author]    = ParagraphModel.sample_text(3)
      heading
      
    end
    
    def self.heading_with_leading
      heading = {}
      heading[:title]     = ParagraphModel.title
      heading[:subtitle]  = ParagraphModel.subtitle
      heading[:leading]   = ParagraphModel.leading
      heading[:author]    = ParagraphModel.author
      heading[:title]     = ParagraphModel.sample_text(6)
      heading[:subtitle]  = ParagraphModel.sample_text(10)
      heading[:leading]   = ParagraphModel.sample_text(20)
      heading[:author]    = ParagraphModel.sample_text(3)
      heading
    end
    
    def self.body_part(count)
      paragraphs = []
      count.times do
        paragraphs << ParagraphModel.head
        Random.new.rand(2..6).times do
          paragraphs << ParagraphModel.body
        end
      end
      paragraphs
    end
    
    def to_hash
      h = {}
      h[:string] = @string
      h[:markup] = @markup
      h[:footnote] = @footnote if @footnote
      h
    end
    
    def to_para_data
      a= [@markup,@string]
      a << @footnote if @footnote
      a
    end
    
    def mark
      case @markup
      when 'p'
        mark=''
      when 'title'
        mark='#'
      when 'subtitle'
        mark='##'
      when 'author'
        mark='###'
      when 'leading'
        mark='####'
      when 'head'
        mark='#####'
      when 'subhead'
        mark='######'
      else
        mark=''
      end
    end
    
    def to_markdown
      "#{mark} #{string}\n"
    end
    
    def is_heading_kind?
      HEADING_KINDinclude?(@markup)
    end
  
    def to_html
<<EOF
  <div class=#{@markup} id=#{@order}>
    #{@string}
  </div>
EOF
    end
  end

end