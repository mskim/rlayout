require 'minitest/autorun'
require 'pry'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../..', 'lib')
require 'rlayout/style/grid_layout'
include RLayout
# 
# describe 'GridLayout' do
#   before do
#     @gl = RLayout::GridLayout.new_with_grid_key("6x6/3")
#   end
#
#   it 'should create GridLayout' do
#     @gl.class.must_equal GridLayout
#   end
#
#   it 'should create GridLayout' do
#     @gl.grid_rects.class.must_equal Array
#   end
#
#   it 'should create GridLayout with type of article' do
#     @gl.type.must_equal "article"
#   end
#
#   it 'should create GridLayout with columns of 6' do
#     @gl.columns.must_equal 6
#     @gl.rows.must_equal 6
#   end
#
# end

describe 'GridLayout,new_with_grid_key' do
  before do
    options = {}
    options[:heading] = true
    options[:ad] = [0,10,7,5]

    @gl = RLayout::GridLayout.new_with_grid_key("7x15/4", options)
    puts @gl.grid_rects
  end

  it 'should create ad GridLayout' do
    @gl.heading.type.must_equal "heading"
  end

  # it 'should create ad GridLayout' do
  #   @ad.type.must_equal "ad"
  #
  # end

end
