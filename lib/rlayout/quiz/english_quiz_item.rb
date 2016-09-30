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
      @quiz_item_style = 
 RLayout::StyleService.shared_style_service.quiz_item_style
      @layout_direction = "horizontal"
      @layout_expand    = :width
      number_options    = @quiz_item_style[:num_style].dup
      @num_object       = text(options[:num].to_s.rjust(3,"0"), number_options) 
      q_options         = @quiz_item_style[:q_style].dup
      @q_object         = text(options[:q], q_options)
      relayout!  
      @height           = @q_object.height + 4  
      self
    end
    
  end
  
  class EnglishQuizItem < Container
    attr_accessor :q_line, :choice_text_object, :table_object, :quiz_width
    attr_accessor :content, :processed, :type, :overflow
    
    def initialize(options={}, &block)
      @content                  = ENQuizParser.new(options[:text_block]).quiz_hash
      @processed                = false
      @content[:delayed_layout] = true
      @content[:layout_expand]  = [:width]
      @layout_space             = 2
      @layout_expand            = options.fetch(:layout_expand,[:width])
      super
      # todo why @width value changes to 100 in super
      @width                  = options[:quiz_width] if options[:quiz_width]
      self
    end
    
    
    def layout_content(options={})
      @width          = options[:width] if options[:width]
      @quiz_item_style = 
 RLayout::StyleService.shared_style_service.quiz_item_style
      @layout_space   = @quiz_item_style[:layout_space] || 10
      @q_line         = NumberParagraph.new(parent: self, width: @width, num: @content[:num], q: @content[:q])
      if @content[:choice_text]
        choice_text_style         = @quiz_item_style[:choice_style].dup
        choice_text_style[:width] = @width
        @choice_text_object       = text(@content[:choice_text], choice_text_style)        
      end
      if @content[:choice_table]
        @table_object       = RLayout::SimpleTable.new(parent:self, width: @width, csv: @content[:choice_table])
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
      # @content[:q] = nil
      self
    end
    
    def overflow?
      @overflow == true
    end
    
    def is_breakable?
      false
    end
    
    def to_hash
      super
    end
        
  end  



  class ENQuizParser
    attr_reader :buffer, :quiz_hash
    def initialize(test_text)
      @buffer = StringScanner.new(test_text)
      @quiz_hash = {}
      parse
      self
    end

    def skip_spaces
      @buffer.skip(/\s+/)
    end

    def parse_question
      q_line = @buffer.scan_until(/\n/)
      @quiz_hash[:num]  = q_line.split("\t").first
      @quiz_hash[:q]    = q_line.split("\t")[1]
    end

    def parse_choice_text
      @quiz_hash[:choice_text] = @buffer.scan_until(/\n/)
    end

    def parse_word_definition
      if @buffer.peek(1) == "*"
        str = @buffer.scan_until(/\n/)
        @quiz_hash[:word_definition] = str
      end
    end

    def parse_choice_table
      return if @buffer.eos?
    table =<<EOF
.,(A),(B),(C)
1),this,is,one
2),they are,the second,two
3),this,is,three
4),this,is,four
EOF
      #TODO I am just using sample table data
      # since the data is not cosistent

      return @quiz_hash[:choice_table] = table
      @s = @buffer.rest
      if @s =~/^\t/
        @quiz_hash[:choice_table] = ENQuizParser.convert_tsv_to_csv(@s)
      elsif !(@s == "")
        @quiz_hash[:choice_table] = @s 
      end
    end

    def parse
      skip_spaces unless @buffer.bol?
      parse_question
      parse_choice_text
      parse_word_definition
      parse_choice_table
    end

    def self.convert_tsv_to_csv(text_block)
        # convert tab seperated values to csv text
      lines = text_block.split("\n")
      removed = []
      lines.each.with_index do |line, i|
        if i == 0
          line = line.gsub(/\t/, ",,")
          removed << line
        else
          #line = line.gsub(/······/, ",")
          line = line.gsub(/·+/, ",")
          line = line.gsub(/\W/, ",")
          line = line.gsub(/,+/, ",,")
          removed << line
        end    
      end
      removed.join("\n")
    end
  end

end
