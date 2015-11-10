require File.dirname(__FILE__) + "/../spec_helper"


describe 'create ImageBox' do
  before do
    @path = "/Users/mskim/photo_book/images"
    @g = ImageBox.new(nil, width: 400, height: 600, image_group_path: @path, h_gutter: 10, v_gutter: 10, profile: "5/3x2/1")
  end
  
  it 'should create Image object' do
    assert @g.class == ImageBox
  end
  
  it 'should layout_image!' do
    @g.layout_images!
    assert @g.graphics.first.class == Image
    assert @g.h_gutter == 10
    assert @g.v_gutter == 10
  end
  

  # it 'shluld save pdf' do
  #   @pdf_path = "/Users/mskim/mart/group_image.pdf"
  #   @g.layout_images!
  #   @g.save_pdf(@pdf_path)
  #   assert File.exist?(@pdf_path) == true
  # end
end


__END__

describe 'create magazine-article with image-box' do
  before do
    @path = "/Users/mskim/magazine_article/fourth_article"
    @g = MagazineArticleMaker.new(article_path: @path)
  end
  
  it 'should create document' do
    assert @g.document.class == Document
    
  end
  
end

