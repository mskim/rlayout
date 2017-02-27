
module RLayout

  # Why FloatGroup?
  # The problem
  # I want to add flowing images along the text, but laying them out is a challenge.
  # How do I place an image or any floats, when they are flowing with text?
  # It can be unpredictable where they might end up.
  # We can have several floating objects at a same page, and it would be a nightmante to layout them out by any algorithm.
  # I might want to place two images in a same page, but they could end up in different pages. I need to a way to spceify the layout, and yet they need to flow dynamictally with text. This is where FloatGroup comes in. FloatGroup is a semi-auto layout process. You can specipy the layout of float group by page.

  # FloatGroup puts group of floats(an image, quote, etc..) at current page
  # if image group is the first item, text_box.exmpty?==true
  # else it puts image at the following page, adding page if the page doen't exist.
  # for the second case we could get unwanted space between the previous paragraph and next page image, since we don't know where the exact breaking point is.
  # We want the folliwing paragraphs to fill into the previous page's space before the image, if we have room. "allow_text_jump_over" flag is used to tell it to do so.

  # 1. allow_text_jump_over
  # it tells to allow following text to jump over and fill the gap in previous page of the image.

  # 2. page_offset?? not implemented yet we could do this we multipe image_group
  # if image is specified with page_offset starting from next page,
  # image is place ot offsetting page
  # This is used to layout image that are certain pages apart.
  # [float_group]
	# {local_image: "1.jpg", frame_rect: [0,0,1,1]}
	# {local_image: "2.jpg", frame_rect: [0,0,1,1], page_offset:1}
	# {local_image: "3.jpg", frame_rect: [0,0,1,1], page_offset:2}
	# {quote: "Our time is too short for fighting", frame_rect: [0,0,1,1], page_offset:2}
	# above will place images in pages 1, 2, 3

  class FloatGroup
    attr_accessor :floats, :allow_text_jump_over
    def initialize(options={})
      @allow_text_jump_over = options.fetch(:allow_text_jump_over, true)
      @floats = []
      @floats               = make_floats(options[:text_block])
      self
    end

    # example
    #TODO hanlde other floats besides image

    # [float_group]
  	# {local_image: "1.jpg", frame_rect: [0,0,1,1]}
  	# {local_image: "2.jpg", frame_rect: [0,0,1,1], page_offset:1}
  	# {local_image: "3.jpg", frame_rect: [0,0,1,1], page_offset:2}
  	# {quote: "Our time is too short for fighting", frame_rect: [0,0,1,1],    def make_floats(text_block)
    def make_floats(text_block)
      @floats = []
      if text_block.is_a?(Array)
        text_block.shift
        text_block.each do |float_line|
          options           = eval(float_line)
          options[:parent]  = self
          options[:floats]  = true
          @floats << options
        end
      elsif text_block.is_a?(String)
        text_block_array = text_block.split("\n")
        text_block_array.shift
        text_block_array.each do |float_line|
          options           = eval(float_line)
          options[:parent]  = self
          options[:floats]  = true
          @floats << options
        end
      end
      @floats
    end
    # page layout is delayed until layout time.
    # document is not known until layout time.
    def layout_page(options={})
      @document     = options[:document]
      @page_index   = options[:page_index]
      @starting_page = options.fetch(:@starting_page, 1)
      @page         = @document.pages[@page_index]
      @main_box     = @page.main_box

      if @main_box.empty?
        # put image group in empty main_box
      else
        # go to next page
        @page_index += 1
        # make page, if it is the last page
        if @page_index >= @document.pages.length
          options               = {}
          options[:parent]      = @document
          options[:footer]      = true
          options[:header]      = true
          options[:text_box]    = true
          options[:page_number] = @starting_page + @page_index
          options[:column_count]= @document.column_count
          p=Page.new(options)
          p.relayout!
          p.main_box.create_column_grid_rects
          @main_box = p.main_box
        end
      end
      @floats.each do |image_info|
        @main_box.float_image(image_info)
      end
      @main_box.layout_floats!
      @main_box.set_overlapping_grid_rect
      @main_box.update_column_areas
    end

  end


end
