# encoding: utf-8

# ItemChapterMaker is tool chain for creating chapter with pre-layed out items in PDF, 
# Quiz Bank Items, Study Aide Items, catalog items.
# Each items can be edit in distributted manner and assembled as chapter on the fly.
# This is very useful for items that are edited and assembled on the fly.
 
# project folder
#   config.yml
#     contains chapter configuration
#     things that effects all item folders
#     paper size, number style, font, text_size, columns, side_column
#   items
#     List of items 
#     Each folder contains layout.rb, images, story.md, or data.csv
#     They are usually copied into the folder from a collection as needed.
#   Rakefile 
#     update, build
#     default rake commands updates any item folder that is not upto data.
#     rake build: builds chapter with config.yml and pdf from each item folders
#     And saves new object_chapter.pdf

# workflow
# copy ItemChaper from template 
# add more Item Folders if need more items.
# Edit each object items
# rake 
# rake build
# repeat this process until done.

module RLayout

  class ItemChapterMaker
    attr_accessor :project_path, :config_hash, :template_path, :items
    attr_accessor :document, :output_path, :starting_page_number, :column_count
    attr_accessor :layout_style
    def initialize(options={} ,&block)
      unless options[:project_path]
        puts "No project_path !!!"
        return
      end
      @project_path   = options[:project_path]
      $ProjectPath    = @project_path
      config_path     = @project_path + "/config.yml"
      config_data     = File.open(config_path, 'r'){|f| f.read}
      @config_hash    = YAML::load(config_data) # it returns Array
      if options[:output_path]
        @output_path  = options[:output_path]
      else
        @output_path  = @project_path + "/object_chapter.pdf"
      end
      if options[:template_path]
        unless File.exist?(options[:template_path])
          puts "Template #{options[:template_path]} doesn't exist!!!"
          return
        end
      end
      @template_path = options.fetch(:template_path, "/Users/Shared/SoftwareLab/article_template/item_chapter.rb")
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
      if @object_item_style.class == Array
        $object_item_style      = @object_item_style[0]
      else
        $object_item_style      = @object_item_style
      end
      $layout_style         = @layout_style
      @starting_page_number = options.fetch(:starting_page_number,1)
      read_items
      layout_items_list 
      @document.save_pdf(@output_path) unless options[:no_output] 
      self
    end
    
    def read_items
      items_path                = Dir.glob("#{@project_path}/item/**/*.pdf")
      @items = []
      items_path.each_with_index do |item_path, i|
        # @items << Image.new(image_path: item_path)
        @items << ItemContainer.new(image_path: item_path, number: (i+1).to_s, number_style: @layout_style[:number_style])
      end
    end
    
    def layout_items_list
      page_options               = {}
      page_options[:footer]      = true
      page_options[:header]      = true
      page_options[:text_box]    = true
      page_options[:column_count] = @config_hash['column_count'] if @config_hash['column_count']
      page_options[:parent]     = @document
      if @document.pages.length == 0
        page_options[:page_number] = @starting_page_number
        p=Page.new(page_options)
        p.relayout!
        p.main_box.create_column_grid_rects        
      else
        text_box_options ={}
        text_box_options[:column_count] = @config_hash['column_count'] if @config_hash['column_count']
        @document.pages[0].main_text(text_box_options) unless @document.pages[0].main_box
      end
      page_index                            = 0
      @first_page                           = @document.pages[0]
      @first_page.layout_space              = @main_layout_space
      @first_page.main_box.layout_space     = @column_gutter 
      @first_page.main_box.draw_gutter_stroke= @draw_gutter_stroke 
      @first_page.main_box.graphics.each{|col| col.layout_space = @column_layout_space}
      @first_page.relayout!
      @first_page.main_box.create_column_grid_rects
      @first_page.main_box.set_overlapping_grid_rect
      @first_page.main_box.layout_items(@items)
      if @document.pages[1]
        @second_page  = @document.pages[1] 
        text_box_options ={}
        text_box_options[:column_count] = @config_hash['column_count'] if @config_hash['column_count']        
        @second_page.main_text(text_box_options) unless @second_page.main_box
        @second_page.layout_space              = @main_layout_space
        @second_page.main_box.layout_space     = @column_gutter 
        @second_page.main_box.draw_gutter_stroke= @draw_gutter_stroke 
        @second_page.main_box.graphics.each{|col| col.layout_space = @column_layout_space}
        @second_page.relayout!
        @second_page.main_box.create_column_grid_rects
        @second_page.main_box.set_overlapping_grid_rect      
      end
      page_index = 0
      while @items.length > 0
        if page_index >= @document.pages.length
          # options[:text_box_options]    = @layout_style[:text_box]
          page_options[:page_number] = @starting_page_number + page_index
          p=Page.new(page_options)
          p.relayout!
          p.main_box.create_column_grid_rects
        end
        @document.pages[page_index].main_box.layout_items(@items)
        @document.pages[page_index].relayout!
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
  
  class ItemContainer < Container
    attr_accessor :number_object, :number_indent, :number, :number_font, :number_size
    attr_accessor :item_image , :number_style
    def initialize(options={})
      options[:layout_expand] = nil
      @number_style     = options[:number_style]
      super
      @number           = "1"
      @number           = options[:number].to_s if options[:number]
      @number_object    = text(@number, @number_style)
      options[:parent]  = self
      options[:x]       = 25
      options[:layout_expand] = nil
      @item_image       = Image.new(options)
      self   
    end
    
    # called after column width and height is determined to arrange item 
    def arrange_item
      @item_image.width   = @width - @item_image.x
      #TODO adjust item_image height with  original image ratio
      @item_image.height  = @height
      @item_image.apply_fit_type
    end
  end
  
end
