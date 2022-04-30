module RLayout



  class TextBar < Container
    attr_reader :grid_frame
    attr_reader :content
    attr_reader :tag
    attr_reader :alignment   # left, center right justify
    attr_reader :v_alignment # top, center, bottom

    def initialize(options={})
      @grid_frame = options[:grid_frame]
      super
      @tag = options[:tag]
      @content = options[:content]
      self
    end

    # set_content
    # set_content can be called at intialization time if @content is not nil
    # or called as batch mode with content is passed as options content: content
    # this is to support batch mode with  csv file.
    def set_content(content_hash)
      @graphics = []
      y_position = 3
      x_position = @left_margin || 10
      content_hash.each do |k,v|
        h = {}
        h[:parent] = self
        h[:style_name] = 'body'
        h[:style_name] = k.to_s if v
        h[:x] = x_position
        h[:y] = y_position
        h[:width] = @width
        h[:text_string] = v
        h[:text_fit_type] = "fit_box_to_text"
        object = Text.new(h)

        case @v_alignment
        when 'top'
          top = 0
        when 'bottom'
        else
          # center
          # binding.pry
          top = (@height - object.height)/2
          object.y = top
        end
        x_position += object.width + 10
      end

      # TODO
      # aline text center 
      case @alignment
      when 'left'
  
      when 'cener'
        rect = @width - @left_margin - @right_margin
        width_sum = @graphics.map{|g| g.width}.reduce(:*)
        space_sum = (@graphics.length -1) * 10
        off_set = (rect - width_sum - space_sum)/2
        @graphics.map{|g| g.x += off_set}
      when 'right'
        rect = @width - @left_margin - @right_margin
        width_sum = @graphics.map{|g| g.width}.reduce(:*)
        space_sum = (@graphics.length -1) * 10
        off_set = (rect - width_sum - space_sum)
        @graphics.map!{|g| g.x += off_set}

      when 'justify'

      end


    end
  end

  class TextBarV < Container
   attr_reader :grid_frame
   attr_reader :content
   attr_reader :v_alignment
   attr_reader :tag
   def initialize(options={})
     @grid_frame = options[:grid_frame]
     super
     @tag = options[:tag]
     @content = options[:content]
     # set_content if @content && @content != {}
     self
   end

   # set_content
   # set_content can be called at intialization time if @content is not nil
   # or called as batch mode with content is passed as options content: content
   # this is to support batch mode with  csv file.
   def set_content(content_hash)
     @graphics = []
     y_position = 3
     content_hash.each do |k,v|
       h = {}
       h[:parent] = self
       h[:style_name] = 'body'
       h[:style_name] = k.to_s if v
       h[:x] = 3
       h[:y] = y_position
       h[:width] = @width
       h[:text_string] = v
       object = TextV.new(h)
       y_position += object.height
     end
   end
  end






end