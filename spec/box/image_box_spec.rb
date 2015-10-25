require File.dirname(__FILE__) + "/../spec_helper"

describe 'create magazine-article with image-box' do
  before do
    @path = "/Users/mskim/magazine_article/fourth_article"
    @g = MagazineArticleMaker.new(article_path: @path)
  end
  
  it 'should create document' do
    assert @g.document.class == Document
    
  end
  
end

__END__
describe 'create ImageBox' do
  before do
    @path = "/Users/mskim/mart/group_image"
    @g = ImageBox.new(nil, width: 400, height: 600, image_group_path: @path)
  end
  
  it 'should create Image object' do
    assert @g.class == ImageBox
  end
  
  it 'should layout_image!' do
    @g.layout_images!
    assert @g.graphics.first.class == Image
  end
  
  it 'shluld save pdf' do
    @pdf_path = "/Users/mskim/mart/group_image.pdf"
    @g.layout_images!
    @g.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path) == true
  end
end