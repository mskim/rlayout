require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"


describe 'create NewsSectionPage with divider_lines' do
  before do
    @pillar_path    = "/Users/mskim/Development/pillar_layout/public/1/issue/2017-05-30/2/1"
    @pillar         = NewsPillar.new(pillar_path: @pillar_path)
  end

  it 'should create NewsPillar' do
    assert_equal NewsPillar, @pillar.class
  end
  it 'should auto_adjust_heigth' do
    @pillar.auto_adjust_height_all
    assert_equal @pillar.height_in_lines, @pillar.height_in_lines_sum
  end
end
