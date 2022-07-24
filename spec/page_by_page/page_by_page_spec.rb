require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

# describe 'create PapeByPage ' do
#   before do
#     @projext_path  = "#{ENV["HOME"]}/test_data/page_by_page"
#     @page_by_page = PageByPage.new(@projext_path)
#   end

#   it 'should create Book' do
#     assert_equal RLayout::PageByPage, @page_by_page.class
#   end
# end

describe 'generate FitPages' do
  before do
    @projext_path  = "#{ENV["HOME"]}/test_data/page_by_page"
    @build_path = @projext_path + "/_build"
    @pages_path = Dir.glob("#{@build_path}/**").each do |page_folder|
      puts page_folder
      FitPage.new(page_folder, nil)
    end
  end

  it 'should create Book' do
    assert File.exist?(@build_path)
  end
end


