QUIZ_ERB =<<YAML
---
num: <%= @num %>
q: "What is the correct combination from following?"

choice_text: >
  This is a sample text. This text containes choices from 1 to 4.
  You should replace this text with English questions with choices embeded.
  Something like {{1. choice one here}} and some more text goes here.
  Something like {{2. choice one here}} and some more text goes here.
  Something like {{3. choice one here}} and some more text goes here.
  Something like {{4. choice one here}} and some more text goes here.
  The part with the {{}} is special symbol that tells the system to apply some text effect,
  such as putting underline or circle the number. It depends on how you want to style this
  {{box "some/word"}} will put box around the text "some/word".
  {{under "word"}} will put box around the text "word".
    
ans: <%= @answer %>
exp: >
  The reason why the answer is <%= @answer %>.
  
---

.,(A), (B), (C)
1),one_one, one_two, one_three
2),two_one, two_two, two_three
3),three_one, three_two, three_three
2),four_one, four_two, four_four

YAML

SAMPLE_LAYOUT =<<LAYOUT
@quiz_item_style = {
  layout_space: 10,
  
  num_style: {
    q_num_type: "numeric",
    font: 'Helvetica',
    font_size: 14,
    text_color: 'brown',
    chice_num_type: 'circled_alphabet', 
    text_vertical_alignment: 'top',
    layout_length: 1,
    height: 20,
    #number, alphaber, hangul_jaum,
    #plain, circled, reverse_circled,
  },
  
  q_style: {    
    fill_color: 'white',
    font: 'Helvetica',
    font_size: 14,
    text_color: 'black',
    text_alignment: 'left',
    text_vertical_alignment: 'top',
    text_fit_type: 'adjust_box_height',
    text_head_indent: 0,
    layout_length: 7,
    layout_expand: [:width],
    height: 60,
    space_after: 10,
  },
  
  choice_style: {
    font: 'Times',
    font_size: 14,
    text_color: 'black',
    text_head_indent: 0,
    text_alignment: 'left',
    text_vertical_alignment: 'top',
    text_fit_type: 'adjust_box_height',
    stroke_sides: [0,0,0,0],
    layout_expand: [:width],
    space_after: 10,
    gutter: 5,
  },
  
  column_width_array: [1,3,3,3],
  column_align_array: ['right','left','center','right'],
  column_leader_array: [false,true,false,true],
  table_head_style: {
    font: 'Helvetica',
    font_size: 14,
    text_color: 'black',
    text_alignment: 'center',
    text_vertical_alignment: 'top',
    text_fit_type: 'adjust_box_height',
  },
  
  table_body_style: {
    font: 'Times',
    font_size: 14,
    text_color: 'black',
    text_head_indent: 0,
    text_alignment: 'left',
    text_vertical_alignment: 'top',
    text_fit_type: 'adjust_box_height',
    stroke_sides: [0,0,0,0],
    layout_expand: [:width],
    space_after: 10,
    gutter: 5,    
  }
},


info = {
  quiz_width: 300,
}

if @quiz_item_style.class == Array
  $quiz_item_style      = @quiz_item_style[0]
else
  $quiz_item_style      = @quiz_item_style
end

RLayout::EnglishQuizItem.new(info)

LAYOUT

SAMPLE_RAKEFILE =<<RAKEFILE


RAKEFILE


# first body cell
# align ..
# leader ....

# This was done for Nung Ruel Englishing Studies 
# Make Single Quiz Item in a folder
# info.yml,
# layout.rb, 
# quiz.md, 
# chioce.csv
# images
# preview


TABLE =<<EOF
RLayout::SimpleTable.new(width: 300, csv: table, column_width: table_width_array)

EOF

module RLayout
  
  # 001_quiz.yml file is pass
  # determin the project folder
  # get the layout.rb file which contains the layout and styles
  # save it as 001_quiz.pdf, 001_quiz.jpg
  class EnglishQuizItemMaker
    attr_accessor :project_path, :quiz_item_path, :info, :layout, :q_object, :table_object
    def initialize(options={})
      if options[:project_path]
        puts "not implemented yet!!!"
        return
        # @project_path = options[:project_path]
        # Dir.glob("#{@project_path}/*.{md, csv") do |file|
        #   @q_text   = File.open(file, 'r'){|f| f.read} if file=~/md$/
        #   @csv_text = File.open(file, 'r'){|f| f.read} if file=~/csv$/
        # end
        # @q_object   = eval(ENGLISH_QUIZ)
        # @q_object.set_content(quiz_text: @q_text, q_table: @q_table)
        # output_path = @project_path + "/output.pdf"
        # @q_object.save_pdf(output_path, preview:true)
        
      elsif options[:quiz_item_path]
        @quiz_item_path = options[:quiz_item_path]
        @project_path   = File.dirname(@quiz_item_path)
        @layout_path    = @project_path + "/layout.rb"
        unless File.exist?(@layout_path)
          puts "No layout.rb file found!!!"
          return
        end
        english_quiz_templeate  = File.open(@layout_path, 'r'){|f| f.read}
        english_quiz_item       = File.open(@quiz_item_path, 'r'){|f| f.read}
        @item_hash              = YAML::load(english_quiz_item)
        @item_hash              = Hash[@item_hash.map{ |k, v| [k.to_sym, v] }]
        # TODO it seem to work only after this, can't figure it out!!!!
        @item_hash[:choice_table]= @item_hash[:choice_table].gsub(/\}$/, "")
        @q_object   = eval(english_quiz_templeate)
        @q_object.set_content(@item_hash)
        ext         = File.extname(@quiz_item_path)
        output_path = @quiz_item_path.sub(/#{ext}$/, ".pdf")
        @q_object.save_pdf(output_path, jpg:true)
        
      end
      self
    end
    
    def self.sample_yml(project_path, count=20)
      answer_choice = [1,2,3,4]
      count.times do |i|
        @num    = (i + 1).to_s.rjust(3, "0") 
        @answer = answer_choice.sample
        erb     = ERB.new(QUIZ_ERB)
        quiz_content = erb.result(binding)
        path =  project_path + "#{@num}_quiz.yml"
        File.open(path, 'w'){|f| f.write quiz_content}
      end
    end
    
    def self.sample_layout(project_path)
      path =  project_path + "layout.rb"
      File.open(path, 'w'){|f| f.write SAMPLE_LAYOUT}
    end
    
    def self.sample_rakefile(project_path)
      path =  project_path + "Rakefile"
      File.open(path, 'w'){|f| f.write SAMPLE_RAKEFILE}
    end
  end
  
end