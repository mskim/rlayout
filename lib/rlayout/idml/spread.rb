#encode :utf-8

module RLayout
  class Spread < XMLPkgDocument
    attr_accessor :spread_attributes, :pages, :text_frames
    def initialize(spread_xml_text)
      super      
      parse_spread
      self
    end
    
    def parse_spread
      spread_children    = @element.elements
      @spread_attributes        = spread_children.first.attributes
      @pages                    = []
      @spread_children_graphics = []
      spread_children.each do |spread_child|
        case spread_child.name
        when 'Page'
          @pages << IdPage.new(spread_child)
        when 'TextFrame'
          @spread_children_graphics << IdTextFrame.new(spread_child)
        else
          # puts "spread_child.name:#{spread_child.name}"
        end
      end      
    end   
    
  end  
end


__END__
# What is spread and why use it?
# Spread is left and right page unit of book.
# Magazine publishers work in spreads, because spread is what reader sees, not a single page.
# There are cases where a single picture is layout across two pages.
# So, it is natural for DTP applications to work in unit of spread.
# How do you manage the page coordinate?
# In QuarkXpress and MLayout, spread origin is at top left corner.
# So, the right_side_page_origin_x = left_page_origin + left_page_width + page_gutter 

# Following are two confusing parts in IDML that are different from other page layout application.
 
# IDML Spread Coordinate System
#    IDML spread origin is at the center of the Spread, between two pages in x-axis, and at the vertical center in y-axis.
#    So the left side page items have negative x values, and top page items have negative y values.  
#    IDML uses transformation matrix to shift, rotate, skew ...from one Coordinate system to other other
#    same as PostScript transformation.  

# IDML Page Item frame
#    Rather than having a rectangle for the frame, IDML uses bezier path points with anchor points and
#    right and left side curve extension points. 
#    It is same as drawing besier path, it even has open or closed path flag. 
#    Anchor points are drawn in counter clockwise.
#    So for rectangles, there are 4 Anchor points and each anchor point has two supporting curve points.
#    But for rectangle, supporting curve points are identical to the anchor points, since there are no curves in Rectangle.
#    This is very flexible way of represent any shaped page items. 


module Idml
  
  class PageItem
    
    attr_accessor :Klass, :name, :story_title, :content_type, :allow_overrides, :fill_color, :fill_tint 
    attr_accessor :overprint_fill, :stroke_weight, :miter_limit, :end_cap, :end_join, :stroke_type
    attr_accessor :stroke_corner_adjustment, :stroke_dash_and_gap, :left_line_end, :right_line_end
    attr_accessor :stroke_color, :stroke_tint, :corner_radius, :gradient_fill_start, :gradient_fill_length
    attr_accessor :gradient_fill_angle, :gradient_stroke_start, :gradient_stroke_length, :gradient_stroke_angle
    attr_accessor :overprint_stroke, :gap_color, :gap_tint, :overprint_gap, :stroke_alignment, :nonprinting
    attr_accessor :item_layer, :locked, :local_display_setting, :gradient_fill_hilite_length
    attr_accessor :gradient_fill_hilite_angle, :gradient_stroke_hilite_length, :gradient_stroke_hilite_angle
    attr_accessor :applied_object_style, :corner_option, :item_transform

    def initialize(hash)
      # puts "++++++ init of PageItem"
      @self                          = hash['Self']
      @name                          = hash['Name']
      @story_title                   = hash['StoryTitle']
      @content_type                  = hash['ContentType']
      @allow_overrides               = hash['AllowOverrides']
      @fill_color                    = hash['FillColor']
      @fill_tint                     = hash['FillTint']
      @overprint_fill                = hash['OverprintFill']
      @stroke_weight                 = hash['StrokeWeight']
      @miter_limit                   = hash['MiterLimit']
      @end_cap                       = hash['EndCap']
      @end_join                      = hash['EndJoin']
      @stroke_type                   = hash['StrokeType']
      @stroke_corner_adjustment      = hash['StrokeCornerAdjustment']
      @stroke_dash_and_gap           = hash['StrokeDashAndGap']
      @left_line_end                 = hash['LeftLineEnd']
      @right_line_end                = hash['RightLineEnd']
      @stroke_color                  = hash['StrokeColor']
      @stroke_tint                   = hash['StrokeTint']
      @corner_radius                 = hash['CornerRadius']
      @gradient_fill_start           = hash['GradientFillStart']
      @gradient_fill_length          = hash['GradientFillLength']
      @gradient_fill_angle           = hash['GradientFillAngle']
      @gradient_stroke_start         = hash['GradientStrokeStart']
      @gradient_stroke_length        = hash['GradientStrokeLength']
      @gradient_stroke_angle         = hash['GradientStrokeAngle']
      @overprint_stroke              = hash['OverprintStroke']
      @gap_color                     = hash['GapColor']
      @gap_tint                      = hash['GapTint']
      @overprint_gap                 = hash['OverprintGap']
      @stroke_alignment              = hash['StrokeAlignment']
      @nonprinting                   = hash['Nonprinting']
      @item_layer                    = hash['ItemLayer']
      @locked                        = hash['Locked']
      @local_display_setting         = hash['LocalDisplaySetting']
      @gradient_fill_hilite_length   = hash['GradientFillHiliteLength']
      @gradient_fill_hilite_angle    = hash['GradientFillHiliteAngle']
      @gradient_stroke_hilite_length = hash['GradientStrokeHiliteLength']
      @gradient_stroke_hilite_angle  = hash['GradientStrokeHiliteAngle']
      @applied_object_style          = hash['AppliedObjectStyle']
      @corner_option                 = hash['CornerOption']
      @item_transform                = hash['ItemTransform']
      self
    end
    
    def in_left_side?
      frame[0].to_f < 0
    end
    
    def to_xml
      
    end
    
   
    def frame
      bounds = []
      @properties['PathGeometry']['GeometryPathType']['PathPointArray']['PathPointType'].each do |point|
        bounds << point['Anchor'].split(" ")
      end
      
      # rext = [left, top, right - left, top-bottom]
      rect = [bounds[0][0],bounds[0][1], bounds[2][0],bounds[2][1]]
      # translate matrix
      matrix = @item_transform.split(" ")
      x_tran = matrix[4]
      y_tran = matrix[5]
      [rect[0].to_f+x_tran.to_f,rect[0].to_f + y_tran.to_f,rect[0],rect[0]]
    end
    
    def to_hash
      h={}
      h[:klass] = @klass
      h[:id]    = @self
      h[:frame] = frame
      # Hash[instance_variables.map { |name| [name, instance_variable_get(name)] } ]
      h
    end
  end
  
  class Rectangle < PageItem
    attr_accessor
    
    def initialize(hash)
      super
      @klass = "Rectangle"
      self
    end
  end
  
  class Oval < PageItem
    attr_accessor
    def initialize(hash)
      super
      @klass = "Oval"
      self
    end    
  end
  
  class GraphicLine < PageItem
    attr_accessor
    def initialize(hash)
      super
      @klass = "GraphicLine"
      self
    end
  end
  
  class Polygon < PageItem
    attr_accessor
     def initialize(hash)
       super
       @klass = "Polygon"
       self
     end
  end
  
  class Group < PageItem
    attr_accessor
     def initialize(hash)
       super
       @klass = "Group"
       self
     end
  end
  
  class Button < PageItem
     def initialize(hash)
       super
       @klass = "Button"
       self
     end
     
  end
  

  
  class Spread
    attr_accessor :name, :document, :section
    attr_accessor :flattener_override, :allow_page_shuffle, :item_transform, :show_master_items
    attr_accessor :page_count, :binding_location, :page_transition_type, :page_transition_direction
    attr_accessor :page_transition_duration, :flattener_preference 
    attr_accessor :pages
    attr_accessor :page_items # text_frame, rectangle, polygon, oval, group, graphic_line
        
    def initialize(document, xml, options={})
      @document                    = document
      @pages                       = []
      @text_frames                 = []
      @page_items                  = []
      hash                         = xml
      hash                   = Hash.from_xml(xml)
      
      # hash                         = hash['Spread'] # flatten hash
      # @flattener_override          = hash['FlattenerOverride']
      # @allow_page_shuffle          = hash['AllowPageShuffle']
      # @item_transform              = hash['ItemTransform']
      # @show_master_items           = hash['ShowMasterItems']
      # @page_count                  = hash['PageCount']
      # @binding_location            = hash['BindingLocation']
      # @page_transition_type        = hash['PageTransitionType']
      # @page_transition_direction   = hash['PageTransitionDirection']
      # @page_transition_duration    = hash['PageTransitionDuration']
      # @flattener_preference        = hash['FlattenerPreference']
      
      # if hash['Page'].is_a?(Array)
      #   hash['Page'].each do |page_hash| 
      #     @pages << Page.new(page_hash)
      #   end
      # else
      #   @pages << Page.new(hash['Page'])
      # end
      # 
      # if hash['TextFrame'] && hash['TextFrame'].is_a?(Array)
      #   hash['TextFrame'].each do |text_frame_hash| 
      #     @page_items << TextFrame.new(text_frame_hash)
      #   end
      # elsif hash['TextFrame']
      #   @page_items << TextFrame.new(hash['TextFrame'])
      # end
      # 
      # 
      # if hash['Rectangle'] && hash['Rectangle'].is_a?(Array)
      #   hash['Rectangle'].each do |item_hash| 
      #     @page_items << Rectangle.new(item_hash)
      #   end
      # elsif hash['Rectangle']
      #   @page_items << Rectangle.new(hash['Rectangle'])
      # end
      # #polygon, oval, group, graphic_line
      # if hash['Polygon'] && hash['Polygon'].is_a?(Array)
      #   hash['Polygon'].each do |item_hash| 
      #     @page_items << Polygon.new(item_hash)
      #   end
      # elsif hash['Polygon']
      #   @page_items << Polygon.new(hash['Polygon'])
      # end
      # 
      # if hash['Oval'] && hash['Oval'].is_a?(Array)
      #   hash['Oval'].each do |item_hash| 
      #     @page_items << Oval.new(item_hash)
      #   end
      # elsif hash['Oval']
      #   @page_items << Oval.new(hash['Oval'])
      # end
      # 
      # if hash['Group'] && hash['Group'].is_a?(Array)
      #   hash['Group'].each do |item_hash| 
      #     @page_items << Group.new(item_hash)
      #   end
      # elsif hash['Group']
      #   @page_items << Group.new(hash['Group'])
      # end
      # 
      # if hash['GraphicLine'] && hash['GraphicLine'].is_a?(Array)
      #   hash['GraphicLine'].each do |item_hash| 
      #     @page_items << GraphicLine.new(item_hash)
      #   end
      # elsif hash['GraphicLine']
      #   @page_items << GraphicLine.new(hash['GraphicLine'])
      # end
      # 
      self
    end

    # collect page items that belong to left page of spread
    def left_page_items
      items = []
      @page_items.each do |page_item|
        items << page_item.to_hash if page_item && page_item.in_left_side?
      end
      items
    end
    
    # collect page items that belong to right page of spread
    def right_page_items
      items = []
      @page_items.each do |page_item|
        items << page_item.to_hash unless page_item.in_left_side?
      end
      items     
    end
    
    def	pages_hash
    	pages_array = []
    	page_hash = @pages[0].to_hash
    	page_hash[:graphics] = left_page_items
    	pages_array << page_hash
    	
    	if @pages.length > 1
    	  page_hash = @pages[1].to_hash
    	  page_hash[:graphics] = right_page_items
    	  pages_array << page_hash
    	end
    	
    	pages_array
    end
  
  end

end
