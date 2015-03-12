module RLayout

  class QuizModel
    attr_accessor :number, :question, :choices, :related_text, :image
    
    def initialize(options={})
      @question       = options.fetch(:question, "") 
      @choices        = options.fetch(:choices, []) 
      @related_text   = options.fetch(:related_text, nil) 
      @iamge          = options.fetch(:iamge, nil) 
      self
    end
    
    def self.ramdom_sample(number)
      
    end
  end
  
  class Question < Paragraph
  
  end
  
  class ChoiceItem < Paragraph
    
  end
  
  class Choices < Container
    attr_accessor :type
    
    
  end
  
  class QuizItem < Container
    attr_accessor :type, :number, :question, :choices
  
    def initialize(parent_graphic, options={})
      super
      @type = options.fetch(:type, 0)
      if @model
        @question = Question.new(self, options[:question])
        make_choices(options)
      end
      self
    end
    
    def make_choices
      @choices = Choices.new(self, options)
    end
  end

end