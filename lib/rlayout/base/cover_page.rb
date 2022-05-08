module RLayout

  # CoverPage
  # CoverPage is used as a flexable page designinng mechanism.
  # text_area, image_area, table_area article_area methods are used as creating place-holders, 
  # for differnt types of areas. text, image, table, article etc...
  # and content for each place holders are filled at run time.
  # This make it possible to implement flexable and resuable page design system.
  # where designers can design a page without actual data, 
  # and authors can later fill the page with data with pre-designed look.
  # CoverPage uses naming convention to match area and data.
  
  # example:
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

  # page_content = {}
  # page_content[:heading] = heading
  # page_content[:copy_1] = copy_1
  # page_content[:qrcode] = qrcode
  
  # Default page grid is 6x12.
  # The numbers represents grid_x, grid_y, grid_width, grid_height
  # where heading(1,1,6,10) is place at grid_frame of 1,1,6,10
  # heading, copy_1, qrcode blocks will create TextArea instances with tag of "heading", "copy_1", "qrcode"

  # "set_page_content" is called with page_content at run time.
  # set_page_content looks for object with key of page_content that matchs tag of the object, 
  # 
  # for example
  # it calls set_contnet to heding_object with page_content['heading']
  # it calls set_contnet to copy_1_object with page_content['copy_1']
  # it calls set_contnet to qrcode_object with page_content['qrcode']


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

    def initialize(options={}, &block)
      @grid = options[:grid_size] || [6,12]
      @paper_size = options[:paper_size] || "A4"
      options[:width] = SIZES[@paper_size][0]  unless options[:width]
      options[:height] = SIZES[@paper_size][1]  unless options[:height]
      
      if options[:margin]
      elsif options[:top_margin]
        options[:margin] =  options[:top_margin]
      elsif options[:left_margin]
        options[:margin] =  options[:left_margin]
      else
        options[:margin] = 10
      end

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
        heading(0,0,2,2)
      end
      EOF
    end

    # look for TextArea objects with key and set value
    def set_page_content(content_hash)
      content_hash.each do |k,v|
        next if v.nil?
        target = find_by_name(k.to_s)
        target.set_content(v) if target.class  == RLayout::TextArea || target.class  == RLayout::TextBar || target.class  == RLayout::TextBarV
        # target.set_content(v, style_name:  k.to_s) if target.class  == RLayout::Text
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

    # for creating undefined TextArea placeholder in CoverPage
    def text_area_h(grid_x, grid_y, grid_width, grid_height, name, options={})
      h = options.dup
      h[:parent] = self
      h[:tag] = name
      h[:grid_frame]  = [grid_x, grid_y, grid_width, grid_height]
      h[:fill_color]  = options[:fill_color] || 'clear'
      RLayout::TextAreaH.new(h)
    end

    # for creating undefined TextArea placeholder in CoverPage
    def text_area_v(grid_x, grid_y, grid_width, grid_height, name, options={})
      h = options.dup
      h[:parent] = self
      h[:tag] = name
      h[:grid_frame]  = [grid_x, grid_y, grid_width, grid_height]
      h[:fill_color]  = options[:fill_color] || 'clear'
      RLayout::TextAreaV.new(h)
    end
    # for creating undefined TextArea placeholder in CoverPage
    def seneca_h(grid_x, grid_y, grid_width, grid_height, options={})
      h = options.dup
      h[:parent] = self
      h[:tag] = 'seneca'
      h[:grid_frame]  = [grid_x, grid_y, grid_width, grid_height]
      h[:fill_color]  = options[:fill_color] || 'clear'
      RLayout::TextBar.new(h)
    end

    # for creating undefined TextArea placeholder in CoverPage
    def seneca_v(grid_x, grid_y, grid_width, grid_height, options={})
      h = options.dup
      h[:parent] = self
      h[:tag] = 'seneca'
      h[:grid_frame]  = [grid_x, grid_y, grid_width, grid_height]
      h[:fill_color]  = options[:fill_color] || 'clear'
      RLayout::TextBarV.new(h)
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