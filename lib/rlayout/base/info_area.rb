module RLayout

  # this is for Isbn page
  # where book inforamtion is read from story.md
  # text should grow from bottom
  class InfoArea < RColumn
    attr_reader :text_grow_direction
    attr_reader :story_md
    def initilaize(options={})
      @text_grow_direction = options[:options] || :up
      # grid_frame2_rect
      super
      
      read_story
      layout_story
      self
    end

    def story_md_path
      @story_md = @project_path + "/story.md"
    end

    def read_story
      File.open(story_md_path, 'r'){|f| f.read}
    end
    
    def layout_story

    end
  end

end