require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'AnnouncementText creation testing' do
  before do
    string = "some text\r\npage-11"
    @announcement_text = RLayout::AnnouncementText.new(text_string:string)
  end

  it 'should create AnnouncementText' do
    @announcement_text.class.must_equal AnnouncementText
  end

  it 'should create title and link_page' do
    @announcement_text.title.must_equal "some text"
    @announcement_text.linked_page.must_equal "page-11"
  end

  it 'title_object should start at 10' do
    @announcement_text.title_object.x.must_equal 10
  end
  
  it 'link_object should end at 10 from right' do
    @announcement_text.link_object.x_max.must_equal @announcement_text.width - 10
  end

end