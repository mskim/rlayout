module RLayout

  # ImagePlus
  # ImagePlus adds simple caption using Text to Image Object
  # if caption_from_basename is true use filename as caption
  # underbar in filename is replaced as " ". 
  # some_caption_in_filename => "some caption in filename"
  # last underbar with following alphabet or nubmer is removed since it is used for duplicate name id
  #   홍길동_A => "홍길동" 
  #   Lee_Min_Jee_6 => "Lee Min Jee"
  # image_style contains style of ImagePlus
  #  {fit_type, frame, caption}

  # for more complex caption use NewsImage
  # NewsImage adds CaptionTitle, caption, source
  class ImagePlus < Container
    attr_reader :image_path, :image_style, :caption, :caption_from_basename, :project_path
    attr_reader :shape

    def initialize(options={})
      @image_path               = options[:image_path]
      unless @image_path
        puts "image_path not found!!!"
        return
      end
      @caption                  = options[:caption]
      #  TODO this works only with .jpg extension
      if !@caption && options[:caption_from_basename]
        @ext = '.jpg'
        @caption = File.basename(@image_path, @ext).unicode_normalize
      end
      filter_captopn_name if @caption
      @project_path             = options[:project_path]
      @image_style              = options.fetch(options[:image_style], default_image_style)
      image_options             = @image_style.dup
      options[:fill_color]      = 'clear'
      super

      image_options[:width]        = @width
      image_options[:height]       = @height
      image_options[:parent]       = self
      image_options[:image_path]   = @image_path
      image_options[:project_path] = @project_path
      image_options[:fill_color]   = 'clear'
      image_options[:shape]        = options[:shape]
      caption_width                = @width
      caption_height               = @height/10
      # need caption_height to clip circle above the caption 
      image_options[:caption_height] = caption_height
      # image_options[:caption_height] = 0 unless @caption
      @image_object                = Image.new(image_options)
      if @caption
        text_options                = @image_style.dup
        text_options[:parent]       = self
        text_options[:y]            = @height - caption_height
        text_options[:height]       = caption_height
        text_options[:width]        = @width
        text_options[:text_string]  = @caption
        text_options[:v_alignment]  = 'center'
        text_options[:font_size]    = caption_height*0.7
        @caption_object = Text.new(text_options)
      end
    end

    def filter_captopn_name
      if @caption=~/(_[\da-zA-Z])$/
        @caption.sub!($1, "")
      end
      if @caption.include?("_")
        @caption.gsub!("_", " ")
      end
    end

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