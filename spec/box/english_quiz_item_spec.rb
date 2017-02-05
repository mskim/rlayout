require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create EnglishQuizItem' do

  # it 'should create EnglishQuizItem' do
  #   @eqi = EnglishQuizItem.new
  #   assert @eqi.class == EnglishQuizItem
  # end

  it 'should create sample' do
    @eqi_sample = EnglishQuizItem.sample
    assert @eqi_sample.class == EnglishQuizItem
  end

end
