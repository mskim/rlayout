  # FlippedView implements flliped view of pdf view,
  # Drawing in PDF coordinate was driving some people to madness.
  # for the mental health of rest of us.

module RLayout
  class FlippedView
    attr_reader :graphic, :x ,:y ,:width, :height
    attr_reader :left_margin ,:top_margin ,:right_margin, :bottom_margin
    attr_reader :left_inset ,:top_inset ,:right_inset, :bottom_inset

    def initialize(graphic, options={})
      # @graphic  = graphic
      @fill     = @graphic.fill
      @stroke   = @graphic.stroke

      if @graphic.parent
        # p_origin = @parent.flipped_origin
        # [p_origin[0] + @x, p_origin[1] - @y]
      else
        # # [@x, @height - @y - @top_inset]
        # [@x, @height - @y]
        @x      = @graphic.x
        @y      = @graphic.height
        @width  = @graphic.width
        @height = @graphic.height
      end

      draw_pdf(canvas)
      self
    end


    def draw_pdf(canvas)
      @pdf_doc = parent.pdf_doc if parent
      @flipped = flipped_origin
      draw_fill(canvas)
      draw_image(canvas) if @image_path || @local_image
      draw_text(canvas)  if @has_text
      draw_stroke(canvas)
    end

    def draw_stroke

    end

    def draw_fill

    end

    def draw_image

    end

    def draw_text

    end

  end

end