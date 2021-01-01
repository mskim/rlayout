require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create idcard from hash' do
  before do
    template = {
      :doc_info=> {
        page_size: 'IDCARD', # width = 147.40 (45 + 67.4 + 45 = 157
      },
      :pages=> [
        {
          :klass=>"Page",
          :image_path => "/Users/mskim/idcard/front_side.pdf",
          :left_margin => 0,
          :graphics=>[
            {:klass=>"Image", :image_path=>'/Users/mskim/idcard/pictures/김민수.jpg', :x=>35, :y=>70, :width=>77.4, :height=>85, :layout_expand=>nil},
            {:klass=>"Text", :text_string=>'김민수', :x=>35, :y=>158, :width=>77.4, :height=>15, :layout_expand=>nil},
          ]
        
        },
        {
          :klass=>"Page",
          :image_path => "/Users/mskim/idcard/back_side.pdf",
          :left_margin => 0,
          :graphics=>[
            {:klass=>"Text", :text_string=>'김민수', :font_size=>9, :x=>53, :y=>60, :width=>70, :height=>10, :layout_expand=>nil},
            {:klass=>"Text", :text_string=>'2012/3/4', :font_size=>9, :x=>53, :y=>72, :width=>70, :height=>10, :layout_expand=>nil},
            {:klass=>"Text", :text_string=>'1959/1/29', :font_size=>9, :x=>53, :y=>82, :width=>70, :height=>10, :layout_expand=>nil},
            {:klass=>"Text", :text_string=>'2014/3', :font_size=>9, :x=>53, :y=>92, :width=>70, :height=>10, :layout_expand=>nil},
          ]
          
        },
      ]
    }
    @doc = Document.new(template)
    @pdf_path = "/Users/Shared/rlayout/output/document_from_hash.pdf"
  end

  it 'should save document pdf' do
    @doc.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
    system("open #{@pdf_path}")
  end
  
end
