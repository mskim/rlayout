# encoding: utf-8

# QuizMaker merges QuizData and Document.
# Story can come from couple of sources, markdown, adoc, or html(URL blog)
# Story can be adoc, markdown, or html format.
# QuizData is first converted to QuizItem using QuizItemMaker. 

#TODO
# paper size
# document column_count
# Heading layout_length
# QuizItem frame

# give option for text_layout_manager to adjust the text height
# Do the number

module RLayout

  class QuizMaker
    attr_accessor :project_path, :template_path, :quiz_data_path
    attr_accessor :document, :output_path, :starting_page_number, :column_count

    def initialize(options={} ,&block)
      unless options[:quiz_data_path]
        puts "No quiz_data_path !!!"
        return
      else
        @quiz_data_path = options[:quiz_data_path]
        @project_path   = File.dirname(@quiz_data_path)
        $ProjectPath    = @project_path
        unless File.exist?(@quiz_data_path)
          puts "No quiz_data_path doen't exist !!!"
          return
        end
        if options[:output_path]
          @output_path  = options[:output_path]
        else
          ext           = File.extname(@quiz_data_path)
          @output_path  = @quiz_data_path.gsub(ext, ".pdf")
        end
      end
      if options[:template_path]
        unless File.exist?(options[:template_path])
          puts "Template #{options[:template_path]} doesn't exist!!!"
          return
        end
      end
      @template_path = options.fetch(:template_path, "/Users/Shared/SoftwareLab/article_template/quiz.rb")
      template = File.open(@template_path,'r'){|f| f.read}
      @document = eval(template)
      
      if @document.is_a?(SyntaxError)
        puts "SyntaxError in #{@template_path} !!!!"
        return
      end
      unless @document.kind_of?(RLayout::Document)
        puts "Not a @document kind created !!!"
        return
      end
      @starting_page_number = options.fetch(:starting_page_number,1)
      read_quiz_items
      layout_quiz_items      
      @document.save_pdf(@output_path) unless options[:no_output] 
      self
    end
        
    def read_quiz_items
      @quiz_hash  = QuizItemMaker.yaml2quiz_hash(@quiz_data_path)
      @heading    = @quiz_hash[:heading] || {}
      @title      = @heading[:title] || "Untitled"
      @heading[:fill_color] = "orange"
      @quiz_items = @quiz_hash[:quiz_items]
    end

    def layout_quiz_items
      page_index                = 0
      @first_page               = @document.pages[0]
      if heading = @first_page.get_heading?
        heading.set_heading_content(@heading) 
      else
        # place heading at the front most
        heading = Heading.new(@first_page, @heading)
        @first_page.graphics.unshift(@first_page.graphics.pop)
      end
      @first_page.main_box.layout_length = 8
      @first_page.relayout!
      @first_page.main_box.create_column_grid_rects
      @first_page.main_box.set_overlapping_grid_rect
      @first_page.main_box.layout_items(@quiz_items)
            
      page_index = 1
      while @quiz_items.length > 0
        if page_index >= @document.pages.length
          options               = {}
          options[:footer]      = true
          options[:header]      = true
          options[:text_box]    = true
          options[:page_number] = @starting_page_number + page_index
          options[:column_count]= @document.column_count
          p=Page.new(@document, options)
          p.relayout!
          p.main_box.create_column_grid_rects
        end
        @document.pages[page_index].relayout!
        @document.pages[page_index].main_box.layout_items(@quiz_items)
        page_index += 1
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
      {:first_page_only  => true,
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

  class QuizItemMaker
    # attr_accessor :number, :question, :cap, :image
    # attr_accessor :choice_1, :choice_2, :choice_3, :choice_4, :choice_5
    attr_accessor :quiz_item
    def initialize(options={})
      @number     = options.fetch('number', "1")
      @question   = options.fetch('q', {text_string: "Some questiongoes goes here? "})
      @image      = options.fetch('img', nil)
      @cap        = options.fetch('cap', nil)
      @choice_1   = options.fetch(1, "choice1")
      @choice_1   = "1. " + @choice_1
      @choice_2   = options.fetch(2, "choice2")
      @choice_2   = "2. " + @choice_2
      @choice_3   = options.fetch(3, "choice3")
      @choice_3   = "3. " + @choice_3
      @choice_4   = options.fetch(4, "choice4")
      @choice_4   = "4. " + @choice_4
      @cell_atts  = options.fetch('cell_atts', {text_size: 16, text_head_indent: 16, text_alignment: 'left', text_fit_type: 'adjust_box_height', text_vertical_alignment: 'top', stroke_sides: [0,0,0,0]})
      @choice_5   = options.fetch(5, nil)
      @choice_5   = "5. " + @choice_4 if @choice_5
      @answer     = options.fetch('ans', nil)
      @explanation= options.fetch('exp', nil)
      item_options = {}
      item_options[:delayed_layout] = true
      item_options[:num]  = @number
      item_options[:q]    = @question
      item_options[:img]  = @image
      item_options[:cap]  = @cap
      item_options[:row1] = {row_data: [@choice_1, @choice_2], cell_atts: @cell_atts}
      item_options[:row2] = {row_data: [@choice_3, @choice_4], cell_atts: @cell_atts}
      item_options[:ans]  = {text_string: @answer}
      item_options[:exp]  = {text_string: @exp}
      @quiz_item  = QuizItem.new(nil, item_options) 
      self   
    end
    
    def self.yaml2quiz_hash(path)
      source      = File.open(path, 'r'){|f| f.read}
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
      h[:quiz_items]  = QuizItemMaker.yaml2quiz_items(@contents)
      h
    end
    
    def self.yaml2quiz_items(content)
      blocks_array= content.split("\n\n")
      item_array = []
      blocks_array.each_with_index do |lines_block, i|
        yaml = YAML::load(lines_block)
        q    = yaml[:q]
        yaml[:q] = "#{i+1}. " + q if q
        item_array << QuizItemMaker.new(yaml).quiz_item
      end
      item_array
    end
    
  end
  
  # num_atts, q_atts, cap_atts,  
  # cell_atts, choice_indent, choice_gutter
  class QuizItem < Container
    attr_accessor :q_object, :row1_object, :row2_object, :ans_object, :exp_object
    attr_accessor :img_object, :data
    def initialize(parent_graphic, options={}, &block)
      @data           = options
      @layout_space   = 2
      @layout_expand  = options.fetch(:layout_expand,[:width])
      super
      @klass      = 'QuizItem'
      
      unless options[:delayed_layout]
        set_quiz_content(options)
      end
      self
    end
    
    def set_quiz_content_with_width(options={})
      @data[:width] = options[:width] if options[:width]
      set_quiz_content(@data)
    end
    
    def set_quiz_content(options)
      if options[:width]
        @width = options[:width]
      end
      
      if options[:q]
        text_option={text_alignment: 'left', text_size: 24, text_head_indent: 24}
        @q_object = text(options[:q], text_option)
      elsif options["q"]
        @q_object = text(options["q"])
      end
      if options[:img]
        @img_object = image(options[:img])
      elsif options["img"]
        @img_object = image(options["img"])
      end
      
      if options[:row1]
        @row1_object = TableRow.new(self, options[:row1])
      elsif options["row1"]
        @row1_object = TableRow.new(self, options["row1"])
      end
      
      if options[:row2]
        @row2_object = TableRow.new(self, options[:row2])
      elsif options["row2"]
        @row2_object = TableRow.new(self, options["row2"])
      end
      
      # if options[:ans]
      #   @ans_object = text(options[:ans])
      # elsif options["ans"]
      #   @ans_object = text(options["ans"])
      # end
      # puts "after ans"
      # 
      # if options[:exp]
      #   @exp_object = text(options[:exp])
      # elsif options["exp"]
      #   @exp_object = text(options["exp"])
      # end
      # puts "after exp"
      
      height_sum = 0
      height_sum +=@q_object.height    unless @q_object.nil?
      height_sum +=@row1_object.height unless @row1_object.nil?
      height_sum +=@row2_object.height  unless @row2_object.nil?
      height_sum +=@ans_object.height   unless @ans_object.nil?
      height_sum +=@exp_object.height   unless @exp_object.nil?
      # @height = height_sum + graphics_space_sum + @top_inset + @bottom_inset + @top_margin + @bottom_margin
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
    end
    
    def to_hash
      super
    end
    
  end
end
