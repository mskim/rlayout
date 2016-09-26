require File.dirname(__FILE__) + "/../spec_helper"

describe 'create NRSemiTestChapterMaker' do
  before do
    @path       = '/Users/mskim/demo_english_parts/semi_test'
    @q_chapter  = NRSemiTestChapterMaker.new(project_path: @path)
  end
  
  it 'should create NRSemiTestChapterMaker' do
    assert  @q_chapter.class == NRSemiTestChapterMaker
  end
  
end