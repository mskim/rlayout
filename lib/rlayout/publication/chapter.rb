module RLayout
    
  # Chapter
  # create two initial pages with StoryBox, header, footer, side_bar(optional)
  # given Story path
  #  read the story
  #  set @heading and @paragraphs
  #  call @pages.first.story_box_object.layout_story(:heading=>@heading, :paragraphs=> @paragraphs)
  #    story_box_object takes heading data and creates chapter front page heading
  #    story_box_object take @paragraphs data out of Array and inserts it into story_box.
  #  if the changed paragraphs length is 0, which means all the paragraphs have been layed out
  #    we are done.
  #  else means we have some left over paragraphs, go to next page, if no page, create one with StoryBox
  #    after first page :heading is nil, and the paragraphs are the rest of the left overs
  #    call story_box_object.layout_story agoin with (:heading=>nil, :paragraphs=> @paragraphs)
  #  keep going until we have no more leftover paragraphs.
  
  class Chapter < Document
    attr_accessor :story_path, :haeding, :paragraphs
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
        Page.new(self, options)
      end
      
      if options[:story_path]
        @story_path = options[:story_path]
        read_story
        layout_story
      end
        
      self
    end
    
    def read_story
      story      = Story.from_meta_markdown(@story_path)
      @heading = story.heading
      @heading[:category] = 'chapter'
      @paragraphs =[]
      @style_service ||= StyleService.new()
      story.paragraphs.each do |para| 
        para_options  = @style_service.style_for_markup(para[:markup], :category=>"chapter")
        para_options[:markup]   = para[:markup]
        para_options[:text_string]   = para[:string]
        para_options[:layout_expand]   = [:width]
        para_options[:text_fit] = FIT_FONT_SIZE
        @paragraphs << Paragraph.new(nil, para_options)
      end
    end
    
    def layout_story
      page_index = 0
      @pages[page_index].story_box_object.layout_story(:heading=>@heading, :paragraphs=>@paragraphs, :category=>'chapter')
      while @paragraphs.length > 0
        page_index += 1
        if page_index >= @pages.length
          options ={}
          options[:header]     = true
          options[:footer]     = true 
          options[:header]     = true 
          options[:story_box]  = true
          options[:page_number]= page_index + 1
          Page.new(self, options)
        end
        @pages[page_index].story_box_object.layout_story(:heading=>nil, :paragraphs=>@paragraphs, )
      end
      
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