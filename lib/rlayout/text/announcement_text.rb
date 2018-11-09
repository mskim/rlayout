module RLayout

  # AnnouncementText uniform styled text
  # used for Announcement (토요일은 신문쉽니다.)
  class AnnouncementText < Container
    attr_accessor :string, :title, :linked_page, :title_object, :link_object
    attr_accessor :column_count
    def initialize(options={})
      @string                 = options.delete(:text_string)
      @column_count           = options.fetch(:announcement_column, 1)
      options[:fill_color]    = "CMYK=20,100,50,10"
      if options[:announcement_color] == '파랑' || options[:announcement_color] == 'blue'
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
      if @column_count == 2
        atts[:x]                = 8
      else
        atts[:anchor_type]      = 'center'
      end
      atts[:text_fit_type]      = 'fit_box_to_text'
      atts[:y]                  = @top_margin + 2
      atts[:style_name]         = 'announcement_1'
      atts[:text_string]        = @title
      atts[:body_line_height]   = @body_line_height if @body_line_height
      atts[:fill_color]         = 'clear'
      atts[:width]              = @width
      atts[:parent]             = self
      Text.new(atts)
    end

    def make_linked_page
      atts = {}
      atts[:text_fit_type]      = 'fit_box_to_text'
      atts[:x]                  = 244
      atts[:y]                  = @top_margin + 5
      atts[:style_name]         = 'announcement_2'
      atts[:text_string]        = @linked_page
      puts "atts[:text_string]#{atts[:text_string]}"
      atts[:body_line_height]   = @body_line_height if @body_line_height
      atts[:fill_color]         = 'clear'
      atts[:parent]             = self
      Text.new(atts)
    end
  end

end
