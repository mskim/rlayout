module RLayout
  class Graphic
    def init_fill(options)
      if options[:fill_type]    == 'gradiation'
        @fill                   = LinearGradient.new("CMYK=0,0,0,0","CMYK=0,0,0,100")
        @fill.starting_color    = options[:fill_color]        if options[:fill_color]
        @fill.starting_color    = options[:starting_color]    if options[:starting_color]
        @fill.ending_color      = options[:fill_other_color]  if options[:fill_other_color]
        @fill.ending_color      = options[:fill_ending_color] if options[:fill_ending_color]
      elsif options[:fill_type] == 'radial'
        @fill = RadialGradient.new("CMYK=0,0,0,0","CMYK=0,0,0,100")
        @fill.starting_color    = options[:fill_color]        if options[:fill_color]
        @fill.starting_color    = options[:starting_color]    if options[:starting_color]
        @fill.ending_color      = options[:fill_other_color]  if options[:fill_other_color]
        @fill.ending_color      = options[:fill_ending_color] if options[:fill_ending_color]
      elsif options[:fill_image]
        # ImageStruct = Struct.new(:image_path, :fit_type, :rotation) do
        @fill                   = ImageStruct.new(options[:fill_image])
        @fill.fit_type          = options[:fill_image_fit_type] if options[:fill_image_fit_type]
        @fill.rotation          = options[:fill_image_rotation] if options[:fill_image_rotation]
      else
        @fill                   = FillStruct.new("CMYK=0,0,0,0")
        @fill[:color]           = options[:fill_color]        if options[:fill_color]
        puts "++++ @fill[:color]:#{@fill[:color] }" if @fill[:color] == "CMYK=20,100,50,10"
      end

    end
  end
end
