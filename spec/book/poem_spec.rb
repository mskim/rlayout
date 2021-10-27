require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create Poem' do
  before do
    @project_path= "/Users/mskim/test_data/poem"
    @pdf_path = @project_path + "/chapter.pdf"
    @poem = Poem.new(@project_path)
  end

  it 'test create Poem' do
    assert_equal RLayout::Poem, @poem.class
  end

  it 'should create Poem pdf' do
    assert File.exist?(@pdf_path) 
    system "open #{@pdf_path}"
  end
end
