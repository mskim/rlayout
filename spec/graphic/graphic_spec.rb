require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'should save yaml' do
  before do
    @project_path = "/Users/mskim/test_data/graphic"
    @yaml_path = @project_path + "/layout.yml"
    @g = Graphic.new(:project_path=> @project_path)
  end

  it 'should create Graphic object' do
    assert_equal Graphic, @g.class 
    assert_equal @project_path, @g.project_path 
  end

  it 'should save yaml' do
    @g.save_yaml
    assert_equal Graphic, @g.class 
  end
end