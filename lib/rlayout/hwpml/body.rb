
module RLayout
	class Body #BODY
    attr_accessor :root, :section_list
	  def initialize(root, hwpml, options={})
	    
	    self
	  end
	end

  class Section #SECTION
    attr_accessor :body, :id, :p_list
    def initialize(body, hwpml, options={})
	    @body = body
	    self
	  end
	end
	
	class Para  #P
	  
  end
end