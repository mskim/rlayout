
require 'minitest/autorun'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../..', 'lib')
require 'rlayout/graphic'
require File.dirname(__FILE__) + "/../spec_helper"
# require 'rlayout/container'
include RLayout

describe 'container_stroke_drawing test' do
  before do
    @g = Container.new(stroke_width: 1, x: 200, y:200, width: 300, height: 500, fill_color: 'red') do
      rectangle(stroke_width: 1, fill_color: 'yellow')
      container(stroke_width: 1, fill_color: 'white', layout_direction: 'horizontal') do
        rectangle(stroke_width: 1, fill_color: 'red')
        rectangle(stroke_width: 1, fill_color: 'gray')
        rectangle(stroke_width: 1, fill_color: 'orange')
      end
      rectangle(stroke_width: 1, fill_color: 'darkGray')
      relayout!
    end
    @path = "/Users/Shared/rlayout/output/container_stoke_drawing_test.svg"
  end
  
  it 'should create Graphic object' do
    @g.must_be_kind_of Container
  end
  
  it 'should draw image' do
    @g.save_svg(@path)
    File.exist?(@path).must_equal true
    system("open #{@path}")
  end  
end
