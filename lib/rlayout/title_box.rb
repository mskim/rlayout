
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
  class TabedList < Container
    attr_accessor :leading_character, :layout_length_array, :laeading_char_column
    attr_accessor :list_text
    
  end
  
  # This is a box with Head title
  # title_shape: rectangular, round_rect, circular
  # frame_type:  solid, double
	class TitledBox < Container
		attr_accessor :title, :body, :column_count
		attr_accessor :title_shape, :frame_type
		
		
		
	end

  class Menu < TitledBox
    
  end

end