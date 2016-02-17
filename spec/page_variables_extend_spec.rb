
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
#     hash[:output_path]      = "/Users/Shared/rlayout/output/variables_page_sample.pdf"
#     @vp = Page.variable_page(hash)
#   end
#     
#   it 'should save hash' do
#     @yml_path    = "/Users/Shared/rlayout/output/variables_page_sample.yml"
#     @vp.save_yml(@yml_path)
#   end
# end

describe 'batch_variable_pages' do
  before do
    page = Page.new(nil, width: 400, height: 200)
    Image.new(page, tag: "QRCode", image_path: "name")
    Text.new(page, tag: "name")
    Text.new(page, tag: "phone")
    Text.new(page, tag: "email")
    hash = {}
    hash[:template_hash]    = page.to_hash
    hash[:csv_path]      = "/Users/mskim/membership/members.csv"
    @vp = Page.batch_variable_pages(hash)
  end
    
  it 'should save pdf' do
    pdf_path = "/Users/mskim/membership/pdf/김민수.pdf"
    File.exists?(pdf_path).must_equal true
  end
end

