require File.dirname(__FILE__) + "/spec_helper"


describe 'create page' do
  before do
    @path = "/Users/Shared/SoftwareLab/document_template/chapter"
    options = {project_path: @path}
    @chapter_maker = RLayout::ChapterMaker.new(options)
  end
  it 'should create ChapterMaker' do
     assert @chapter_maker.class ==  ChapterMaker
   end
end
