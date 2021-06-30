require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create Yearbook folders' do
  before do
    @project_path =  "/Users/mskim/test_data/yearbook/2021/낙생고등학교"
    @y = Yearbook.new(@project_path)
  end

  it 'should create folders' do
    assert RLayout::Yearbook,  @y.class
  end

end