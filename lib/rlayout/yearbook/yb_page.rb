module RLayout

  # YbPage
  # folder_image_layout_info hash is passed to YbPage.
  # folder_image_layout_info containes layout infomation for folder images
  # Array of folder layout info for each image folders. 
  # position, column, row, and folder_name
  #
  # heading
  # checks for story.md file in project foler, if it exists layout heading from it.
  # 
  # background_image
  # checks for bg_image.jpg file in project foler, if it exists create backgrpud image from it.
  #
  # layout_folder_images
  #
  # layout_folder
  # process folder image layout
  # It places folder images into single Image, if there is only one image file.
  # or places folder images into GroupImage, if there are multiple images.

  class YbPage < Container
    attr_reader :page_path
    attr_reader :page_number, :column, :row, :column_width, :row_height
    attr_reader :story, :folder_image_layout_info
    attr_reader :page_number
    def initialize(options={})
      if options[:page_size] == 'custom'
        if !(options[:width] && options[:height])
          puts "costom size should have width %% height!!!"
        end
      else
        options[:page_size] = 'A3' unless options[:page_size]
        options[:width]   = SIZES[options[:page_size]][0]
        options[:height]  = SIZES[options[:page_size]][1]
      end
      @page_path = options[:page_path]
      @page_number = options[:page_number]

      # kind: @section_kind, section_order: @section_order, page_order: i,
      @page_order = File.basename(@page_path)
      @section_name = File.basename(File.dirname(@page_path))
      @section_name_array = @section_name.split("_") # 학급_3-1
      @section_kind = @section_name_array[0]         # 학급
      @section_order = @section_name_array[1]        # 3-1
      # @name = options[:section_order]
      @class_name = @section_order
      @column = options[:column] || 6
      @row = options[:row] || 12
      @left_margin = options[:left_margin] || 50
      @top_margin = options[:top_margin] || 100
      @right_margin = options[:right_margin] || 50
      @bottom_margin = options[:bottom_margin] || 100
      @folder_image_layout_info = options[:folder_image_layout_info] || default_folder_image_layout
      super
      @column_width = (@width - @left_margin - @right_margin)/@column
      @row_height = (@height - @top_margin - @bottom_margin)/@row
      layout_background_image
      heading
      layout_folder_images
      layout_class_name
      self
    end

    def bg_image_path
      @page_path + "/bg_image.jpg"
    end

    def layout_background_image
      bg_image = bg_image_path
      if File.exist?(bg_image)
        options = {}
        options[:parent] = self
        options[:x] = -5
        options[:y] = -5
        options[:width] = @width + 10
        options[:height] = @height + 10
        options[:image_path] = bg_image
        Image.new(options)      
      end
    end

    def layout_class_name
      if @page_order == "0"
        RLayout::Text.new(text_string: "홍길동", font_size: 40, x:280, y:280, parent: self) 
        RLayout::Text.new(text_string: @class_name, font_size: 100, x:200, y:500, parent: self) 
      elsif @page_number.even?
        RLayout::Text.new(text_string: @class_name, font_size: 100, x:600, y:600, parent: self) 
      end
    end

    def layout_folder_images
      @folder_image_layout_info.each do |image_layout|
        converted_result = convert_position_to_frame(image_layout)
        layout_folder(converted_result)
      end
    end

    def default_folder_image_layout
      layout_array = []
      if @page_order == "0"
        # first page of section
        if @page_number.even?
          h = {}
          h[:foler_name] = "A"
          h[:position] = 1
          h[:layout_column] = 1.5
          h[:layout_row] = 3
          h[:column] = 2
          h[:row] = 3
          h[:gutter] = 5
          h[:v_gutter] = 8
          h[:member_shape] = 'rect'
          layout_array << h.dup
          h = {}
          h[:foler_name] = "B"
          h[:position] = 9
          h[:layout_column] = 5
          h[:layout_row] = 5
          h[:column] = 3
          h[:row] = 2
          h[:gutter] = 5
          h[:v_gutter] = 60
          layout_array << h.dup
        else
          h = {}
          h[:foler_name] = "A"
          h[:position] = 1
          h[:layout_column] = 1.5
          h[:layout_row] = 3
          h[:column] = 2
          h[:row] = 3
          h[:gutter] = 5
          h[:v_gutter] = 8
          h[:member_shape] = 'rect'
          layout_array << h.dup
          h = {}
          h[:foler_name] = "B"
          h[:position] = 9
          h[:layout_column] = 5
          h[:layout_row] = 5
          h[:column] = 3
          h[:row] = 2
          h[:gutter] = 5
          h[:v_gutter] = 60
          layout_array << h.dup
        end

        return layout_array
      end

      if @page_number.even?
        h = {}
        h[:foler_name] = "A"
        h[:position] = 1
        h[:layout_column] = 2
        h[:layout_row] = 6
        h[:column] = 2
        h[:row] = 3
        h[:gutter] = 5
        h[:v_gutter] = 8
        h[:fill_color] = 'green'
        h[:member_shape] = 'rect'
        layout_array << h.dup
        h = {}
        h[:foler_name] = "B"
        h[:position] = 3
        h[:layout_column] = 3.8
        h[:layout_row] = 6
        h[:column] = 3
        h[:row] = 2
        h[:gutter] = 5
        h[:v_gutter] = 60
        h[:member_shape] = 'circle'
        layout_array << h.dup
        h = {}
        h[:foler_name] = "c"
        h[:position] = 9
        h[:layout_column] = 3.8
        h[:layout_row] = 4
        h[:column] = 4
        h[:row] = 3
        layout_array << h.dup
      else
        h = {}
        h[:foler_name] = "A"
        h[:position] = 3
        h[:layout_column] = 2
        h[:layout_row] = 6
        h[:column] = 2
        h[:row] = 3
        h[:gutter] = 5
        h[:v_gutter] = 8
        h[:fill_color] = 'green'
        h[:member_shape] = 'rect'
        layout_array << h.dup
        h = {}
        h[:foler_name] = "B"
        h[:position] = 1
        h[:layout_column] = 3.8
        h[:layout_row] = 6
        h[:column] = 3
        h[:row] = 2
        h[:gutter] = 5
        h[:v_gutter] = 60
        h[:member_shape] = 'circle'
        layout_array << h.dup
        h = {}
        h[:foler_name] = "c"
        h[:position] = 7
        h[:layout_column] = 3.8
        h[:layout_row] = 4
        h[:column] = 3
        h[:row] = 3
        layout_array << h.dup
      end
      layout_array
    end

    def heading(options={})
      @story_path = @page_path + "/story.md"
      if File.exist?(@story_path)
        @story  = File.open(@story_path){|f| f.read}
        options[:parent] = self
        Heading.new(options)
      end
    end

    def layout_folder(options={})
      options[:parent] = self
      @group_path = @page_path + "/#{options[:foler_name]}"
      @group_images = Dir.glob("#{@group_path}/*.jpg")
      options[:image_items] = @group_images
      location = options[:location] 
      grid_base = options[:grid_base] 
      if @group_images.length == 1
        options[:image_path] = @group_images.first
        Image.new(options)
      elsif @group_images.length > 1
        options[:image_item_full_path_array] = @group_images
        GroupImage.new(options)
      end
    end

    def convert_position_to_frame(options)
      layout_width = @width - @left_margin - @right_margin
      horizontal_center = width/2
      vertical_center = height/2
      image_width = options[:layout_column]*@column_width
      image_height = options[:layout_row]*@row_height      
      case options[:position]
      when 1
        image_x = @left_margin
        image_y = @top_margin
      when 2
        image_x = horizontal_center - image_width/2
        image_y = @top_margin
      when 3
        image_x = width - @right_margin - image_width
        image_y = @top_margin
      when 4
        image_x = @left_margin
        image_y = vertical_center - image_height/2
      when 5
        image_x = horizontal_center - image_width/2
        image_y = vertical_center - image_height/2
      when 6 
        image_x = width - @right_margin - image_width
        image_y = vertical_center - image_height/2
      when 7
        image_x = @left_margin
        image_y = height - @bottom_margin - image_height
      when 8
        image_x = horizontal_center - image_width/2
        image_y = height - @bottom_margin - image_height
      when 9
        image_x = width - @right_margin - image_width
        image_y = height - @bottom_margin - image_height
      end  
      options[:x] = image_x
      options[:y] = image_y
      options[:width] = image_width
      options[:height] = image_height
      options
    end

    def background_image(options={})
      bg_path = @page_path + "bg_image.jpg"
      return unless File.exist?(bg_path)
      options[:parent] = self
      options[:x] = @left_margin
      options[:y] = @top_margin
      options[:width] = @width
      options[:height] = @height
      Image.new(options)
    end

  end
  
  
end