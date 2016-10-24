require File.dirname(__FILE__) + "/spec_helper"


describe 'create page' do
  before do
    @path = "/Users/Shared/SoftwareLab/document_template/chapter"
    options = {project_path: @path}
    @chapter = RLayout::Chapter.new(options)
  end
  it 'should create Chapter' do
     assert @chapter.class ==  Chapter
   end
end
