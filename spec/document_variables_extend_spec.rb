require File.dirname(__FILE__) + "/spec_helper"

describe 'create idcard from hash' do
  before do
    template = {
      :doc_info=> {
        paper_size: 'IDCARD', # width = 147.40 
      },
      :pages=> [
        {
          :klass=>"Page",
          # :local_image => "front_side.pdf",
          :image_path => "/Users/mskim/idcard/front_side.pdf",
          :left_margin => 0,
          :graphics=>[
            {:klass=>"Image", :tag=>'picture', :image_path=>'name', :x=>35, :y=>70, :width=>77.4, :height=>85, :layout_expand=>nil},
            {:klass=>"Text", :tag=>'name', :x=>35, :y=>158, :width=>77.4, :height=>15, :layout_expand=>nil},
          ]
        },
        {
          :klass=>"Page",
          :image_path => "/Users/mskim/idcard/back_side.pdf",
          :left_margin => 0,
          :graphics=>[
            {:klass=>"Text", :tag=>'year', :font_size=>9, :x=>53, :y=>60, :width=>70, :height=>10, :layout_expand=>nil},
            {:klass=>"Text", :tag=>'name', :font_size=>9, :x=>53, :y=>72, :width=>70, :height=>10, :layout_expand=>nil},
            {:klass=>"Text", :tag=>'birthday', :font_size=>9, :x=>53, :y=>82, :width=>70, :height=>10, :layout_expand=>nil},
            {:klass=>"Text", :tag=>'exp', :font_size=>9, :x=>53, :y=>92, :width=>70, :height=>10, :layout_expand=>nil},
          ]
          
        },
      ]
    }
    options={
      template_hash: template,
      csv_path: "/Users/mskim/Development/rails32/business_card5/public/member_files/2/CardDemo.csv",
    }
    @vd = Document.batch_variable_documents(options)
  end

  it 'should save document pdf' do
    @pdf_path =  "/Users/mskim/Development/rails32/business_card5/public/member_files/2/pdf/김민수.pdf"
    File.exists?(@pdf_path).must_equal true
    system("open #{@pdf_path}")
  end
end

__END__
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
    puts "hash[:template_hash]:#{hash[:template_hash]}"
    hash[:csv_path] = "/Users/mskim/idcard/members.csv"
    @vd = Document.batch_variable_documents(hash)
  end
    
  it 'should save pdf' do
    pdf_path = "/Users/mskim/idcard/pdf/김민수.pdf"
    File.exists?(pdf_path).must_equal true
  end
end

