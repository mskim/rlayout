module RLayout

  # YbPage
  # 

  class YbPage < Container
    attr_reader :page_path
    attr_reader :page_number
    attr_reader :a_group_images, :b_group_images, :c_group_images
    attr_reader :story
    def initialize(options={}, &block)
      @page_path  = options[:page_path]
      options[:page_size] = 'A3' unless options[:page_size]
      options[:width]   = SIZES[options[:page_size]][0]
      options[:height]  = SIZES[options[:page_size]][1]
      @left_margin = options[:left_margin] || 50
      @top_margin = options[:top_margin] || 50
      @right_margin = options[:right_margin] || 50
      @bottom_margin = options[:bottom_margin] || 50
      super
      parse_page_content
      if self.class == YbPage
        if block
          instance_eval(&block)
        end
      end
      self
    end

    def parse_page_content
      @a_group_path = @page_path + "/a"
      @a_group_image = Dir.glob("#{@a_group_path}/*.jpg").first
      @b_group_path = @page_path + "/b"
      @b_group_image = @b_group_path + "/output.pdf"
      @c_group_path = @page_path + "/c"
      @c_group_images = @c_group_path + "/output.pdf"
    end

    def layout_page
      parse_page_content
    end

    def heading(options={})
      @story_path = @page_path + "/story.md"
      if File.exist?(story_path)
        @story  = File.open(@story_path){|f| f.read}
        options[:parent] = self
        Heading.new(options)
      end
    end

    def a_group(options={})
      options[:parent] = self
      options[:image_path] = @a_group_image
      location = options[:location] 
      grid_base = options[:grid_base] 

      options[:x] = @left_margin
      options[:y] = @top_margin
      options[:width] = 300
      options[:height] = 300
      Image.new(options)
    end

    def b_group(options={})
      options[:parent] = self
      options[:image_path] = @b_group_image
      options[:from_right] = 50
      options[:y] = @top_margin
      options[:width] = 300
      options[:height] = 300
      Image.new(options)
    end

    def c_group(options={})
      options[:parent] = self
      options[:image_path] = @image_c
      options[:x] = 0
      options[:y] = 0
      options[:width] = 300
      options[:height] = 300
      Image.new(options)
    end

    def group_picture(options={})
      options[:parent] = self
      options[:image_path] = a_group_images.first
      options[:x] = 0
      options[:y] = 0
      options[:width] = 300
      options[:height] = 300
      options[:fill_color] = 'red'
      Image.new(options)
    end

    def personal_pictures(options={})
      options[:parent] = self
      options[:images_folder] = @b_group_path
      options[:image_items] = @b_group_images
      options[:x] = 300
      options[:y] = 0
      options[:width] = 300
      options[:height] = 400
      options[:fill_color] = 'clear'
      GroupImage.new(options)
    end
  end
  
  
end