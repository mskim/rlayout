module RLayout

  # this is for Isbn page
  # where book inforamtion is read from story.md
  # text is split into lines text
  # line text is applied with md markup
  # *bold*: plain
  # ## h2 text with stroke_side defined in text_style
  # text should grow from bottom
  class InfoArea < Container
    attr_reader :text_grow_direction
    attr_reader :story_md

    def initilaize(options={})
      @text_grow_direction = options[:options] || :up
      # grid_frame2_rect
      super
      
      # read_story
      # layout_story
      self
    end

    def set_content
      
    end
  end

end