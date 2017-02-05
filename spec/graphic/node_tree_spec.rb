require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create Graphic with node_path' do
  before do
    @c = Container.new(nil)
    @c2 = Container.new(@c)
    @c3 = Container.new(@c2)
    @g1 = Graphic.new(@c3)
    @g2 = Graphic.new(@c3)
  end
  
  it 'should have node_path' do
    @c.node_path.must_equal "0"
    @g1.node_path.must_equal "0_0_0_0"
    @g2.node_path.must_equal "0_0_0_1"
  end
  
  it 'should create node_tree' do
    nt  = @c.node_tree
    nt.must_be_kind_of Array
    puts nt
  end
end