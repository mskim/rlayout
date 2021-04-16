module RLayout
  class YearbookPage < Container
    attr_reader :path_path, :template_path, :page_kind
    attr_reader :page_number, :content_profile
    def initialize(options={})
      @parent     = options[:parent]
      @path_path  = options[:path_path]
      super
      @page_kind      = options[:page_kind]
      @template_path  = 
      @width          = @parent.width
      @height         = @parent.height
      @left_margin    = @parent.left_margin
      @top_margin     = @parent.top_margin
      @right_margin   = @parent.right_margin
      @bottom_margin  = @parent.bottom_margin
      layout_page
      self
    end

    def layout_page
      parse_page_content

      
    end

    def parse_page_content
      # content_profile content and create conten_profile
      # get template with matching conten_profile

    end
  end
  
  
end