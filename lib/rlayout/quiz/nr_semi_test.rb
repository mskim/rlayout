
# QuizItemParts
# :num, :q, :m_choice, :choice_text, :choice_table, :image, :ans, :exp
# :ref_text

# Workflow
# There could be several different situations to work on Quiz chapter.
# One would be a situation where someone creates chapter text quiz_chapter.txt or quiz items could be editted individuall on the Rails app.
   
unless RUBY_ENGINE == "rubymotion"
  require 'strscan'
end

module RLayout
  
  class ENQuizItem < Container
    attr_reader :num, :q, :choice_text, :word_definition, :choice_table
    def initialize(options={})
      
      
      self
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
      @s = @buffer.rest
      if !(@s == "")
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
  end
  
	class NRSemiTestChapterMaker
    attr_accessor :project_path, :quiz_data, :layout_rb, :output_path
    attr_accessor :text_data, :title, :quiz_data
    def initialize(options={})
      if options[:project_path]
        @project_path = options[:project_path]
        @layout_rb    = @project_path + "/layout.rb"
        @text_data_path = Dir.glob("#{@project_path}/*.{yml,txt}").first
        unless File.exist?(@text_data_path)
          puts "@text_data;#{@text_data}"
          return
        end
      else
        puts "No project path !!!"
        return
      end
      template = File.open(@layout_rb,'r'){|f| f.read}
      @document = eval(template)
      if @document.is_a?(SyntaxError)
        puts "SyntaxError in #{@template_path} !!!!"
        return
      end
      
      read_quiz_items
      layout_quiz_items
      self
    end
    
    def read_quiz_items
      @text_data   = File.open(@text_data_path, 'r'){|f| f.read}  
      @quiz_data    = []
      blocks = @text_data.split("\n\n")
      # first parse title
      if blocks.first =~ /^=/
        @title = blocks.shift
      end
      blocks.each do |block|
        @quiz_data << ENQuizParser.new(block).quiz_hash
      end
    end
    
    def layout_quiz_items
      puts "@quiz_items.length:#{@quiz_items.length}"
      if @document.pages.length == 0
        options               = {}
        options[:footer]      = true
        options[:header]      = true
        options[:text_box]    = true
        options[:text_box_options]    = @layout_style[:text_box]
        options[:page_number] = @starting_page_number
        options[:parent]      = @document
        p=Page.new(options)
        p.relayout!
        p.main_box.create_column_grid_rects
      end
      page_index                = 0
      @first_page               = @document.pages[0]
      if heading = @first_page.get_heading?
        heading.set_heading_content(@heading)
      else
        # place heading at the front most
        @heading[:parent] = @first_page
        heading = Heading.new(@heading)
        @first_page.graphics.unshift(@first_page.graphics.pop)
      end
      @first_page.layout_space              = @main_layout_space
      @first_page.main_box.layout_length    = @text_box_layout_length
      @first_page.main_box.layout_space     = @column_gutter 
      @first_page.main_box.draw_gutter_stroke= @draw_gutter_stroke 
      @first_page.main_box.graphics.each{|col| col.layout_space = @column_layout_space}
      @first_page.relayout!
      @first_page.main_box.create_column_grid_rects
      @first_page.main_box.set_overlapping_grid_rect
      @first_page.main_box.layout_items(@quiz_items)
      if @document.pages[1]
        @second_page  = @document.pages[1] 
        @second_page.layout_space              = @main_layout_space
        @second_page.main_box.layout_length    = @text_box_layout_length
        @second_page.main_box.layout_space     = @column_gutter 
        @second_page.main_box.draw_gutter_stroke= @draw_gutter_stroke 
        @second_page.main_box.graphics.each{|col| col.layout_space = @column_layout_space}
        @second_page.relayout!
        @second_page.main_box.create_column_grid_rects
        @second_page.main_box.set_overlapping_grid_rect      
      end
      page_index = 1
      while @quiz_items.length > 0
        if page_index >= @document.pages.length
          options               = {}
          options[:footer]      = true
          options[:header]      = true
          options[:text_box]    = true
          options[:text_box_options]    = @layout_style[:text_box]
          options[:page_number] = @starting_page_number + page_index
          options[:parent]      = @document
          p=Page.new(options)
          p.relayout!
          p.main_box.create_column_grid_rects
        end
        @document.pages[page_index].relayout!
        @document.pages[page_index].main_box.layout_items(@quiz_items)
        page_index += 1
      end
      
      # add answer page
      if @answer_page
        page_index = @document.pages.length + 1
        options               = {}
        options[:footer]      = true
        options[:header]      = true
        options[:text_box]    = true
        options[:text_box_options]    = @layout_style[:text_box]
        options[:text_box_options][:column_count] = 4
        options[:page_number] = @starting_page_number + page_index
        options[:parent]      = @document
        p = Page.new(options)
        p.relayout!
        p.main_box.create_column_grid_rects
        answer_heading = {}
        answer_heading[:title] = "Answers"
        answer_heading[:parent] = p
        heading = Heading.new(answer_heading)
        p.graphics.unshift(p.graphics.pop)
        p.relayout!
        p.main_box.create_column_grid_rects
        p.main_box.layout_items(@answer_item)
        while @answer_item.length > 0
          if page_index > @document.pages.length
            options               = {}
            options[:footer]      = true
            options[:header]      = true
            options[:text_box]    = true
            options[:text_box_options]    = @layout_style[:text_box]
            options[:text_box_options][:column_count] = 4
            options[:page_number] = @starting_page_number + page_index
            options[:parent]      = @document
            p=Page.new(options)
            p.relayout!
            p.main_box.create_column_grid_rects
          end
          @document.pages.last.relayout!
          @document.pages.last.main_box.layout_items(@answer_item)
          page_index += 1
        end        
      end
      update_header_and_footer
    end
    
    def update_header_and_footer
      header= {}
      header[:first_page_text]  = "| #{@book_title} |" if @book_title
      header[:left_page_text]   = "| #{@book_title} |" if @book_title
      header[:right_page_text]  = @title if @title
      footer= {}
      footer[:first_page_text]  = @book_title if @book_title
      footer[:left_page_text]   = @book_title if @book_title
      footer[:right_page_text]  = @title if @title
      options = {
        :header => header,
        :footer => footer,
      }
      @document.header_rule = header_rule
      @document.footer_rule = footer_rule
      @document.pages.each {|page| page.update_header_and_footer(options)}
    end
    
    def header_rule
      {:first_page_only   => true,
        :left_page        => false,
        :right_page       => false,
      }
    end

    def footer_rule
      h ={}
      h[:first_page]      = true
      h[:left_page]       = true
      h[:right_page]      = true
      h
    end    
	end
end

__END__
text =<<EOF

== Semi Test 3

001	(A), (B), (C)의 각 네모 안에서 어법에 맞는 표현으로 가장 적절한 것은? 
When plants were first grouped together, it was merely for convenience. Even today, plants may be categorized together in unnatural groupings in order to make (A)  easier to identify. For example, some wildflower books arrange together all white-flowered species or all yellow-flowered species. However, such groupings do not reflect natural relationships and make (B)  difficult to recognize family characteristics. We don’t infer that all persons with red hair are more closely related to each other than they are to (C)  with dark hair; likewise, all long-haired dogs are not more closely related to each other than they are to short-haired dogs. Modern botanists, therefore, try to group plants according to their natural relationships.
*botanist: 식물학자
	(A)	(B)	(C)
① it   	······   it   	······   that
② it   	······   it   	······   those
③ it   	······   this   ······   that
④ them   ······   this   ······   those
⑤ them   ······   it   	······   those

002	다음 글의 밑줄 친 부분 중, 어법상 틀린 것은?
It is natural to experience phases ① where you have the desire to eat more than normal. However, binge eating is different as it causes people to habitually consume abnormally large amounts of food and ② keep eating even after they feel full. Consequently, they take in more calories than necessary, becoming overweight or even obese, and feeling bad about ③ themselves. When a person suffers from binge eating, it is emotional issues that are generally at the root of the problem. Some ④ find soothing to eat when they feel stressed, hurt, or angry, though afterwards they are plagued by guilt and sadness. However, in most cases, binge eaters are not aware of ⑤ what drives them to overeat.
*binge eating: 폭식

003	(A), (B), (C)의 각 네모 안에서 어법에 맞는 표현으로 가장 적절한 것은? 
So often, we get caught up in the minutiae of our jobs — tedious annoyances and struggles that may be temporary roadblocks but feel more like concrete mountains. While there’s plenty of research that shows that people who work with the muscles above their neck (A)  all kinds of stresses for themselves, it’s the people who focus on the why of their jobs (as opposed to the what and the how) (B)  can manage the day-to-day problems more easily. That is, if you can define the purpose of your career or feel passionate about the mission of your company, you can much more easily handle the occasional server maintenance that (C)  your in box. The flip side is that if you’re working in any area (or company) that doesn’t align with your own value, all the little stuff snowballs into a big ball of daily disasters.
*minutiae: 상세, 세목, 사소한 점 
	(A)	(B)	(C)
① creates   ······   which   ······   disrupts
② creates   ······   who   	······   disrupt
③ create   	······   which   ······   disrupt
④ create   	······   who   	······   disrupt
⑤ create   	······   who   	······   disrupts

004	다음 글의 밑줄 친 부분 중, 어법상 틀린 것은? 
Ancient Greek and Roman costume is essentially draped, and presents a traditional stability and permanence. While it received certain fashions over the centuries, it never underwent any major transformation. Léon Heuzey, the pioneer of the study of classical costume, ① set forth with exemplary clarity its two basic principles: the first is that Classical costume has no form in itself, as it ② consisted of a simple rectangular piece of cloth woven in varying sizes according to ③ their intended use and the height of the customer, without differentiation between the sexes; the second is that this cloth is always draped, never shaped or cut, and ④ was worn round the body in accordance with definite rules. Thus it was always fluid and ‘live.’ It is notable ⑤ that we find no evidence in Classical times of tailors or dressmakers: the word itself barely exists in Greek or Latin.
*drape: 주름을 잡아 걸치다

EOF

# RLayout::NRSemiTestChapterMaker.new(text_data: text)