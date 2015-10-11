require File.dirname(__FILE__) + "/spec_helper"

describe 'create QuizMaker' do
  before do
    @quiz = QuizMaker.new
  end
  
  it 'should create QuizItem' do
    assert @quiz.class == QuizMaker
  end
  
  it 'should create question' do
    assert @quiz.question.class == String
    assert @quiz.quiz_item.class == QuizItem
  end
  
  it 'should create choices' do
    assert @quiz.choice_1 == "choice1"
    assert @quiz.choice_2 == "choice2"
    assert @quiz.choice_3 == "choice3"
    assert @quiz.choice_4 == "choice4"
  end
end

describe 'parse quiz file' do
  before do
    @path       = "/Users/mskim/quiz/sample_quiz.yml"
    @quiz_list  = QuizMaker.yaml2quiz_items(@path)
  end
  
  it 'should parse quiz file' do
    assert @quiz_list.class == Array
  end
  
  it 'should parse quiz file' do
    assert @quiz_list.first.class == QuizItem
  end
  
end

