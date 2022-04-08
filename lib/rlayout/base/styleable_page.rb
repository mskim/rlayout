module RLayout

  # The goad is to create a design system where designers can create flexable page using text script, 
  # and allow others to reuse them, instead of asking designers to create each and every time.

  # StyleablePage.
  # With StyleablePage, TextArea is used as place-holders in the page as following.

  # RLayout::StyleablePage.new(paper_size: 'A4') do
  #   heading(1,1,6,10)
  #   copy_1(1,10,1,1)
  #   qrcode(10,10, 1,1)
  # end

  # heading, copy_box, qrcode blocks will create TextArea instances with tag of "heading", "copy_1", "qrcode"
  # The numbers represents grid_x, grid_y, grid_width, grid_height

  # StyleablePage#set_contents_for_text_area(nested_page_content_hash)
  # Contents of these TextArea are filled in at later stage, by calling @styablepage.set_contents_for_area(page_data) at run time.
  #  where page_data is nested hash for each TextAreas
  
  # page_data.yml
  # heading:
  #   title: cover title goes here
  #   subtitle: cover subtitle goes here
  #   author: author name goes here
  # copy_1:
  #   title: box title goes here
  #   subtitle: box subtitle goes here
  #   body: box body goes here
  # qrcode:
  #   image_path: /some/qrcode/image_path.jpg

  # set_contents_for_area(page_data) will fill the page with page_data, 
  # fill each TextArea with value of match hash key with tag.


  # TextArea
  # TextArea#set_content(content_hash)
  #   each content_hash is layed out with TitleText, hash key as "style_name" and hash value as "text_string".

  # pre-defined  text_area
  #   heading, copy_1, copy_2, copy_3, qrcode, logo, picture

  # jit defining &block 
  #   text_area(1,1,3,4, name) is used to define TextArea place-holder in StyleablePage.
  # where name and page_data key would match.

  class StyleablePage < Container
    attr_reader :grid

    def initialize(options={}, &block)
      super
      @grid = options[:paper_size] || [6,12]

      if block
        instance_eval(&block)
      end
      self
    end

    def default_layout_rb
      <<~EOF
      RLayout::StyleablePage.new(width: 300, height:500) do
        heading(1,1,2,2)
      end
      EOF
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

    # for creating undefined TextArea placeholder in StyleablePage
    def text_area(grid_x, grid_y, grid_width, grid_height, name, options={})
      h = options.dup
      h[:parent] = self
      h[:tag] = name
      h[:grid_frame]  = [grid_x, grid_y, grid_width, grid_height]
      h[:fill_color]  = options[:fill_color] || 'clear'
      RLayout::TextArea.new(h)
    end

    # for creating undefined Image  placeholder in StyleablePage
    def image_area(grid_x, grid_y, grid_width, grid_height, name, options={})
      h = options.dup
      h[:parent] = self
      h[:tag] = name
      h[:tag] = 
      h[:grid_frame]  = [grid_x, grid_y, grid_width, grid_height]
      h[:fill_color]  = options[:fill_color] || 'clear'
      RLayout::Image.new(h)    
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