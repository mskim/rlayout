require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create FitPage ' do
  before do
    @page_path  = "#{ENV["HOME"]}/test_data/page_by_page/_build/0014"
    @pdf_path  = @page_path + "/14.pdf"
    @fit_page = FitPage.new(@page_path, nil)
  end

  it 'should create FitPage' do
    assert_equal RLayout::FitPage, @fit_page.class
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end

  # it 'should create pdf' do
  #   assert File.exist?(@pdf_path)
  #   system "open #{@pdf_path}"
  # end
end

__END__
describe 'create FitPage ' do
  before do
    @page_path  = "#{ENV["HOME"]}/test_data/page_by_page/_build/0007"
    @pdf_path  = @page_path + "/7.pdf"
    @fit_page = FitPage.new(@page_path, nil)
  end

  it 'should create FitPage' do
    assert_equal RLayout::FitPage, @fit_page.class
  end

  it 'should create pdf' do
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end
end


describe 'create FitPage ' do
  before do
    @page_path  = "#{ENV["HOME"]}/test_data/page_by_page/_build/0008"
    @pdf_path  = @page_path + "/8.pdf"
    @fit_page = FitPage.new(@page_path, nil)
  end

  it 'should create FitPage' do
    assert_equal RLayout::FitPage, @fit_page.class
  end

  it 'should create pdf' do
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end
end