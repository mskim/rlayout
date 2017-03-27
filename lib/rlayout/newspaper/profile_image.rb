

module RLayout
  class ProfileImage < Container
    attr_accessor :image_object, :profile_object, :image_to_profile_ratio, :image_path, :profile_text

    def initialize(options={})
      super
      @image_path               = options[:image_path]
      @profile_text             = options[:profile_text]
      @layout_direction         = "horizontal"
      @image_to_profile_ratio   = options.fetch(:image_to_profile_ratio, 2) # 1,2
      image_atts                = {}
      image_atts[:parent]       = self
      image_atts[:image_path]   = @image_path
      image_atts[:layout_length]= 1
      @image_object             = Image.new(image_atts)
      text_atts                 = {}
      text_atts[:parent]        = self
      text_atts[:text_string]   = @profile_text
      text_atts[:text_alignment]= "left"
      text_atts[:layout_length] = @image_to_profile_ratio
      @profile_object           = Text.new(text_atts)
      relayout!
      self
    end

  end
end
