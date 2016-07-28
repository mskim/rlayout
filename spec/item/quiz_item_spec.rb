require File.dirname(__FILE__) + "/../spec_helper"

RUBY_DEP_GEM_SILENCE_WARNINGS=1

describe 'create QuizMaker' do
  before do
    @output_path  = "/Users/mskim/quiz/sample_quiz.pdf"
    @quiz_data    = "/Users/mskim/quiz/sample_quiz.md"
    @make         = QuizMaker.new(quiz_data_path: @quiz_data)
#     @quiz_sample = <<-EOF
# @output_path = "/Users/mskim/quiz/sample_quiz.pdf"
# @quiz_data = "/Users/mskim/quiz/sample_quiz.yml"
# RLayout::QuizMaker.new(quiz_data_path: @quiz_data)
# 
# EOF
#     system "echo '#{@quiz_sample}' | /Applications/rjob.app/Contents/MacOS/rjob"  
  end
  it 'should create QuizMaker' do
    assert @make.class == QuizMaker
  end
  # it 'should save quiz sheet' do
  #   assert File.exist?(@output_path)
  # end
end

__END__



describe 'create QuizMaker' do
  before do
    @path       = "~/quiz/sample_quiz.yml"
    @quiz_maker = QuizMaker.new(quiz_data_path: File.expand_path(@path))
    @text_box   = @quiz_maker.document.pages.first.main_box
  end
  
  # it 'shuld create QuizMaker' do
  #   assert @quiz_maker.class == QuizMaker
  # end
  # 
  # it 'shuld create docment' do
  #   assert @quiz_maker.document.class == Document
  # end
  
  it 'should create two columns in text_box' do
    tb = @quiz_maker.document.pages.first.main_box
    assert tb.graphics.length == 2    
  end
end

__END__




describe 'create QuizItemMaker' do
  before do
    @quiz = QuizItemMaker.new
  end
  
  it 'should create QuizItem' do
    assert @quiz.class == QuizItemMaker
  end
  
  it 'should create question' do
    assert @quiz.quiz_item.class == QuizItem
  end
  
end

describe 'parse quiz file' do
  before do
    @path       = "/Users/mskim/quiz/sample_quiz.yml"
    @quiz_hash  = QuizItemMaker.yaml2quiz_hash(@path)
  end
  
  it 'should parse quiz file' do
    assert @quiz_hash.class == Hash
  end
  
  it 'should parse quiz file' do
    assert @quiz_hash[:heading]['title'] == 'Title of quiz'
    assert @quiz_hash[:quiz_items].first.class == QuizItem
  end
end

