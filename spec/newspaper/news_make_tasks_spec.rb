require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe "create MakePage class" do
  before do
    path = "/Users/mskim/Development/rails5/style_guide/public/1/issue/2017-05-30/2"
    options = {}
    options[:page_path] = path

    @page_maker = MakePage.new(options)
  end

  it 'should create MakeIssue' do
    assert_equal  @page_maker.class , MakePage
  end

end

__END__

describe "create MakeIssue class" do
  before do
    path = "/Users/mskim/Development/rails5/style_guide/public/1/issue/2017-05-30"
    options = {}
    options[:issue_path] = path
    @issue_maker = MakeIssue.new(options)
  end

  it 'should create MakeIssue' do
    assert_equal  @issue_maker.class , MakeIssue
  end

end
