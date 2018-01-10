require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create  TextTrain' do
  before do
    @text_array    = ['2017 4 12', '22']
    @atts_array    = [{font_size: 9}, {font_size: 24}]
    @train         = TextTrain.new(text_array: @text_array, atts_array: @atts_array)
  end

  it 'should create TextTrain' do
    @train.class.must_equal TextTrain
    puts "@train.widgh: #{@train.width}"
    @train.graphics.each do |token|
      puts "token.width: #{token.width}"
    end
  end

  it 'should create TextTrain tokens' do
    @train.graphics.length.must_equal 2
  end

end
