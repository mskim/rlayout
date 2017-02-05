require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'converting from .mlayoutP file to rlayout' do
    before do
      @mlayout_path='/Users/mskim/AdItem/template.mlayoutP'
      system("/Applications/m2r.app/Contents/MacOS/m2r #{@mlayout_path}")
      @document_path='/Users/mskim/AdItem/template'
    end
    it 'should create save ' do
      # @mdocument.m2r
      assert(File.exists?(@document_path))
    end
end

# describe 'converting from .mlayoutP file with text link to rlayout' do
#     before do
#       @template_path='/Users/mskim/2Samples/2E_Sample1.mlayoutP'
#       @mdocument=MDocument.new(@template_path) 
#       @smdocument=@mdocument.to_smdocument
#       @smdocument_path='/Users/mskim/2Samples/2E_Sample1.rlayout'
#       @smdocument.save_rlayout(@smdocument_path)
#       @r_path=@smdocument_path + "/layout.yaml"
#     end
#     
#     it 'should create r.yaml' do
#       # @mdocument.m2r
#       assert(File.exists?(@r_path))
#     end
# end

# describe 'create html from mdocumets' do
#   before do
#     @path='/Users/mskim/Development/mygems/mlayout/lib/mlayout/templates/10062_20110907153931.mlayoutP'
#     @html_path='/Users/mskim/Development/mygems/mlayout/lib/mlayout/templates/10062_20110907153931.mlayoutP/web/1.html'
#     # @html_path='/Users/mskim/Development/mygems/mlayout/lib/test/html/document_test.html'
#     @mdocument=MDocument.new(@path) 
#     @first_spread=@mdocument.first_spread
#     # @html_path=(File.dirname(__FILE__) +'/html/document_test.html')
#   end
# end
#   
#   
#    it 'should create stamped image files' do
#      @path='/Users/mskim/Development/mygems/mlayout/lib/mlayout/templates/2E_Sample1.mlayoutP'
#      @mjob_path='/Users/mskim/Development/mygems/mlayout/lib/mlayout/templates/2E_Sample1.mlayoutP/MakeContentsXML.mJob'
#      @stamped_file='/Users/mskim/Development/mygems/mlayout/lib/mlayout/templates/2E_Sample1.mlayoutP/MakeContentsXML.mJob'
#      @mdocument=MDocument.new(@path) 
#      @mdocument.copy_stamped_preview
#      assert(File.exists?(@stamped_file))
#    end
#    # 

  # it 'should create webtop files' do
  #    @path='/Users/mskim/Development/mygems/mlayout/lib/mlayout/templates/2E_Sample1.mlayoutP'
  #    @mjob_path='/Users/mskim/Development/mygems/mlayout/lib/mlayout/templates/2E_Sample1.mlayoutP/MakeContentsXML.mJob'
  #    @mdocument=MDocument.new(@path) 
  #    @mdocument.make_webtop_files
  #    assert(File.exists?(@mjob_path))
  #  end
   # 
#   it 'should create html' do
#     @path='/Users/mskim/Development/MacRuby/rlayout/working/test/templates/2E_Sample1.mlayoutP'
#     @html_path='/Users/mskim/Development/MacRuby/rlayout/working/test/templates/2E_Sample1.mlayoutP/web'
#     @mdocument=MDocument.new(@path) 
#     
#     @mdocument.save_html(@html_path)
#     assert(File.exists?(@html_path))
#     system("open #{@html_path}/1.html")
#   end
#   
# 
# end

# describe 'create html from mdocumets' do
#   before do
#     @path='/Users/mskim/Development/mygems/mlayout/lib/mlayout/templates/2E_Sample1.mlayoutP'
#     @output_path="/Users/mskim/Development/mygems/mlayout/lib/test/photobook/template"
#     @mdocument=MDocument.new(@path) 
#     # @html_path=(File.dirname(__FILE__) +'/html/document_test.html')
#   end
#   
#   it 'should create html' do
#     @mdocument.save_document_page_tempaltes(@output_path)
#     output_file= @output_path + "/page_profile"
#     assert(File.exists?(output_file))
#     system("open #{output_file}")
#   end
# end

# describe 'MDocument creation' do
#   before do
#     @path=File.dirname(__FILE__) +'/../mlayout/templates/t1_i3.mlayoutP'
#     @mlayout_document=MDocument.new(@path)
#   end
#   
#   it 'should create MLayoutDocumnet class object' do
#     assert_kind_of(MDocument, @mlayout_document)
#   end
#     
#   it 'should have spread_list array' do
#     assert_kind_of(Array, @mlayout_document.spread_list)
#   end
#   
#   it 'should have spread_list array of one ' do
#     assert_equal(1, @mlayout_document.spread_list.length)
#   end
#   
#   it 'should have spread_list array of two ' do
#     # @path=File.dirname(__FILE__) +'/../mlayout/templates/t1_i3.mlayoutP'
#     @path='/Users/mskim/Development/mygems/mlayout/lib/mlayout/templates/2E_Sample1.mlayoutP'
#     
#     @mlayout_document=MDocument.new(@path)
#     assert_equal(2, @mlayout_document.spread_list.length)
#   end
#   
# end
# 
# describe 'accesing graphics from MDocument' do
#   before do
#     @path=File.dirname(__FILE__) +'/../mlayout/templates/t1_i1.mlayoutP'
#     @mdocument=MDocument.new(@path)    
#   end
#   
#   it 'shoud have width of 595.28' do
#     @mdocument.width.must_equal 595.28
#   end
#   
#   it 'shoud have height of 595.28' do
#     @mdocument.height.must_equal 841.89
#   end
#   
#   it 'should be the double_sized docuemnt' do
#     assert(@mdocument.double_side)
#   end
#   
#   it 'should have paragraph_styles' do
#     assert_kind_of(Array, @mdocument.paragraph_styles)
#   end
#   
#   it 'should have one spread' do
#     @mdocument.spread_list.length.must_equal 1
#   end
#   
#   it 'should access first spread' do
#     assert_kind_of(MSpread,@mdocument.first_spread)
#   end
#   
#   it 'should access graphics array' do
#     assert_kind_of(Array,@mdocument.first_spread.graphics)
#   end
#   
#   it 'should access first graphic in first spread' do
#     assert_kind_of(MGraphic,@mdocument.first_spread.graphics[0])
#   end
#   
#   it 'should access all graphic in first spread' do
#     assert_kind_of(Array,@mdocument.first_spread.graphics)
#   end
#   
#   it 'should access first page of the document' do
#     assert_kind_of(MGraphic,@mdocument.first_page)
#   end
#   
#   it 'should match image tag of 2' do
#     @path=File.dirname(__FILE__) +'/../mlayout/templates/t1_i2.mlayoutP'
#     @mdocument=MDocument.new(@path)    
#     @mdocument.graphics_with_tag("image").length.must_equal 2
#   end
#   
#   it 'should match image tag of 3' do
#     @path=File.dirname(__FILE__) +'/../mlayout/templates/t1_i3.mlayoutP'
#     @mdocument=MDocument.new(@path)    
#     @mdocument.graphics_with_tag("image").length.must_equal 3
#   end
#  
#   it 'should find first_graphic with tag' do
#     assert_kind_of(MGraphic, @mdocument.first_graphic_with_tag('image'))
#   end
# end
# 
# describe 'testing MGraphic' do
#   before do
#     @path=File.dirname(__FILE__) +'/../mlayout/templates/t1_i1.mlayoutP'
#     @mdocument=MDocument.new(@path) 
#     @first_image=@mdocument.first_graphic_with_tag('image')   
#   end
#   
#   it 'should get mgraphic' do
#     assert_kind_of(MGraphic, @first_image)
#   end
#   
#   it 'should convert mgraphic to smgraphic' do
#     assert_kind_of(SMGraphic, @first_image.to_smgraphic)
#   end
# end
# 
# describe 'testing MSpread' do
#   before do
#     @path=File.dirname(__FILE__) +'/../mlayout/templates/t1_i1.mlayoutP'
#     @mdocument=MDocument.new(@path) 
#     @first_spread=@mdocument.first_spread  
#     @pdf_path=(File.dirname(__FILE__) +'/pdf/mconvert_test.pdf')
#      
#   end
#   
#   it 'should get first_spread' do
#     assert_kind_of(MSpread, @first_spread)
#   end
#   
#   it 'should convert mspread to smspread' do
#     assert_kind_of(Array, @first_spread.get_smpages_from_mspread)
#   end
#   
#   it 'should convert MDocument to smdocument' do
#     assert_kind_of(SMDocument, @mdocument.to_smdocument)
#   end
#   
#   it 'should save page' do
#     @smdoc=@mdocument.to_smdocument
#     @smdoc.layout_pageview.save_pdf(@pdf_path)
#     assert(File.exists?(@path))
#     system("open #{@pdf_path}")
#   end
# end
# 
# describe 'convert from mdocumets to smdocuement' do
#   before do
#     @path=File.dirname(__FILE__) +'/../mlayout/templates/t1_i3.mlayoutP'
#     @path='/Users/mskim/Development/mygems/mlayout/lib/mlayout/templates/2E_Sample1.mlayoutP'
#     
#     @mdocument=MDocument.new(@path) 
#     @first_spread=@mdocument.first_spread
#     @pdf_path=(File.dirname(__FILE__) +'/pdf/mconvert_test.pdf')
#   end
#   
#   # it 'should create correct SMPage' do
#   #   @first_smspread=@mdocument.first_spread.to_smspread
#   #   @first_smspread.pages.length.must_equal 1
#   # end
#   
#   it 'should create r.layout ' do
#     @r_path=File.dirname(__FILE__) +'/../mlayout/templates/t1_i3.mlayoutP/r.layout'
#     @mdocument.m2r    
#     assert(File.exists?(@r_path))
#   end
#   
#   it 'should create SMPage' do
#     @r_path=File.dirname(__FILE__) +'/../mlayout/templates/t1_i3.mlayoutP/r.layout'
#     @smdoc=@mdocument.to_smdocument    
#     assert_kind_of(SMDocument, @smdoc)
#     assert_equal(3, @smdoc.pages.length)
#   end
#   
#   it 'should create correct r.layout' do
#     @path='/Users/mskim/Development/mygems/mlayout/lib/mlayout/templates/two_page.mlayoutP'
#     @path='/Users/mskim/Development/mygems/mlayout/lib/mlayout/templates/2E_Sample1.mlayoutP'
#     @pdf_path=(File.dirname(__FILE__) +'/pdf/document_test2.pdf')
#     @doc=SMDocument.open(@path)
#     @doc.save_pdf_document(@pdf_path)
#     system("open #{@pdf_path}")
#     
#     @r_path=@path+'/r.layout'
#     @doc.m2r    
#     assert(File.exists?(@r_path))
#     assert_kind_of(SMDocument, @doc)
#     
#   end
# end
# 

# describe 'create html from mdocumets' do
#   before do
#     @path='/Users/mskim/Development/mygems/mlayout/lib/mlayout/templates/2E_Sample1.mlayoutP'
#     @path=File.dirname(__FILE__) +'/../mlayout/templates/t1_i3.mlayoutP'
#     
#     @mdocument=MDocument.new(@path) 
#     # @first_spread=@mdocument.first_spread
#     @pdf_path=(File.dirname(__FILE__) +'/pdf/mconvert_test.pdf')
#   end
#   
#   it 'should create html' do
#     puts @mdocument.generate_editable_html_document    
#     assert_kind_of(MDocument, @mdocument)
#   end
# end
