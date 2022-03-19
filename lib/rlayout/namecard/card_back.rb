module RLayout
  class CardBack < Container
    attr_reader :grid
    attr_accessor :text_style, :document_path
    attr_accessor :personal_info, :company_info, :logo
    attr_reader :en_personal_info, :en_company_info, :logo
    attr_accessor :personal_object, :company_object, :logo_object
    def initialize(options={}, &block)
      options[:paper_size] = 'NAMECARD'
      options[:fill_color] = 'yellow'
      options[:left_inset] = 10
      options[:top_inset] = 10
      options[:right_inset] = 10
      options[:bottom_inset] = 10
      @grid = options[:paper_size] || [6,12]
      super
      self
    end

    def set_content
      if @text_style
        current_style = RLayout::StyleService.shared_style_service.current_style = @text_style
      else  
        current_style = RLayout::StyleService.shared_style_service.current_style = YAML::load(default_text_style)
      end
      # if @personal_info
      #   @personal_object.set_content(@personal_info) 
      # end
      # if @company_info
      #   @company_object.set_content(@company_info) 
      # end
      # if @logo_info      
      #   @logo_object.set_content(@logo_info) 
      # end
    end

    def en_personal(grid_frame)
      h = {}
      h[:parent] = self
      h[:grid_frame]  = grid_frame
      @personal_object = RLayout::Area.new(h)
    end

    def en_company(grid_frame)
      h = {}
      h[:parent] = self
      h[:grid_frame]  = grid_frame
      @company_object = RLayout:Area.new(h)
    end

    def logo(grid_frame)
      h = {}
      h[:parent] = self
      h[:grid_frame]  = grid_frame
      @logo  = RLayout::Area.new(h)
    end
  end
end