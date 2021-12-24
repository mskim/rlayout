module RLayout

  # ImagePlus
  # ImagePlus adds simple caption to Image Object
  # if caption is given it uses given caption otherwise, leaves empty room for spacing 

  # for more complex caption use NewsImage
  # NewsImage adds CaptionTitle, caption, source
  class ImagePlus < Container
    attr_reader :image_path, :image_style, :caption, :caption_from_basename, :project_path
    attr_reader :shape, :image_info

    def initialize(options={})
      @image_path               = options[:image_path]
      unless @image_path
        puts "image_path not found!!!"
        return
      end
      options[:fill_color]      = 'clear'
      super
      @caption = options[:caption]  || options['caption']
      image_options = {}
      image_options[:width]        = @width
      if options[:left_inset]
        # this is done to give a room between image and text.
        image_options[:x] = options[:left_inset]
        image_options[:width] -= options[:left_inset]
      elsif options[:right_inset]
        image_options[:width] -= options[:right_inset]
      elsif options[:both_sides_inset]
        image_options[:x] += options[:both_sides_inset]
        image_options[:width] -= options[:both_sides_inset]*2
      end
      image_options[:height]       = @height - 10
      image_options[:parent]       = self
      image_options[:image_path]   = @image_path
      image_options[:fill_color]   = 'clear'
      image_options[:shape]        = options[:shape]
      caption_width                = @width
      # TODO: this should be the height of captopn
      # caption_height               = @height/10
      caption_height               = @height/16
      # need caption_height to clip circle above the caption 
      image_options[:caption_height] = caption_height
      # image_options[:caption_height] = 0 unless @caption
      @image_object                = Image.new(image_options)
      if @caption
        text_options                = @image_style.dup || default_image_style
        text_options[:parent]       = self
        text_options[:y]            = @height - caption_height
        text_options[:height]       = caption_height
        text_options[:width]        = @width
        text_options[:text_string]  = @caption.unicode_normalize
        text_options[:v_alignment]  = 'center'
        # text_options[:font_size]    = caption_height*0.7
        text_options[:font_size]    = 8.0
        @caption_object = Text.new(text_options)
      end
    end

    # def filter_caption_name(caption)
    #   if caption=~/(_[\da-zA-Z])$/
    #     caption.sub!($1, "")
    #   end
    #   if caption.include?("_")
    #     caption.gsub!("_", " ")
    #   end
    #   caption
    # end

    def default_image_style
      {
        fit_type:3,
        frame_sides:[1,1,1,1], 
        # font:'KoPubDotumPL',
        font:'KoPubBatangPM',
        font_size:9,
        text_alignment:'center',
      }
    end
  end
end