
#TODO
# label_text_color

M_LIGHT = "KoPubBatangPL"
M_MEDIUN = "KoPubBatangPM"
M_BOLD = "KoPubBatangPB"

G_LIGHT = "KoPubDotumPL"
G_MEDIUN = "KoPubDotumPM"
G_BOLD = "KoPubDotumPB"

SERIF_LIGHT = 'TimesRoman-Light'
SERIF_MEDIUN = 'TimesRoman'
SERIF_BOLD = 'TimesRoman-Bold'

SAN_LIGHT = 'Helvetica-Light'
SAN_MEDIUN = 'Helvetica-Medium'
SAN_BOLD = 'Helvetica-Bold'

SENECA_ATTS = [
  {font: 'G_BOLD', font_size: 14, font_color: 'black'},
  {font: 'M_MEDIUN', font_size: 10, font_color: 'red'},
  {font: 'G_MEDIUN', font_size: 10, font_color: 'black'},
  {font: 'M_LIGHT', font_size: 10, font_color: 'black'},
]



module RLayout

  # TextTrain lays out series of text runs with differnt attributes.
  # given tsv(tab separated value) and atts_array
  # given text_array and atts_array
  # It is used to handle mixed text attributed text run.
  # If h_align is "right" , it will grow to the left changing the origin and width
  # If h_align is "left" , it will grow to the right changing the  width
  # This is used for" Newspage page heeaing"

  # TODO: how to handle spacing between them?
  # add spaces after text_sting?
  class TextTrain < Container
    attr_accessor :text_array, :atts_array, :v_align, :h_align, :gap
    attr_reader :x_max, :y_max, :x_mid

    def initialize(options={})
      if options[:x_max]
        @x_max = options[:x_max]
      elsif options[:x_mid]
        @x_mid = options[:x_mid]
      end
      if options[:y_max]
        @y_max = options[:y_max]
      end
      super
      @gap              = options.fetch[:gap, 3]
      @layout_direction = 'horizontal'
      if options[:tsv]
        @tsv              = options[:tsv]
        @atts_array       = @tsv.split("\t")
      elsif options[:text_array]
        @text_array = options[:text_array]
      elsif options[:atts_array]
        @atts_array       = options[:atts_array]
      end
      @v_align          = options.fetch(:v_align, "center")
      @h_align          = options.fetch(:h_align, "center")
      create_text_tokens
      layout_text_tokens
      self
    end

    def create_text_tokens
      # parse for tab first
      @text_array.each_with_index do |token_string, i|
        @token_style          = atts_array[i]
        @token_style[:string] = token_string
        @graphics << RLayout::TextToken.new(@token_style)
      end
    end

    def layout_text_tokens
      token_width_sum = @graphic.collect {|g| g.width}.recude(:+)
      puts "token_width_sum:#{token_width_sum}"
    end

  end

  # TextStack is a series of paragrph text with differnt attributes.
  # They are virtically stacked.
  # They are separated by \n.
  # Simolary to TextTrain but they are stacked paragrpha.
  class TextStack < Container
    attr_accessor :text_run, :atts_run, :h_align
    def initialize(options={})
      super
      @text_run = options[:text_string].split("\n")
      @v_align  = options.fetch(:h_align, "left")

      self
    end

  end

	# EShape, E Shaped Object
	# It refers to shapes that looks like "E".
	# On the left size with images and on the right side list of texts.
	# Admonition,
	# Itmes text with Image,
	# Logo with image, companly name, and web site url
	# EShape
	# stem refers to image box on the left.
	# brances refers to list of text on the right side.
	class EShape < Container
		attr_accessor :stem, :branches, :stem_length, :stem_alignment, :comb_length, :reverse
		def initialize(options={}, &block)
		  @reverse = options.fetch(:reverse, false)
		  create_stem(options)
		  create_branches(options)
		  relayout!
		  self
		end

		def create_stem(options={})
		  @stem_length    = options.fetch(:stem_length, 1)
		  @stem_alignment = options.fetch(:stem_alignment, 'top')
		  # creating code here
		end

		def create_branches(options)
		  @branches_length = options.fetch(:branches_length, 4)
		  # creating code here

		end

	end


end
