
module RLayout
  
  class BlogStory < Story
    attr_accessor :url, :user_name, :password, :blog_story
    
    def initialize(options={})
      @url        = options[:url]
      @user_name  = options[:user_name]
      @password   = options[:password]
      super
      if @blog_story = parse_blog
        # set content
        @heading     = blog_story.fetch(:heading, story_defaults)
        @published  = heading.fetch(:published, false)
        @paragraphs = blog_story.fetch(:paragraphs,[])
        
      else
        puts "Parsing @@url:#{@url} failed !!!"
        return nil
      end
      self
    end
    
    # with given url, get the site name
    def get_url_kind(given_url)
      
    end
    
    def parse_blog
      case get_url_kind(@url)
        
      when 'facebook'
        parse_naver
      when 'tumbler'
        parse_tumbler
      when 'naver'
        parse_naver
      when 'wordpress'
        
      else
        
      end
    end
    
    def parse_naver
      
    end
    
    def parse_facebook
      
    end
    
    def parse_tumbler
      
    end
    
    def parse_wordpress
      
    end
  end
  
  
end