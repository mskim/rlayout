require File.dirname(__FILE__) + "/spec_helper"

describe 'create Bar' do
  before do
    @bar = Bar.new(nil) do
      text("hello")
      rect(fill_color: "blue")
      # rect(fill_color: "blue")
      # rect(fill_color: "blue")
    #   text("Hello ")
    #   text("Min Soo ")
    #   text("Good to see you.")
    end
    @bar.relayout!
    
    # puts "@bar.layout_direction:#{@bar.layout_direction}"
    # puts "@bar.graphics.first.width:#{@bar.graphics.first.puts_frame}"
  end
  
  it 'it should create Bar' do
    assert @bar.class == Bar
  end
  
  it 'it add rects horizontally' do
    assert @bar.width == 300
  end
  
  it 'it should have layout_direction as horizontally' do
    assert @bar.layout_direction == "horizontal"
  end
  
  it 'it add rects' do
    assert @bar.graphics.length == 2
  end
  
  it 'it shold layout graphics horizontally' do
    assert @bar.graphics.first.width == 150
  end
  
end
