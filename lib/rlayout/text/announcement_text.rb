module RLayout
  # AnnouncementText uniform styled text
  # used for Announcement
  class AnnouncementText < Container
    attr_accessor :string, :title, :linked_page, :title_object, :link_object

    def initialize(options={})
      @string                 = options.delete(:text_string)
      options[:fill_color] = "CMYK=20,100,50,10"
      if options[:fill_color] == '파랑'
        options[:fill_color] = "CMYK=100,50,0,10"
      end
      super
      if @string.include?("\r\n")
        s               = @string.split("\r\n")
        @title          = s[0]
        @linked_page    = s[1]
        @title_object   = make_title
        @link_object    = make_linked_page
      else
        @title = @string
        make_title
      end
    end

    def make_title
      atts = {}
      atts[:x]                  = 8
      atts[:text_fit_type]      = 'fit_box_to_text'
      atts[:y]                  = @top_margin + 2
      atts[:style_name]         = 'announcement_1'
      atts[:text_string]        = @title
      atts[:body_line_height]   = @body_line_height if @body_line_height
      atts[:text_fit_type]      = 'adjust_box_height'
      atts[:fill_color]         = 'clear'
      atts[:parent]             = self
      Text.new(atts)
    end

    def make_linked_page
      atts = {}
      atts[:text_fit_type]      = 'fit_box_to_text'
      atts[:from_right]         = 10
      atts[:anchor_type]        = 'right'
    #   atts[:alignment]          = 'right'
      atts[:y]                  = @top_margin + 7
      atts[:style_name]         = 'announcement_2'
      atts[:text_string]        = @linked_page
      atts[:body_line_height]   = @body_line_height if @body_line_height
      atts[:fill_color]         = 'clear'
      atts[:parent]             = self
      Text.new(atts)
    end
  end

end
