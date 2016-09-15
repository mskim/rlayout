# encoding: utf-8

# QuizChapterMaker is tool chain for creating Quiz, Answer Sheet, and IncorrectAnswesNote.
# Quiz items are created unsing markdown with metadata.
# Each Question is marked as ## and separated by \n\n.
# Each choice is marked as ordered list.
# Correct Choice is marked as ###
# Explanation Answer is marked as <p>

# ---
# title: Mid-term English Quiz
# subject: English 101
# ---

#   ## What is not the correnct answer?
#   1. a
#   2. b
#   3. c
#   4. d
#   ### 4
#   The answer is 4 because it is the answer.
#
#   ## What is the correnct answer?
#   1. a
#   2. b
#   3. c
#   4. d
#   ### 2
#   The answer is 2 because it is the answer.
#

# They are parsed and auto numbers and layouted out as Quiz Sheet PDF with Heading.
# If @answer_page=true is passed, it also creates correct answer sheet page.

# IncorrectAnswersNoteMaker
# After quiz is taken,
# IncorrectAnswersNoteMaker is used to create IncorrectAnswersNote for students who took the quiz.
# This is ofen painstaking generated for each students.


# give option for text_layout_manager to adjust the text height
# Do the number

# @quiz_style = {
#   heading_space: 20,  
#   column_layout_space: 30, 
#   column_gutter: 10,  
#   column_gutter_line: true, 
#   
#   :num_style => {
#     q_num_type: "numeric",
#     font: 'Helvetica',
#     text_size: 20,
#     text_color: 'black',
#     chice_num_type: 'circled_alphabet' 
#   },
#   #number, alphaber, hangul_jaum,
#   #plain, circled, reverse_circled, 
#   :q_style => {    
#     font: 'Helvetica',
#     text_size: 20,
#     text_color: 'black',
#     text_alignment: 'left',
#     text_vertical_alignment: 'top',
#     text_fit_type: 'adjust_box_height',
#     text_head_indent: 20,
#     layout_expand: [:width],
#     space_after:10,
#   },
#   
#   :choice_style =>{
#     font: 'Times',
#     text_size: 16,
#     text_color: 'black',
#     text_head_indent: 16,
#     text_alignment: 'left',
#     text_vertical_alignment: 'top',
#     text_fit_type: 'adjust_box_height',
#     stroke_sides: [0,0,0,0],
#     layout_expand: [:width],
#     space_after: 10,
#     gutter: 5,
#   },
# }
# options = {}
# options[:paper_size]      = "A3"
# options[:page_count]      = 2
# options[:footer]          = true
# options[:header]          = true
# options[:text_box]        = true
# options[:column_count]    = 2
# options[:current_style]   = current_tyle
# RLayout::Document.new(options)

# Math questions, 
# 1. Need lots of room to write down while solving.
# 1. choice is open in one single line, they are shourt and can get to 5 choices.
# 1. It is usually two questions per page, with lots of room for writting.

module RLayout
  
  # QuizChapterMaker
  class QuizChapterMaker
    attr_accessor :project_path, :template_path, :quiz_data_path, :answer_page
    attr_accessor :document, :output_path, :starting_page_number, :column_count
    attr_accessor :layout_style
    def initialize(options={} ,&block)
      if options[:project_path]
        @project_path   = options[:project_path]
        puts Dir.glob("#{@project_path}/*.txt")
        @quiz_data_path = Dir.glob("#{@project_path}/*.{md,adoc,yml}").first
      elsif options[:quiz_data_path]
        @quiz_data_path = options[:quiz_data_path]
        @project_path   = File.dirname(@quiz_data_path)
      else
        puts "No quiz_data_path given !!!"
        return
      end
      $ProjectPath    = @project_path
      unless File.exist?(@quiz_data_path)
        puts "quiz_data_path doen't exist !!!"
        return
      end
      if options[:output_path]
        @output_path  = options[:output_path]
      else
        @output_path  = @project_path + "/output.pdf"
      end
      if options[:template_path]
        if File.exist?(options[:template_path])
          @template_path = options[:template_path]
        else
          puts "Template #{options[:template_path]} doesn't exist!!!"
          return
        end
      else
        @template_path = Dir.glob("#{@project_path}/*.rb").first
        unless @template_path
          @template_path = options.fetch(:template_path, "/Users/Shared/SoftwareLab/article_template/quiz.rb")
        end
      end
      template = File.open(@template_path,'r'){|f| f.read}
      @document = eval(template)
      if @document.is_a?(SyntaxError)
        puts "SyntaxError in #{@template_path} !!!!"
        return
      end
      # raise "SyntaxError in #{@template_path} !!!!" if @document.is_a?(SyntaxError)
      unless @document.kind_of?(RLayout::Document)
        puts "Not a @document kind created !!!"
        return
      end
      if @quiz_item_style.class == Array
        $quiz_item_style      = @quiz_item_style[0]
      else
        $quiz_item_style      = @quiz_item_style
      end
      $layout_style         = @layout_style
      @starting_page_number = options.fetch(:starting_page_number,1)
      read_quiz_items
      layout_quiz_items 
      output_options = {:preview=>true}
      @document.save_pdf(@output_path, output_options)
      self
    end
        
    def read_quiz_items
      puts __method__
      @quiz_hash  = read_metadata
      @heading    = @quiz_hash[:heading] || {}
      @title      = @heading[:title] || "Untitled"
      @answer_page= @heading["answer_page"] if @heading["answer_page"]
      @heading              = @heading.merge!(@layout_style[:heading])
      @main_layout_space    = @layout_style[:heading][:heading_space_after] || 20
      @column_count         = @layout_style[:text_box][:column_count] || 2
      @column_gutter        = @layout_style[:text_box][:column_gutter] || 10
      @column_layout_space  = @layout_style[:text_box][:column_layout_space] || 10
      @draw_gutter_stroke   = @layout_style[:text_box][:draw_gutter_stroke] || false
      @text_box_layout_length=@layout_style[:text_box][:layout_length] || 8
      @quiz_items           = @quiz_hash[:quiz_items]
    end
    
    # quiz item in markdown 
    def parse_quiz_markdown(lines_block)
      
    end
    
    # quiz item in asciidoctor 
    def parse_quiz_adoc(lines_block)
      
    end
    
    # quiz item in yml 
    def parse_quiz_yml(lines_block)
      # TODO this need to be changed to markdown parsing
      block_text = lines_block.join("\n")
      if block_text =~/t:/   # this is for reading text
        lines_block_text = block_text.sub("t: ","")
        @item_array << QuizRefText.new(markup: "body", text_string: lines_block_text, stroke_width: 1, no_layout: true)
      else
        yaml = YAML::load(block_text)
        q    = yaml['q']
        yaml['q'] = "#{@q_index+1}. " + q if q
        @answer_item <<  QuizAnsText.new(markup: "p", text_string: "#{@q_index + 1}). #{yaml.delete("ans").to_s}   \r\nExplanation: \r\n#{yaml.delete('exp')}", no_layout: true)
        @item_array << QuizItem.new(yaml)
        @q_index += 1
      end
    end
    
    
    # quiz item in yaml 
    def parse_quiz_data(content, type)
      puts __method__
      @item_array   = []
      @answer_item  = []
      reader        = RLayout::Reader.new content, nil      
      @q_index      = 0
      reader.text_blocks.each do |lines_block|
        parse_quiz_yml(lines_block)
        
        # case type
        # when 'md','markdown'
        #   parse_quiz_markdown(lines_block)
        # when 'adoc'
        #   parse_quiz_adoc(lines_block)
        # when 'yml'
        #   parse_quiz_yml(lines_block)
        # else
        #   parse_quiz_adoc(lines_block)
        # end
      end
      @item_array
    end
    
    def read_metadata
      puts __method__
      source = File.open(@quiz_data_path, 'r'){|f| f.read}
      begin
         if (md = source.match(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m))
           @contents = md.post_match
           @metadata = YAML.load(md.to_s)
         else
           @contents = source
         end
      rescue => e
         puts "YAML Exception reading #filename: #{e.message}"
      end
      if @metadata
        if @metadata.class == Array
          @metadata = @metadata[0]
        end
      end
      h = {}
      h[:heading]     = @metadata if @metadata
      #TODO
      h[:quiz_items]  = parse_quiz_data(@contents, "md")
      # h[:quiz_items]  = parse_quiz_data(@contents, File.extname(@quiz_data_path))
      h
    end
    
    def layout_quiz_items
      puts __method__
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
  
  class QuizAnsText < Text
    def initialize(options={})
      options[:text_fit_type] = 'adjust_box_height'
      options[:layout_expand] = [:width]
      super 
      self
    end
    
    def set_content
      @text_layout_manager.layout_lines(text_fit_type: 'adjust_box_height') if @text_layout_manager
      self
    end
    
  end
  
  class QuizRefText < Text
    def initialize(options={})
      options[:layout_expand] = [:width]
      super 
      self
    end
    
    def set_content
      @text_layout_manager.layout_lines(text_fit_type: 'adjust_box_height') if @text_layout_manager
      self
    end
  end
  
  # number type, style
  # 1. number
  # a. alphbet
  
  # choice type 
  # 1. number
  # a. alphbet
  # 넉. hangul-jaum
  # a. alphbet
  # choice style
  #  1. , circle, ( )
  
  # this is default QuizItem with question and miltiple choice answers
  class QuizItem < Container
    attr_accessor :q_object, :row1_object, :row2_object
    attr_accessor :img_object, :data, :processed, :type # multiple choice, inline_choice
    def initialize(options={}, &block)
      @processed = false
      @data = {}
      @data[:delayed_layout] = true
      @data[:num] = options.fetch('number', "1")
      @data[:q]   = options.fetch('q', {text_string: "Some question goes here? "})
      @data[:img] = options.fetch('img', nil)
      @data[:cap] = options.fetch('cap', nil)  
      @choice_1   = options.fetch(1, "choice1")
      @choice_1   = "1. " + @choice_1
      @choice_2   = options.fetch(2, "choice1")
      @choice_2   = "2. " + @choice_2
      @choice_3   = options.fetch(3, "choice3")
      @choice_3   = "3. " + @choice_3
      @choice_4   = options.fetch(4, "choice4")
      @choice_4   = "4. " + @choice_4
      @choice_5   = options.fetch(5, nil)
      @choice_5   = "5. " + @choice_5 if @choice_5
      @data[:row1] = {row_data: [@choice_1, @choice_2], cell_atts: $quiz_item_style[:choice_style]}
      @data[:row2] = {row_data: [@choice_3, @choice_4], cell_atts: $quiz_item_style[:choice_style]}
      @data[:layout_expand] = [:width]
      @layout_space   = 2
      @layout_expand  = options.fetch(:layout_expand,[:width])
      super
      self
    end
    
    def set_quiz_content
      quiz_width = @width - @left_margin - @right_margin
      @layout_space = $quiz_item_style[:layout_space] || 10
      if @data[:q]
        q_options = $quiz_item_style[:q_style].dup
        q_options[:width] = quiz_width
        @q_object = text(@data[:q], q_options)        
      end
      if @data[:img]
        @img_object = image(@data[:img])
      end
      
      if @data[:row1]
        row_indent            = $quiz_item_style[:q_style][:text_head_indent] || 20
        @data[:row1][:width]  = @width - row_indent - @left_margin - @right_margin
        @data[:row1][:left_margin] = row_indent
        @row1_object          = TableRow.new(@data[:row1])
        @row1_object.parent_graphic = self
        @graphics << @row1_object unless @graphics.include?(@row1_object)
        @row1_object.relayout!
      end
      
      if @data[:row2]
        row_indent            = $quiz_item_style[:q_style][:text_head_indent] || 20
        @data[:row2][:width]  = @width - row_indent - @left_margin - @right_margin
        @data[:row2][:left_margin] = row_indent
        @row2_object          = TableRow.new(@data[:row2])
        @row2_object.parent_graphic = self
        @graphics << @row2_object unless @graphics.include?(@row2_object)
        @row2_object.relayout!        
      end
            
      height_sum = 0
      if @q_object
        height_sum +=@q_object.height
        height_sum += @layout_space
      end
      
      if @img_object
        height_sum +=@img_object.height
        height_sum += @layout_space
      end
      
      if @row1_object
        height_sum +=@row1_object.height
        height_sum += @layout_space
      end
      
      if @row2_object
        height_sum +=@row2_object.height
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
      @processed = true # prevent it from creating duplicates
      @data[:q] = nil
    end
    
    def to_hash
      super
    end
    
    def self.with_yaml(yaml_data)
      
    end
    
    def self.with_md(markdown)
      
    end
    
    def self.with_adoc(adoc)
      
    end
    
    # generate count nimber of quiz_item
    # return single quiz_item if count is 1
    # return array of quiz_items if count > 1
    def sample(count=1)
      if count == 1
        return QuizItem.new
      else
        items_array = []
        count.times do 
          items_array << QuizItem.new
        end
        return items_array
      end
    end
    
  end
  
  # IncorrectAnswersNoteMaker
  # creates notes for each student.
  # omr_cards folder keeps omr_cards for students
  # finished notes are stored in mistaken_ttem_note folder 
  # It takes quiz items, and series of omr_cards
  class IncorrectAnswersNoteMaker
    attr_accessor :project_path, :omr_card, :correct_answers, :wrong_answers
    
    def initialize(project_path)
      @project_path = project_path
      @omr_path     = @project_path + "/omr"
      FileUtiles.mkdir_p(@omr_path) unless File.directory?(@omr_path)
      @notes_path   = @project_path + "/notes"
      FileUtiles.mkdir_p(@notes_path) unless File.directory?(@notes_path)
      @correct_answers  = extract_correct_answers
      Dir.glob("#{@omr_path}/*.txt").each do |orm_card|
        IncorrectAnswersNote.new(@correct_answers, orm_card)
      end
      self
    end
    
    def extract_correct_answers
      
    end
    
  end
  
  class IncorrectAnswersNote
    attr_accessor :name, :omr_card, :correct_answers, :wrong_answers
    
    def initialize(correct_answers, orm_card)
      @orm_card       = orm_card
      @name           = extract_student_name
      @wrong_answers  = extract_wrong_answers
      save_note
      self
    end
    
    def extract_student_name
      
    end
    
    def extract_wrong_answers
      
    end
    
    def save_note
      
    end
  end
end
