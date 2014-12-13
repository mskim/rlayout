
require File.dirname(__FILE__) + "/spec_helper"

# describe 'variable page' do
#   before do
#     page = Page.new(nil, width: 400, height: 200)    
#     Text.new(page, tag: "name")
#     Text.new(page, tag: "phone")
#     Text.new(page, tag: "email")
#     hash = {}
#     hash[:template_hash]    = page.to_hash
#     hash[:varaiables_hash]  = {
#       name: "Min Soo Kim",
#       phone: '010-7468-8222',
#       email: 'mskimsid@gmail.com'
#     }   
#     hash[:output_path]      = File.dirname(__FILE__) + "/../output/variables_page_sample.pdf"
#     @vp = Page.variable_page(hash)
#   end
#     
#   it 'should save hash' do
#     @yml_path    = File.dirname(__FILE__) + "/../output/variables_page_sample.yml"
#     @vp.save_yml(@yml_path)
#   end
# end

describe 'batch_variable_document' do
  before do
    doc  = Document.new(:width=>350, :height=>500, :left_margin=>0, :right_margin=>0, :top_margin=>0, :bottom_margin=>0)
    page = Page.new(doc)
    front_side_image = "/Users/mskim/idcard/front_side.pdf"
    Image.new(page, width: 350, height: 500, layout_expand: nil, :image_path=>front_side_image)
    Rectangle.new(page, fill_color: "clear", layout_length: 3)
    Image.new(page, tag: "pictures", image_path: "name", layout_length: 5)
    Text.new(page, tag: "name")
    Text.new(page, tag: "phone")
    Text.new(page, tag: "email")
    Rectangle.new(page, fill_color: "clear", layout_length: 4)
    page.relayout!
    page = Page.new(doc)
    back_side_image = "/Users/mskim/idcard/back_side.pdf"
    Image.new(page, width: 350, height: 500, layout_expand: nil, :image_path=>back_side_image)
    
    hash = {}
    hash[:template_hash]    = doc.to_hash
    puts hash
    hash[:csv_path]      = "/Users/mskim/idcard/members.csv"
    @vd = Document.batch_variable_documents(hash)
  end
    
  it 'should save pdf' do
    pdf_path = "/Users/mskim/idcard/pdf/김민수.pdf"
    File.exists?(pdf_path).must_equal true
  end
end

