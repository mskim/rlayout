

STYLES={
  "Title"   =>{:text_font => 'Times', :text_size=>52.0, :text_color => 'red', :text_alignment=>'center'},
  "title"   =>{:text_font => 'Times', :text_size=>52.0, :text_color => 'red', :text_alignment=>'center'},
  "SubTitle"=>{:text_font => 'Times', :text_size=>36.0, :text_color => 'black'},
  "subtitle"=>{:text_font => 'Times', :text_size=>36.0, :text_color => 'black'},
  "Author"  =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'green', :text_alignment=>'right'},
  "author"  =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'green', :text_alignment=>'right'},
  "Lead"    =>{:text_font => 'Helvetica', :text_size=>24.0, :text_color => 'black'},
  "lead"    =>{:text_font => 'Helvetica', :text_size=>24.0, :text_color => 'black'},
  "Leading" =>{:text_font => 'Times', :text_size=>24.0, :text_color => 'black'},
  "leading" =>{:text_font => 'Times', :text_size=>24.0, :text_color => 'black'},
  "h1"      =>{:text_font => 'Helvetica', :text_size=>70.0, :text_color => 'black'},
  "h2"      =>{:text_font => 'Helvetica', :text_size=>36.0, :text_color => 'black'},
  "h3"      =>{:text_font => 'Helvetica', :text_size=>24.0, :text_color => 'black'},
  "h4"      =>{:text_font => 'Helvetica', :text_size=>16.0, :text_color => 'black'},
  "h5"      =>{:text_font => 'Helvetica', :text_size=>16.0, :text_color => 'black'},
  "Head"    =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "head"    =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "h6"      =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "p"       =>{:text_font => 'Times', :text_size=>10.0, :text_line_spacing=>10, :text_color => 'black'},
  "Body"    =>{:text_font => 'Times', :text_size=>10.0, :text_line_spacing=>10, :text_color => 'black'},
  "body"    =>{:text_font => 'Times', :text_size=>10.0, :text_line_spacing=>10, :text_color => 'black'},
  "caption" =>{:text_font => 'Times', :text_size=>8.0, :text_color => 'black', :text_alignment=>'center'},
}

NEWS_STYLES={
  "Title"   =>{:text_font => 'Times', :text_size=>36.0, :text_color => 'black', :text_alignment=>'center'},
  "title"   =>{:text_font => 'Times', :text_size=>36.0, :text_color => 'black', :text_alignment=>'center'},
  "SubTitle"=>{:text_font => 'Times', :text_size=>20.0, :text_color => 'black'},
  "subtitle"=>{:text_font => 'Times', :text_size=>20.0, :text_color => 'black'},
  "Author"  =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'black', :text_alignment=>'right'},
  "author"  =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'black', :text_alignment=>'right'},
  "Lead"    =>{:text_font => 'Helvetica', :text_size=>18.0, :text_color => 'black'},
  "lead"    =>{:text_font => 'Helvetica', :text_size=>18.0, :text_color => 'black'},
  "Leading" =>{:text_font => 'Times', :text_size=>18.0, :text_color => 'black'},
  "leading" =>{:text_font => 'Times', :text_size=>18.0, :text_color => 'black'},
  "h1"      =>{:text_font => 'Helvetica', :text_size=>36.0, :text_color => 'black'},
  "h2"      =>{:text_font => 'Helvetica', :text_size=>20.0, :text_color => 'black'},
  "h3"      =>{:text_font => 'Helvetica', :text_size=>18.0, :text_color => 'black'},
  "h4"      =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "h5"      =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "Head"    =>{:text_font => 'Helvetica', :text_size=>18.0, :text_color => 'black'},
  "head"    =>{:text_font => 'Helvetica', :text_size=>18.0, :text_color => 'black'},
  "h6"      =>{:text_font => 'Helvetica', :text_size=>16.0, :text_color => 'black'},
  "p"       =>{:text_font => 'Times', :text_size=>12.0, :text_color => 'black'},
  "Body"    =>{:text_font => 'Times', :text_size=>12.0, :text_color => 'black'},
  "body"    =>{:text_font => 'Times', :text_size=>12.0, :text_color => 'black'},
  "caption" =>{:text_font => 'Times', :text_size=>8.0, :text_color => 'black', :text_alignment=>'center'},
}

HEADING_KIND= %w[h1 h2 h3 h4 title subtitle author lead]
BODY_KIND= %w[h5 h6 p heading1 heading2 heading3 body]

module RLayout 
  # read Styles Data
  # when asked, returns NSAttributedString for paragraph
  class StyleService
    attr_accessor :paragraph_styles, :char_styles
    
    @@style_service = nil
    def self.shared_style_service
      @@style_service ||= StyleService.new
    end
    
    def initialize(options={})
      if options[:style_file]
        # load style from disk
      end
      @paragraph_styles = options[:paragraph_styles]
      @char_styles      = options[:char_styles]
      
      self
    end
    
    def style_for(paragraph, options={})
      if options[:category] == "news" 
        NEWS_STYLES[paragraph[:markup]]
      else
        STYLES[paragraph[:markup]]
      end
    end
        
    def style_for_markup(markup, options={})
      if options[:category] == "news" 
        NEWS_STYLES[markup]
      else
        STYLES[markup]
      end
      
    end
    
    def self.cation_style
      StyleService.shared_style_service.style_for_markup('caption')
    end
    
    def self.image_caption(string, options={})
      style = StyleService.cation_style
      NSAttributedString.alloc.initWithString(string, attributes:style)
    end
    
    def self.product_caption(string, options={})
      caption_format_array = []
      caption_style = Container.cation_style
      format_type = options.fetch(:type, 'csv') # json or csv
    end
    
    def self.figure_caption(string, options={})
      caption_format_array = []
      caption_style = Container.cation_style
      format_type = options.fetch(:type, 'csv') # json or csv
    end
    
  end
  
end