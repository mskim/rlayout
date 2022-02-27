# Item are stored in CSV file
# RItemColumn lays out Items 
# RItemParagraph parse items from CSV files
# 

module RLayout
  class RItemBox < Container
    attr_reader :grid, :cells

    def initialize(options={})
      

      self
    end

    def default_item_layout
      [
        {image: "#{@title}.jpg", grid:[0,0,3,3]}, 
        {title: "#{@title}", grid:[3,0,3,1]},
      ]
    end
    
  end

end