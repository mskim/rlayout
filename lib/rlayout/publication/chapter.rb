module RLayout
  # document
    # paper_type A5
    # width , height
    # dobule_side
    # starts_left
    # left_margin
    # top_margin
    # right_margin
    # bottom_margin
    
  # first chapter poge
  
  
  # text_style
    # title
    # subtitle
    # quote
    # head1
    # head2
    
    # body text_size
    # body text_font
    # body text_alignment
    # body text_line_spacing
  
    # header text_size
    # header text_font
    # header side_margin
    # header top_position
  
    # footer text_size
    # footer text_font
    # footer side_margin
    # footer bottom_position
    # footer pre_string
    # footer post_string
  
  class Chapter < Document
    attr_accessor :story_path
    def initialize(options={})
      super
      @double_side  = true
      @page_count = options.fetch(:page_count, 2)
      options[:header]     = true
      options[:footer]     = true 
      options[:header]     = true 
      options[:story_box]  = true
      @page_count.times do |i|
        options[:page_number] = i+1
        if @double_side
          if @starts_left
            options[:left_page]   = i.even?
          else
            options[:left_page]   = i.odd?
          end
        else
          options[:left_page]   = true
        end
        Page.new(self, options)
      end
      
      if options[:story_path]
        options[:category] = 'chapter'
        @pages.first.story_box_object.layout_story(options)
      end
      self
    end
    
    def defaults
      {
        portrait: true,
        double_side: false,
        starts_left: true,
        width: 419.53,
        height: 595.28,
        left_margin: 50,
        top_margin: 50,
        right_margin: 50,
        bottom_margin: 100,
      }
    end
    
    
  end
  
  
end