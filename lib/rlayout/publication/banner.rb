
# class AttText
# end

# bold
# italic

# bigger
# smaller
# outline
# outline2
# outline_shadow

# white
# clear
# red
# blue
# yellow
# black

module RLayout

  class Banner < Container
    attr_accessor :title, :subtitle, :place, :when, :organization, :image, :logo, :bg_image
    attr_accessor :category
    
    def initialize(options={}, &block)
      options[:width]   = "10m" unless options[:width]
      options[:height]  = "50cm" unless options[:height]
      super
      @title          = options[:title]
      @subtitle       = options[:subtitle]
      @place          = options[:place]
      @when           = options[:when]
      @organization   = options[:organization]
      self
    end
  end
end


