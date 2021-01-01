require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create ImageBox' do
  before do
    @path = "/Users/mskim/photo_book/images"
    image_style = {
      margin: 5,
      # inset: 5,
      rotation: 5,
      shadow: true,
    }
    image_pattern = {"2/1x2/1"=>[[0, 0, 2, 1], [0, 1, 2, 1]]}
    @g = RLayout::Document.new(:initial_page=>false, page_size: "A5", portrait: false) do
      page(margin: 30) do
        # image_box =image_box(fill_color: 'darkGray', profile: "5/3x2/1", image_style: image_style, h_gutter: 20, v_gutter: 20)
        image_box =image_box(fill_color: 'darkGray', image_pattern: image_pattern, image_style: image_style, h_gutter: 20, v_gutter: 20)
        relayout!
        image_box.layout_images!
      end
    end
  end

  it 'should create Image object' do
    assert @g.class == Document
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
