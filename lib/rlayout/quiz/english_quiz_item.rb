ChoiceTextSample = "This is an English quiz sample text with embeded multiple cholice answers with in the text."

TableSample =<<EOF
[table]
(A)       |(B)  |(C)
1.observe |one   |three
1.observe |one   |three
1.observe |one   |three
1.observe |one   |three
EOF

module RLayout
  # Paragraph with number in fornt.
  class NumberParagraph < Container
    attr_accessor :num_object, :q_object
    def initialize(options={}, &block)
      super
      @layout_direction = "horizontal"
      @layout_expand    = :width
      number_options    = $quiz_item_style[:num_style].dup
      @num_object       = text(options[:num].to_s.rjust(3,"0"), number_options) 
      q_options         = $quiz_item_style[:q_style].dup
      @q_object         = text(options[:q], q_options)
      relayout!  
      @height           = @q_object.height + 4  
      self
    end
    
  end
  
  class EnglishQuizItem < Container
    attr_accessor :q_line, :choice_text_object, :table_object, :quiz_width
    attr_accessor :data, :processed, :type # multiple choice, inline_choice
    def initialize(options={}, &block)
      @processed              = false
      @data                   = {}
      @data[:delayed_layout]  = true
      # @data[:num]             = options.fetch(:num, "001")
      # @data[:q]               = options.fetch(:q, "Some question goes here? ")
      # @data[:choice_text]     = options.fetch(:choice_text, ChoiceTextSample)
      # @data[:choice_text]     = options.fetch(:choice_text)
      @data[:layout_expand]   = [:width]
      @layout_space           = 2
      @layout_expand          = options.fetch(:layout_expand,[:width])
      super
      # todo why @width value changes to 100 in super
      @width                  = options[:quiz_width] if options[:quiz_width]
      self
    end
    
    def set_quiz_content(options={})
      options = Hash[options.map{ |k, v| [k.to_sym, v] }]
      @data[:num]     = options.fetch(:num, "021")
      @data[:q]       = options.fetch(:q, "Some question goes here? ")
      @data[:choice_text] = options.fetch(:choice_text, ChoiceTextSample)
      @data[:choice_table]= options.fetch(:choice_table, nil)
      @layout_space   = $quiz_item_style[:layout_space] || 10
      @q_line         = NumberParagraph.new(parent: self, width: @width, num: @data[:num], q: @data[:q])
      if @data[:choice_text]
        choice_text_style         = $quiz_item_style[:choice_style].dup
        choice_text_style[:width] = @width
        @choice_text_object       = text(@data[:choice_text], choice_text_style)        
      end
      if data[:choice_table]
        @table_object       = RLayout::SimpleTable.new(parent:self, width: @width, csv: @data[:choice_table])
      end
      
      height_sum = 0   
      if @q_line
        height_sum +=@q_line.height
        height_sum += @layout_space
      end
      
      if @choice_text_object
        height_sum +=@choice_text_object.height
        height_sum += @layout_space
      end
      
      if @table_object
        height_sum +=@table_object.height
        height_sum += @layout_space
      end
      
      @height = height_sum
      if @align_to_body_text
        mutiple           = (@height/body_height).to_i
        mutiple_height    = mutiple*body_height
        room              = mutiple_height - @height
        @top_inset        +=  room/2
        @bottom_inset     +=  room/2
        @height           = mutiple_height
      end
      relayout!     
      # @processed = true # prevent it from creating duplicates
      # @data[:q] = nil
      self
    end
    
    def to_hash
      super
    end
        
  end  
end
