

require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create page' do
  def default_layout_rb
    <<~EOF
    RLayout::StyleablePage.new(width: 300, height:500) do
      text_area(1,1,2,2, 'heading')
    end
    EOF
  end

  before do
    @p = eval(default_layout_rb)

  end

  it 'should create StyleablePage' do
     assert_equal RLayout::StyleablePage,  @p.class
   end

   it 'should find object with name == heading' do
    @text_area  = @p.find_by_name('heading')
    assert_equal RLayout::TextArea,  @text_area.class
  end
end
