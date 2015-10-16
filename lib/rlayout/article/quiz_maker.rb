# encoding: utf-8

# QuizMaker parses QuizData and Makes PDF document.
# QuizData is strore in md or yml file.
# It has meta-data yml header with title, subtitle, data etc...
# QuizData is first converted to QuizItem using QuizItemMaker. 

# set_quiz_content is call when layout time.

#TODO
# paper size
# document column_count
# Heading layout_length
# QuizItem frame

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

module RLayout

  class QuizMaker
    attr_accessor :project_path, :template_path, :quiz_data_path
    attr_accessor :document, :output_path, :starting_page_number, :column_count
    attr_accessor :layout_style
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
      # raise "SyntaxError in #{@template_path} !!!!" if @document.is_a?(SyntaxError)
      
      unless @document.kind_of?(RLayout::Document)
        puts "Not a @document kind created !!!"
        return
      end
      $layout_style = @layout_style
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
      # @heading[:stroke_sides] = [1,1,1,1]
      # @heading[:stroke_width] = 1
      @heading              = @heading.merge!(@layout_style[:heading])
      @main_layout_space    = @layout_style[:heading][:heading_space_after] || 20
      @column_gutter        = @layout_style[:text_box][:column_gutter] || 10
      @column_layout_space  = @layout_style[:text_box][:column_layout_space] || 10
      @draw_gutter_stroke   = @layout_style[:text_box][:draw_gutter_stroke] || false
      @text_box_layout_length=@layout_style[:text_box][:layout_length] || 8
      @quiz_items           = @quiz_hash[:quiz_items] || 30
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
    attr_accessor :quiz_item, :quiz_style
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
      item_options[:row1] = {row_data: [@choice_1, @choice_2], cell_atts: $layout_style[:quiz_item_style][:choice_style]}
      item_options[:row2] = {row_data: [@choice_3, @choice_4], cell_atts: $layout_style[:quiz_item_style][:choice_style]}
      item_options[:ans]  = {text_string: @answer}
      item_options[:exp]  = {text_string: @exp}
      item_options[:layout_expand] = [:width]
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
    attr_accessor :img_object, :data, :processed
    def initialize(parent_graphic, options={}, &block)
      @data           = options
      @layout_space   = 2
      @layout_expand  = options.fetch(:layout_expand,[:width])
      super
      @klass          = 'QuizItem'
      @processed       = false
      unless options[:delayed_layout]
        set_quiz_content
      end
      self
    end
    
    def set_quiz_content
      return if @processed
      @layout_space = $layout_style[:quiz_item_style][:layout_space] || 10
      if @data[:q]
        text_options = $layout_style[:quiz_item_style][:q_style]
        text_options[:width] = @width - @left_margin - @right_margin
        @q_object = text(@data[:q], text_options)
      end
      if @data[:img]
        @img_object = image(@data[:img])
      end
      
      if @data[:row1]
        row_indent            = $layout_style[:quiz_item_style][:q_style][:text_head_indent] || 20
        @data[:row1][:width]  = @width - row_indent - @left_margin - @right_margin
        @data[:row1][:left_margin] = row_indent
        @row1_object          = TableRow.new(self, @data[:row1])
        @row1_object.relayout!
      end
      
      if @data[:row2]
        row_indent            = $layout_style[:quiz_item_style][:q_style][:text_head_indent] || 20
        @data[:row2][:width]  = @width - row_indent - @left_margin - @right_margin
        @data[:row2][:left_margin] = row_indent
        @row2_object          = TableRow.new(self, @data[:row2])
        @row1_object.relayout!        
      end
      
      # if @data[:ans]
      #   @ans_object = text(@data[:ans])
      # elsif @data["ans"]
      #   @ans_object = text(@data["ans"])
      # end
      # puts "after ans"
      # 
      # if @data[:exp]
      #   @exp_object = text(@data[:exp])
      # elsif @data["exp"]
      #   @exp_object = text(@data["exp"])
      # end
      # puts "after exp"
      
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
      
      if @ans_object
        height_sum +=@ans_object.height
        height_sum += @layout_space
      end
      
      if @exp_object
        height_sum +=@exp_object.height
        height_sum += @layout_space
      end
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
      @processed = true # prevent it from creating duplicates
      @data[:q] = nil
    end
    
    def to_hash
      super
    end
    
  end
end
