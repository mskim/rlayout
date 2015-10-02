module RLayout
  
  class QuizItem < Container
    attr_accessor :type, :number, :question, :choice
    def initialize(parent_graphic, options={})
      super
      @type     = options.fetch(:type, 0)
      @number   = options.fetch(:number, 1)
      @question = text(options[:question])
      TableRow.new(self, row_data: [options[:choices][0], options[:choices][1]], cell_atts: {})
      TableRow.new(self, row_data: [options[:choices][2], options[:choices][3]], cell_atts: {})
      self
    end
    
    def first
      @graphics[1].graphics.first
    end
    
    def second
      @graphics[1].graphics[1]
    end
    
    def third
      @graphics[2].graphics[0]
    end
    
    def fourth
      @graphics[2].graphics[1]
    end
  end
  

end