# MultipleStoryArticle
# We could have multiple unrelated stories with text and image, in a document.
# Those items may be represented in StoryBox and they are assembled using MultipleStoryArticle. .
# We could treat them similar to newspaper articles.
# StoryBox information are stored in form of story_*.md.

# default grid_width is 1
# default grid_height is expandable

# story text example
# 
# ---
# title: some title
# at: [0,0]
# image: some local image
# 
# ---
#
# # This is text text for item
# And some more follows.


module RLayout
  class MultipleStoryArticle
    attr_accessor :project_path, :items
    def initialize(options={})
      @project_folder = options[:project_path]
      read_story
      layout_story
      self
    end
    
    def read_story
      Dir.glob("#{@project_path}/item*.md").each do 
        
        
      end
      
    end
    
    def layout_story
      
    end
  end
  
	class StoryBox < Container
	
	
	end


end