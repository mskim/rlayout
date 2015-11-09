
require File.dirname(__FILE__) + "/../spec_helper"

describe 'create TextTrain' do
  before do
    text_string_array = %w{this and that is the one}
    atts_array = [
      {text_color: 'red'},
      {text_color: 'blue'},
      {text_color: 'green'},
      {text_color: 'yellow'},
    ]
    @tt = TextTrain.new(nil, text_string_array: text_string_array, text_atts_array: atts_array)
    
  end
  it 'should create TextTrain' do
    assert @tt.class == TextTrain
    assert @tt.graphics.length == 6
    assert  @tt.graphics.first.text_string == 'this'
  end
  
end

describe 'create char_train' do
  before do
    text_string = "this"
    atts_array = [
      {text_color: 'red'},
      {text_color: 'blue'},
      {text_color: 'green'},
      {text_color: 'yellow'},
      ]
    @con = Container.new(nil) do
      char_train(text_string, atts_array)
    end
  end
  it 'should create TextTrain' do
    assert @con.graphics.first.class == TextTrain
  end
  
end