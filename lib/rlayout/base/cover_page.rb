module RLayout

  # CoverPage.
  # CoverPage is used as a flexable page designinng mechanis.
  # Object-name_area methods are used as creating place-holders, for differnt types of area.
  # and content for each place holders are filled at run time.
  # CoverPage uses naming convention to match area and data.
  
  # RLayout::CoverPage.new(paper_size: 'A4') do
  #   heading(1,1,6,10)
  #   copy_1(1,10,1,1)
  #   qrcode(10,10, 1,1)
  # end

  # heading = {}
  # heading[:title] = "this is title"
  # heading[:subtitle] = "this is subtitle"
  # heading[:suthor] = "James Bond"

  # copy_1 = {}
  # copy_1[:title] = "this is title"
  # copy_1[:subtitle] = "this is subtitle"
  # copy_1[:body] = "this is body of copy_1"

  # qrcode = {}
  # qrcode[:image_path] = "/path/to/qrcode_image.jpg"


  # def text_area(x_grid, y_grid, width_grid, height_grid, options={})
  # def image_area(x_grid, y_grid, width_grid, height_grid, options={})
  # def table_area(x_grid, y_grid, width_grid, height_grid, options={})
  # def article_area(x_grid, y_grid, width_grid, height_grid, options={})
  # def items_area(x_grid, y_grid, width_grid, height_grid, options={})



  # heading, copy_box, qrcode blocks will create TextArea instances with tag of "heading", "copy_1", "qrcode"
  # The numbers represents grid_x, grid_y, grid_width, grid_height

  # CoverPage#set_contents_for_text_area(nested_page_content_hash)
  # Contents of these TextArea are filled in at later stage, by calling @styablepage.set_contents_for_area(page_data) at run time.
  #  where page_data is nested hash for each TextAreas
  
  # set_contents_for_area(page_data) will fill the page with page_data, 
  # fill each TextArea with values of matching hash key with tag.


  # TextArea
  # TextArea#set_content(content_hash)
  #   each content_hash is layed out with TitleText, hash key as "style_name" and hash value as "text_string".

  # pre-defined  text_area
  #   heading, copy_1, copy_2, copy_3, qrcode, logo, picture

  # jit defining &block 
  #   text_area(1,1,3,4, name) is used to define TextArea place-holder in CoverPage.
  # where name and page_data key would match.

  class CoverPage < Container

    attr_reader :paper_size
    attr_reader :grid
    # attr_reader :document_path, :style_guide_folder

    def initialize(options={}, &block)
      @grid = options[:grid_size] || [6,12]
      @paper_size = options[:paper_size] || "A4"
      options[:width] = SIZES[@paper_size][0]  unless options[:width]
      options[:height] = SIZES[@paper_size][1] unless options[:height]
      # load_text_style
      # load_layout_rb
      super
      if block
        instance_eval(&block)
      end
      self
    end

    def default_layout_rb
      <<~EOF
      RLayout::Container.new(width: 300, height:500) do
        heading(1,1,2,2)
      end
      EOF
    end

    def default_text_style



    end


    # look for TextArea objects with key and set values
    def set_contents_for_area(content_hash)
      content_hash.each do |k,v|
        target = find_by_name(k.to_s)
        target.set_content(v) if target.class  == RLayout::TextArea
      end
    end

    def find_by_name(name)
      @graphics.each do |g|
        return g if g.tag.to_s == name
      end
    end

    # for creating undefined TextArea placeholder in CoverPage
    def text_area(grid_x, grid_y, grid_width, grid_height, name, options={})
      h = options.dup
      h[:parent] = self
      h[:tag] = name
      h[:grid_frame]  = [grid_x, grid_y, grid_width, grid_height]
      h[:fill_color]  = options[:fill_color] || 'clear'
      RLayout::TextArea.new(h)
    end

    # for creating undefined Image  placeholder in CoverPage
    def image_area(grid_x, grid_y, grid_width, grid_height, name, options={})
      h = options.dup
      h[:parent] = self
      h[:tag] = name
      h[:grid_frame]  = [grid_x, grid_y, grid_width, grid_height]
      h[:fill_color]  = options[:fill_color] || 'clear'
      RLayout::Image.new(h)    
    end

    def table_area(grid_x, grid_y, grid_width, grid_height, name, options={})
      h = options.dup
      h[:parent] = self
      h[:tag] = name
      h[:grid_frame]  = [grid_x, grid_y, grid_width, grid_height]
      h[:fill_color]  = options[:fill_color] || 'clear'
      RLayout::Table.new(h)   
    end

    def heading(grid_x, grid_y, grid_width, grid_height, options={})
      h = options.dup
      h[:parent] = self
      h[:grid_frame]  = [grid_x, grid_y, grid_width, grid_height]
      h[:tag] = "heading"
      h[:fill_color]  = options[:fill_color] || 'clear'
      RLayout::TextArea.new(h)
    end

    def copy_1(grid_frame, options={})
      h = options.dup
      h[:parent] = self
      h[:grid_frame]  = grid_frame
      h[:tag] = "copy_1"
      RLayout::TextArea.new(h)
    end

    def copy_2(grid_frame, options={})
      h = options.dup
      h[:parent] = self
      h[:grid_frame]  = grid_frame
      h[:tag] = "copy_2"
      RLayout::TextArea.new(h)
    end

    def copy_3(grid_x, grid_y, grid_width, grid_height, options={})
      h = options.dup
      h[:parent] = self
      h[:grid_frame]  = grid_frame
      h[:tag] = "copy_3"
      RLayout::TextArea.new(h)
    end

    def logo(grid_x, grid_y, grid_width, grid_height, options={})
      h = {}
      h[:parent] = self
      h[:grid_frame]  = [grid_x, grid_y, grid_width, grid_height]
      h[:tag] = "logo"
      h[:fill_color]  = options[:fill_color] || 'red'
      RLayout::Image.new(h)
    end

    def picture(grid_x, grid_y, grid_width, grid_height, options={})
      h = {}
      h[:parent] = self
      h[:grid_frame]  = [grid_x, grid_y, grid_width, grid_height]
      h[:tag] = "picture"
      RLayout::Image.new(h)
    end

    def qrcode(grid_frame, options={})
      h = {}
      h[:parent] = self
      h[:grid_frame]  = grid_frame
      h[:tag] = "qrcode"
      RLayout::Image.new(h)
    end

    
  end


end