module RLayout
  class Graphic
    def init_fill(options)
      if options[:fill_type] == 'gradiation'
        @fill = LinearGradient.new('white','black')
        @fill.starting_color = options[:fill_color]         if options[:fill_color]
        @fill.starting_color = options[:starting_color]     if options[:starting_color]
        @fill.ending_color = options[:fill_other_color]     if options[:fill_other_color]
        @fill.ending_color = options[:fill_ending_color]    if options[:fill_ending_color]
        @fill[:starting_color]  = options[:fill_color]        if options[:fill_color]
        @fill[:ending_color]    = options[:fill_other_color]  if options[:fill_other_color]    
      elsif options[:fill_type] == 'radial'
        @fill = RadialGradient.new('white','black')
        @fill.starting_color = options[:fill_color]         if options[:fill_color]
        @fill.starting_color = options[:starting_color]     if options[:starting_color]
        @fill.ending_color = options[:fill_other_color]     if options[:fill_other_color]
        @fill.ending_color = options[:fill_ending_color]    if options[:fill_ending_color]
        @fill[:starting_color]  = options[:fill_color]        if options[:fill_color]
        @fill[:ending_color]    = options[:fill_other_color]  if options[:fill_other_color]    
      else
        @fill = FillStruct.new('white')
        @fill[:color] = options[:fill_color] if options[:fill_color]
      end
    end
  end
end