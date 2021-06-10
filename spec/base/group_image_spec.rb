
require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe ' create GroupImage' do
  before do
    @m = GroupImage.new(width:400, height: 400)
  end
  it 'should create GroupImage' do
    assert GroupImage, @m.class
  end

  # it 'should save Container' do
  #   path = File.dirname(__FILE__) + "/saving_from_hexa.pdf"
  #   @g.save_pdf(path)
  #   assert File.exist?(path), true
  # end
end
