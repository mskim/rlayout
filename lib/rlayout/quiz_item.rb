module RLayout

DEFAULT_QUIZ_LAYOUT_ERB = <<-EOF
RLayout::QuizItem.new(nil) do
  text('<%= @question %>')
  TableRow.new(self, row_data: ['<%= @choice_1 %>', '<%= @choice_2 %>'], cell_atts: {})
  TableRow.new(self, row_data: ['<%= @choice_3 %>', '<%= @choice_4 %>'], cell_atts: {})
end
EOF

SAMPLE_QUIZ_DATA = <<-EOF
q: Some text for question
p:
img:
1: 
2: 
3: 
4: 
ans:
exp:

EOF

  class QuizMaker
    attr_accessor :number, :question, :p, :image
    attr_accessor :choice_1, :choice_2, :choice_3, :choice_4, :choice_5
    attr_accessor :quiz_item, :answer, :explanation
    def initialize(options={})
      @number     = options.fetch('number', "1")
      @question   = options.fetch('q', "Some questiongoes goes here? ")
      @p          = options.fetch('p', nil)
      @image      = options.fetch('img', nil)
      @choice_1   = options.fetch('1', "choice1")
      @choice_2   = options.fetch('2', "choice2")
      @choice_3   = options.fetch('3', "choice3")
      @choice_4   = options.fetch('4', "choice4")
      @choice_5   = options.fetch('5', "")
      @answer     = options.fetch('ans', nil)
      @explanation= options.fetch('exp', " ")
      erb         = ERB.new options.fetch(:layout_erb, DEFAULT_QUIZ_LAYOUT_ERB)
      result      = erb.result binding
      @quiz_item  = eval(result)   
      self   
    end
    
    def self.yaml2quiz_items(path)
      source      = File.open(path, 'r'){|f| f.read}
      blocks_array= source.split("\n\n")
      blocks_array.map do |lines_block|
        QuizMaker.new(YAML::load(lines_block)).quiz_item
      end
    end
  end
  
  class QuizItem < Container
    def initialize(parent_graphic, options={}, &block)
      super
      if block
        instance_eval(&block)
      end            
      self
    end
  end
end