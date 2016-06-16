
# LogoBox is used in Namecard
# it has logo image, slogan, and company name
# it works similar to heading give x, y position 
module RLayout
class LogoBox < Container
  attr_accessor :logo_object, :slogan_object, :company_object
  
  def initialize(options={})
    super
    set_content(options)
    
    self
  end
  
  def set_content(options)
    if options[:image]
      @logo_object = image(options[:image], options)
    elsif options["image"]
      @logo_object = image(options["image"], options)
    end
    if options[:slogan]
      @slogan_object = slogan(options[:slogan], options)
    elsif options["slogan"]
      @slogan_object = slogan(options["slogan"], options)
    end
    if options[:company]
      @company_object = company(options[:company], options)
    elsif options["company"]
      @company_object = company(options["company"], options)
    end
    height_sum = 0
    height_sum +=@slogan_object.height    unless @title_object.nil?
    height_sum += 5
    height_sum +=@company_object.height unless @subtitle_object.nil?
    height_sum += 5
    @height = height_sum
    relayout!
  end
  
  def logo
    
  end
  
  def slogan
    atts                        = @current_style["body"]
    atts[:text_string]          = string
    atts[:width]                = @width
    atts[:text_fit_type]        = 'adjust_box_height'
    atts[:layout_expand]        = [:width]
    atts[:fill_color]           = options.fetch(:fill_color, 'clear')
    atts                        = options.merge(atts)
    atts[:parent]               = self
    @slogan_object              = Text.new(atts)
    @slogan_object.layout_length = @slogan_object.height
    @slogan_object
  end
  
  def company
    atts                        = @current_style["title"]
    atts[:text_string]          = string
    atts[:width]                = @width
    atts[:text_fit_type]        = 'adjust_box_height'
    atts[:layout_expand]        = [:width]
    atts[:fill_color]           = options.fetch(:fill_color, 'clear')
    atts                        = options.merge(atts)
    atts[:parent]               = self
    @company_object             = Text.new(atts)
    @company_object.layout_length = @company_object.height
    @company_object
  end
  
end
end