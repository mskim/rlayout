require File.dirname(__FILE__) + "/../spec_helper"

# describe 'should run script' do
#   before do
#     @script_path  = "/Users/mskim/Development/music/songs/iu/script/1.rb"
#     @pdf_path  = "/Users/mskim/Development/music/songs/iu/piano_cord/1.pdf"
#     system "/Applications/rjob.app/Contents/MacOS/rjob #{@script_path}"
#     
#   end
#   
#   it 'should create CodeMusic' do
#     assert File.exist?(@pdf_path) == true
#   end
# end

describe 'should save CodeMusic' do
  before do
    @folder_path  = "/Users/mskim/Development/music/songs/iu"
    @code_music = CodeMusic.new(project_path: @folder_path, pdf: true)
  end
  
  it 'should create CodeMusic' do
    assert @code_music.class == RLayout::CodeMusic
  end
end