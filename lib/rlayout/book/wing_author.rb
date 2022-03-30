
module RLayout
  class WingAuthor < StyleableDoc
    def initialize(options={})
      
      self
    end

    def default_layout
      =<<~EOF
      RLayout::RColumn.new(widht:#{@width}, #{@height}) do
        personal_image(local_path:'#{@author}.jpg')
      end
  
      EOF
  
    end
    
  end
end