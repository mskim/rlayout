
module RLayout
  
  # Decoration is a graphic with backgraound image, usually pdf for resizing
  # Decoration made for combing with variable text.
  # Decoration usually pre-made for speccific client or for certian industry or domain, 
  # such as logo or symblos with text.
  class Decoration < Graphic
    
    
    
    
    
  end
  
  # list of text with embeed tab leading characters
  # example: jubo or menu, where there is leading_chared tab column.
  # This is very awkward to automate, so this will to do trick.
  # list_text are read from csv.
  # leading_character: dot, dash, 
  # class TabedList < Container
  #   attr_accessor :leading_character, :layout_length_array, :laeading_char_column
  #   attr_accessor :list_text
  #   
  # end
  
  # This is a box with Head title
  # title_shape: rectangular, round_rect, circular, greater_sign
  # frame_type:  solid, double
  class ContainerWithTitle < Container
    attr_accessor :title_text, :title_shape, :title_position
    
    def initialize(options={})
      @title        = options.fetch(:title, " ")
      @title_shape  = options.fetch(:title_shape, "rectangle")
      @frame_type   = options.fetch(:frame_type, "solid")
      create_title_
      super
      options[:parent] = self
      TitleTop.new(options)
      self
    end
  end
  # 
  class TitleTop < Graphic
    attr_accessor :title_text, :title_shape, :title_position
    def initialize(options={})
      @title_text       = options.fetch(:title_text, "Example")
      @title_shape      = options.fetch(:title_shape, "rectangle")
      @title_position   = options.fetch(:title_position, "center")
      
      
      self
    end    
  end
end