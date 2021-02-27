
require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create Page from SVG' do
  before do
    @project_path = "/Users/mskim/test_data/svg/graphic"
    @svg_path = "/Users/mskim/test_data/svg/graphic/output.svg"
    @graphic = Graphic.new(project_path: @project_path)
  end

  it 'should create Graphic with project_path' do
    assert_equal Graphic, @graphic.class
    assert_equal @project_path, @graphic.project_path
  end

  it 'should save svg' do
    @graphic.save_svg
    assert File.exist?(@svg_path)
  end
  # it 'Container should have graphic array' do
  #   assert_equal Array, @svg.graphics.class
  #   assert_equal 12, @svg.graphics.length
  #   assert_equal Rectangle, @svg.graphics.first.class
  #   assert_equal Rectangle, @svg.graphics[2].class
  # end

  # it 'should create group child' do
  #   assert_equal Container, @first_group.class
  #   assert_equal Array, @first_group.graphics.class
  #   assert_equal Text, @first_group.graphics.first.class
  #   puts " @first_group.graphics.first.to_svg:#{ @first_group.graphics.first.to_svg}"
  #   puts " @first_group.graphics.first.attributes:#{ @first_group.graphics.first.attributes}"
  # end


end
