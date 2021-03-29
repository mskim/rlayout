module RLayout

  # ImagePlus
  # ImagePlus adds simple caption using Text to Image Object
  # if filename_caption is true use filename as caption
  # underbar in filename is replaced as " ". 
  # some_caption_in_filename => "some caption in filename"
  # last underbar with following alphabet or nubmer is removed since it is used for duplicate name id
  #   some_name_A, lee_min_jee_6
  # image_style contains style of ImagePlus
  #  {fit_type, frame, caption}
  # NewsImage adds CaotionTitle, caption, source, a more complex caption

  class ImagePlus < Container
    attr_reader :image_path, :image_style, :caption, :filename_caption, :project_path
    def initialize(options={})
      @image_path               = options[:image_path]
      @caption                  = options[:caption]
      @project_path             = options[:project_path]
      @image_style              = options.fetch(options[:image_style], default_image_style)
      @caption                  = File.basename(options[:image_path], ".*")  if options[:filename_caption]
      image_options             = @image_style.dup
      super

      image_options[:width]        = @width
      image_options[:height]       = @height
      image_options[:parent]       = self
      image_options[:image_path]   = @image_path
      image_options[:project_path] = @project_path
      caption_width               = @width
      @image_object               = Image.new(image_options)
      if @caption
        text_options                = @image_style.dup
        text_options[:parent]       = self
        text_options[:y]            = @height - 12
        text_options[:height]       = 12
        text_options[:width]        = @width
        text_options[:text_string]  = @caption 
        @caption_object = Text.new(text_options)
      end
    end

    def default_image_style
      {
        fit_type:3,
        frame_sides:[1,1,1,1], 
        font:'KoPubDotumPL',
        font_size:9,
        text_alignment:'center',
      }
    end
  end
end