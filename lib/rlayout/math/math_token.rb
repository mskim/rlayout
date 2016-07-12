module RLayout

  class MathParagraph < Paragraph
    attr_accessor :math_string
    
    def initialize(options={})
      super
      @math_string = options[:math_string]
      create_tokens
      self
    end
    
    def create_tokens(string)
      
    end
  end
  
  # Math line has numbering and align to = 
  class MathLine < LineFragment
    
    
  end
    

  # style: nomal, monospace, bold, italic, bold-italic
  # font_category: English, division_capital_letter, division_lower_letter, 
  #                super_cap, sub_low, math_symbols, symbol, lines, 
  #                
  class MathToken 
    attr_accessor :x, :y, :width, :height
    attr_accessor :math_hash, :font_category, :font, :size, :style
    attr_accessor :math_arguments
    def initialize(options={})
      if options[:math_arguments]
        # we have simple string
        
        
      elsif options[:math_hash]
        # we have root that is an other math expression
        # create_math_token(@math_hash)
      end
      @style  = options[:style]
      @size   = options.fetch(:size, 10)
      self
    end
    
    def contains_capital_letter(string)
      string.each_char do |c|
        if c >='A' && c <= 'Z'
          return true 
        end
      end
      false
    end

    def create_tokens
      return unless math_string
      
      token = nil
      case operator
      when "over", "frac"
        token = Over.new(options)
      when 'sqrt'
        token = Sqrt.new(options)
      when 'lim'
        token = Limit.new(options)
      when 'int'
        token = Integral.new(options)
      when 'sum'
        token = Sum.new(options)
      when 'sup'
        token = Sup.new(options)
      when 'sub'
        token = Sub.new(options)
      else
      end
      token 
    end

    def self.create_math_token_from_hash(parent, math_hash)
      return unless math_hash
      token = nil
      operator = math_hash.keys.first
      case operator
      when :over, :frac
        token = Over.new(parent, math_hash)
      when :sqrt
        token = Sqrt.new(parent, math_hash)
      when :lim
        token = Limit.new(parent, math_hash)
      when :int
        token = Integral.new(parent, math_hash)
      when :sum
        token = Sum.new(parent, math_hash)
      when :sup
        token = Sup.new(parent, math_hash)
      when :sub
        token = Sub.new(parent, math_hash)
      else
      end
      token 
    end
  end

  class Sqrt < MathToken
    attr_accessor :font_table, :char, :root
    def initialize(options={})
      super
      @height_level   = options.fetch(:height_level, 0)
      @font_category  = :div_cap
      self
    end
    
  end

  class Over < MathToken
    attr_accessor :nominator, :denominator
    def initialize(options={})      
      super
      @font_style     = PLAIN_FONTS
      @nominator    = options[:over][0]
      @denominator  = options[:over][1]
      nominator_contains_capital_letter = false
      denominator_contains_capital_letter = false
      if @nominator.class == String && @denominator.class == String
        nominator_contains_capital_letter = true if contains_capital_letter(@nominator)
        denominator_contains_capital_letter = true if contains_capital_letter(@denominator)
        if nominator_contains_capital_letter && denominator_contains_capital_letter
          # puts "should use Capital letter STkboNA"          
          @font_category  = DIV_CAPITAL
          @font = FONT_MAP[@font_style][@font_category]
          atts_string     = []
        elsif !nominator_contains_capital_letter && !denominator_contains_capital_letter
          # puts "should use lower letter STkboNB"
          @font_category  = DIV_LOWER
          @font = FONT_MAP[@font_style][@font_category]          
        else
          #TODO what 
          puts "should use mixed letter"
        end
      elsif @nominator.class != String
          puts "nominator is an other math token"
      elsif @denominator.class != String
          puts "denominator is an other math token"
      end
      
      self
    end
    
    def create_math_token()
      
    end
    
  end
  
  class Sup < MathToken
    
  end
  
  class Sub < MathToken
    
    
  end
  
  class Int < MathToken

  end

  class Limit < MathToken


  end

  class Sum < MathToken

  end
  


end

PLAIN_FONTS       = 0
BOLD_FONTS        = 1
ITALIC_FONTS      = 2
BOLD_ITALIC_FONTS = 3

ENGLISH_LETTERS   = 0
DIV_CAPITAL       = 1
DIV_LOWER         = 2
SUPER_LETTERS     = 3
SUB_LETTERS       = 4
NUMBER_SYMBOLDS   = 5
MATH_SYMBOLS      = 6
ARROWS_N_LINES    = 7

# Using 8 Fonts Tables to construct Math equations.
# We have to use comtainers for complex ones.
FONT_MAP = [
  ["STkEng", "STkboNA", "STkboNB", "STksaA","STkhaB","STkyak","STksou","STksunm"],
  ["STkEng-Bold", "STkboNA-Bold", "STkboNB-Bold", "STksaA-Bold","STkhaB-Bold","STkyak-Bold","STksou-Bold","STksunm-Bold"],
  ["STkEng-Italic", "STkboNA-Italic", "STkboNB-Italic", "STksaA-Italic","STkhaB-Italic","STkyak-Italic","STksou-Italic","STksunm-Italic"],
  ["STkEng-BoldItalic", "STkboNA-BoldItalic", "STkboNB-BoldItalic", "STksaA-BoldItalic","STkhaB-BoldItalic","STkyak-BoldItalic","STksou-BoldItalic","STksunm-BoldItalic"],
]

SHIFT_VALUE         = 16
OPTION_SHIFT_VALUE  = 32

# MATH_SYMBOLS_FONT_AND_CHARCODE = {
#   sqrt: [[MATH_SYMBOLS, '`'], [[FONT_MAP[PLAIN_FONT][MATH_SYMBOLS], '`']],
#   int: [MATH_SYMBOLS, '`'],
#   sum: [MATH_SYMBOLS, '`'],
#   lim: [MATH_SYMBOLS, '`'],
# }
# 

