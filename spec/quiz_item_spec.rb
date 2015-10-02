require File.dirname(__FILE__) + "/spec_helper"

describe 'create QuizItem' do
  before do
    choices = [
      "first choice",
      "second choice",
      "third choice",
      "fource choice"]
    question = "What is you name?"
    @quiz = QuizItem.new(nil, number: 7, question: question, choices: choices)
  end
  
  it 'should create QuizItem' do
    assert @quiz.class == QuizItem
  end
  
  it 'should create question' do
    assert @quiz.question.class == Text
    assert @quiz.graphics.last.class == TableRow
  end
  
  it 'should create choices' do
    assert @quiz.first.class == TableCell
    assert @quiz.second.class == TableCell
    assert @quiz.third.class == TableCell
    assert @quiz.fourth.class == TableCell
  end
  it 'chould have correct text_string' do
    assert @quiz.first.text_record.string == "first choice"
  end
end


