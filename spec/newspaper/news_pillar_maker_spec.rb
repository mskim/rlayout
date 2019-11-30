require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"


describe 'create NewsSectionPage with divider_lines' do
  before do
    @pillar_path    = "/Users/mskim/Development/rails6/pillar_design/public/page/3/1"
    @pillar_maker   = NewsPillarMaker.new(pillar_path: @pillar_path)
    @top_level_pdf = @pillar_path + "story.pdf"
  end

  it 'should create NewsPillarMaker' do
    assert_equal NewsPillarMaker, @pillar_maker.class
  end

  it 'should be fillar_top?' do
    assert @pillar_maker.fillar_top?(@pillar_path)\
  end

  # it 'should update pdf chain' do
  #   @pillar_maker.update_pdf_chain
  #   assert File.exist?(@top_level_pdf)
  # end

end
