
# MDocument handles MLayout2 documents, read, create, modify, and save
# We have two groups of classes, one group of classes starting with no prefix and the other starting with M prefix. 
# no starting cleass represents the new Ruby based format.
# M represents the old MLayout NSDictionary format
module RLayout
  
  class MSpread
    attr_accessor :graphics, :dictionary, :mdocument, :document_path
    
    # initialize it with MLayout 2.0 property_list spread dictionary
    def initialize(mdocument,dictionary)
      @mdocument      =mdocument
      @document_path  =mdocument.document_path
      @dictionary     =dictionary
      @graphics       =[]
      @smgraphics     =[]
      @smpages        =[]
      graphics_array=dictionary['GraphicContainer']['Graphics']
      for graphic_dictionary in graphics_array do
        mgraphic=MGraphic.new(graphic_dictionary, @mdocument.paragraph_styles, :document_path=>@document_path)
        @graphics<< mgraphic
      end
      self
    end
    
    def serialize_spread
      require 'yaml'
      graphics=[]
      @graphics.each do |g|
        graphics<<g.serialize_graphic
      end
      graphics.to_yaml
    end 
    
    def insert_graphic(new_graphic)
      
    end
    
    def edit_graphic(graphic)
      
    end
    
    def remove_graphic(graphic)
      
    end
    
    def smgraphics
      graphics_array=@dictionary['GraphicContainer']['Graphics']
      for graphic_dictionary in graphics_array do
        mgraphic=MGraphic.new(graphic_dictionary)
        @graphics<< mgraphic
        @smgraphics<< mgraphic.to_smgraphic(:bleed_x=>@mdocument.bleed_x,:bleed_y=>@mdocument.bleed_y)
      end
      @smgraphics
    end
    
    
    def first_page
      @graphics.each do |graphic|
        return graphic if graphic.class=="SMPageObject"
      end
      return nil
    end
    
    def all_spread_graphics_with_tag
      graphics_with_tag=[]
      @graphics.each do |graphic|
         graphics_with_tag << graphic if graphic.dictionary['Name']
      end
      graphics_with_tag
    end

    def first_graphic_with_tag(tag)
      @graphics.each do |graphic|
        puts graphic.dictionary['Name']
        return graphic if graphic.dictionary['Name']=~/#{tag}/
      end
      nil
    end
    
    def graphics_with_tag(tag)
      graphics_array=[]      
      @graphics.each do |graphic|
        graphics_array<< graphic if graphic.dictionary['Name']=~/#{tag}/
      end
      graphics_array
    end
    
    def graphics_of_kind(kind)
      graphics_array=[]      
      @graphics.each do |graphic|
        graphics_array<< graphic if graphic.kind=~/#{kind}/
      end
      graphics_array
    end
    
    # to_smspread converts mspread(MLayout 2.0 property_list) based into new smpread.
    # The main differnce between mspread and smspread is how the page functions
    # In mspread, pages are just like any other graphic objects, they just belong to th mspread with rest of the graphics object as backgrond.
    # This creates some problem when we need to detemine the frame of graphic objects to user interface. If changes depending wheather graphic object lies in the lest page or the right page.
    # So, the new smspread are changed, so the pages are the main childern of smspread, and all other graphis belings to the proper page, so we don't have to transform the codinates back and force form spraad cordinate to page cordinates.
    # But this has some disadvantages, too.
    # If you have a picture that lies across two pages, it can be easyly impleamentedin mspread. Just place the image in between two pages. 
    # I think this how it's done with QuarkXpress and InDesign.
    # But with new smspread it is not so easy. I have to make a copy of the image and place it twice, one in the left and one one the right where there are cropped.
    # But over all, I think new way is lot better. And I am going to stick to it.

    def get_smpages_from_mspread
      mid_point=@mdocument.mid_point
      # smspread=Spread.new(:double_side=>@mdocument.double_side, :width=>@mdocument.width, :height=>@mdocument.height)
      @smpages=[]
      @graphics.each do |mgraphic|
        if mgraphic.kind=="SMPageObject"
          # frame=NSRect.new(NSPoint.new(0,0), NSSize.new(@mdocument.width, @mdocument.height))
          @smpages << Page.new(width: @mdocument.width, height: @mdocument.height)
        end
      end
      right_page_x_offset=@mdocument.width
      @graphics.each do |mgraphic|
        next if mgraphic.kind=="SMPageObject"
        if NSRectFromString(mgraphic.dictionary['Bounds']).origin.x < mid_point
          @smpages[0].graphics << mgraphic.to_smgraphic(:bleed_x=>@mdocument.bleed_x,:bleed_y=>@mdocument.bleed_y)
        elsif @smpages.length>1
          # We are dealing with the graphics that are in the right side page
          # Since MLayout is based on spread,not page, graohics on the right side page have the differnce x-cordinate. So we have to adjsut the x values  
          @smpages[1].graphics << mgraphic.to_smgraphic(:bleed_x=>@mdocument.bleed_x + right_page_x_offset,:bleed_y=>@mdocument.bleed_y)
        else
          @smpages[0].graphics << mgraphic.to_smgraphic(:bleed_x=>@mdocument.bleed_x,:bleed_y=>@mdocument.bleed_y)
        end
      end
      @smpages
    end
    
    def html_attrubutre(dictionary)
      if dictionary['Article']
        
      end
    end
    
    def html_text(dictionary)
      html_text=""
      if dictionary['Article']
        
      end
      html_text
    end
    
    
    def html_position(dictionary)  
      rect= NSRectFromString(dictionary['Bounds'])  
      "style=\"position:absolute; left:#{rect.origin.x.to_i}px; top:#{rect.origin.y.to_i}px; width:#{rect.size.width.to_i}px; height:#{rect.size.height.to_i}px;\""
    end
    
    def double_page_html_position(pages)
      first_page_rect=NSRectFromString(pages[0].dictionary['Bounds'])
      if pages.length==2
        second_page_rect=NSRectFromString(pages[1].dictionary['Bounds'])
        dobule_page_rect=NSUnionRect(first_page_rect,second_page_rect)
      else
        dobule_page_rect=NSMakeRect(first_page_rect.origin.x, first_page_rect.origin.y, first_page_rect.size.width*2, first_page_rect.size.height) 
      end
      "style=\"position:absolute; left:#{dobule_page_rect.origin.x.to_i}px; top:#{dobule_page_rect.origin.y.to_i}px; width:#{dobule_page_rect.size.width.to_i}px; height:#{dobule_page_rect.size.height.to_i}px;\""
    end
    
    # I want to generate html page with tagged graphics
    def generate_editable_html_spread(spread_index)
      tagged_ones=all_spread_graphics_with_tag
      spread_html=""
      pages=[]
      page_html=""   
      graphics_html=""
      tagged_ones.each do |graphic|
        if graphic.kind=="SMPageObject"    
          # collect page objects  in an array. 
          # after all the page objects have been collected 
          # combined the page rectangles of the double two page     
          pages<<graphic

        else
          graphic_div=<<EOF
                  <div class="graphic" contenteditable="true" id="#{graphic.kind}" #{html_position(graphic.dictionary)}></div> \n
EOF
          graphics_html+=graphic_div
        end
        
      end
      puts "@mdocument.double_side:#{@mdocument.double_side}"
      if @mdocument.double_side  != "YES" # single page document
        graphic_div=<<EOF
          <img class="page" src="spread_preview_000#{spread_index + 1}.jpg" #{html_position(pages[0].dictionary)}></img> \n
EOF
        page_html+= graphic_div
      else  # double sided spread
        graphic_div=<<EOF
          <img class="page" src="spread_preview_000#{spread_index + 1}.jpg" #{double_page_html_position(pages)}></img> \n
EOF
        page_html+= graphic_div
      end
      # page_html should come before others, so it does not block others from selecting
      spread_html=page_html + graphics_html
    end
    
    #
    def save_page_tempaltes(tempaltes_folder, options={})
      require 'json'
      json=@dictionary.to_json
      path=tempaltes_folder + "/page_profile"
      File.open(path, 'w'){|f| f.write json}
    end
    
  end
  

  class MDocument 
    attr_accessor :document_path, :spread_list,:smspreads,:paper_size, :width, :height, :double_side, :paragraph_styles, :bleed_x, :bleed_y
  
    def initialize(path)
      @document_path=path
      @spread_list=[]
      if File.exists?(@document_path)  
        @spread_list=parse_mfile
      else
        puts "MLayout file doesn't exist at #{path}"
      end
      self
    end
  
    def mid_point
      @bleed_x + @width
      
    end
    
    def size
      [@width,@height]
    end
    
    def serialize
      require 'yaml'
      spread_list=[]
      @spread_list.each do |spread|
        spread_list<<spread.serialize_spread
      end
      spread_list.to_yaml
    end
    
    def smdocument_hash
      h = {}
      h[:path]            = @document_path
      h[:width]           = @width
      h[:height]          = @height
      h[:paragraph_styles]= @paragraph_styles
      h[:double_side]     = @double_side
      h[:page_objects]    = smpages
      h
    end
    
    def smpages
      smpages_array=[]
      @spread_list.each do |spread|
        smpages_array+= spread.get_smpages_from_mspread
      end
      smpages_array
    end
    
    # convert m.layout file to r.layout as yml file
    def m2r
      r_path=@document_path+"/m.yaml"
      r_layout=serialize
      # File.open(content_xml_path,'w') {|f| f.write content_xml}
      # r_layout=@spread_list.to_yaml
      File.open(r_path, 'w') {|f| f.write r_layout}
    end
    
    # Convert to smdocument from MLayout2.0 Document
    def self.to_rlayout(path)
      @smdocument_hash=MDocument.new(path).smdocument_hash
      document=Document.new(@smdocument_hash)
      ext = File.extname(path)
      rlayout_foler = path.gsub(ext, ".rlayout")
      system "mkdir #{rlayout_foler}" unless File.directory?(rlayout_foler)
      rlayout_path = rlayout_foler + "/layout.rb"
      document.save_document_layout(output_path: rlayout_path)
    end
    
    # convert from smdocument to MLayout2.0 Document

    def parse_mfile 
      mdictionary_path=@document_path + '/m.layout'
      mdictionary=NSDictionary.dictionaryWithContentsOfFile(mdictionary_path)
      size_string=mdictionary['PaperSize'].to_s
      s=size_string.gsub("{","").gsub!("}","")
      size_array=s.split(",")
      @width=size_array[0].to_f
      @height=size_array[1].to_f
      @paragraph_styles=mdictionary['ParagraphStyle']
      @double_side=mdictionary['PageInfo']['Spread']
      @bleed_x=mdictionary['PageInfo']['Bleed'].to_f
      @bleed_y=mdictionary['PageInfo']['BleedV'].to_f
      @paper_size=mdictionary['PageInfo']['PaperSize'].split("()")[0]
      @page_number=mdictionary['PageInfo']['pageNumber']
      @auto_page_append=mdictionary['PageInfo']['AutoPageAppend']
      spreads=mdictionary['Pages']
      spread_list=[]
      for spread in spreads do
        mspread=MSpread.new(self,spread)
        @spread_list<<mspread
      end
      @spread_list
    end
    
    def paragraph_style_named(style_name)
      @paragraph_styles.each do |para_style|
          return para_style if style_name=~/^#{para_style['StyleName']}/
      end
      nil
    end
    
  
    def first_spread
      @spread_list[0]
    end
    
    def second_spread
      @spread_list[1]
    end
    
    def first_page
      first_spread.first_page
    end
    
    def first_graphic_with_tag(tag)
      first_graphic=nil
      for spread in @spread_list do
        first_graphic=spread.first_graphic_with_tag(tag)
        return first_graphic 
        
      end
      first_graphic
    end
    
    def get_spread_at(spread_index)
      @spread_list[spread_index]
    end
  
    def add_page
    
    end
  
    def delete_page
    
    end
  
    def add_spread
    
    end
  
    def delete_spread
    
    end
    
    # save html files for each spread
    def save_html(html_foler_path)
      html_files=generate_editable_html_document 
      html_files.each_with_index do |html, index|   
        html_path=html_foler_path + "/#{index + 1}.html" 
        File.open(html_path,'w'){|f| f.write html}
      end
    end
    
    def generate_editable_html_document
      puts "in generate_editable_html_document"
      html_files_for_spreads=[]
      html_front=<<EOF
  <!DOCTYPE html>
  
  <html>
    <head>
      <title>bounds test</title>
    	<style>
  		.graphic:hover
  		  { 
    			color:red;
    			border:solid;
  		  }


    	</style>
    </head>
    <body> \n
    <button>Save</button>
    <button>Preview</button>
    <button>Edit</button>

EOF
      html_ending=<<EOF
      </body>
  </html>

EOF
      

      @spread_list.each_with_index do |spread, index|
        html_text=html_front + spread.generate_editable_html_spread(index) + html_ending
        html_files_for_spreads << html_text
      end
      html_files_for_spreads
    end
    
    # Save page template in output_path with types specified in type option
    def save_document_page_tempaltes(output_folder_path, options={})
      spread_list.each do |spread|
        spread.save_page_tempaltes(output_folder_path)
      end
    end
    
    # within mlayoutP file, create webtop related files
    def make_webtop_files
      #create web folder
      web_path=@document_path + "/web"
      system("mkdir #{web_path}") unless File.exists?(web_path)
      make_mjob_files("MakeContentsXML")
      system("cd #{@document_path} && open MakeContentsXML.mjob")
      copy_stamped_preview
    end
    
    # copy stamped preview and remove the stamp from the file name
    def copy_stamped_preview
      web_folder=@document_path + "/web"
      stamp_file=@document_path + "/web/stamp.txt"
      if File.exists?(stamp_file)
        stamp=File.open(stamp_file, 'r'){|f| f.read}
        filesInDir=Dir.entries(web_folder)
        filesInDir.each do |file|
          if file =~/_#{stamp}/
            system("cd #{web_folder} && cp #{file} #{file.gsub("_#{stamp}","")}")
          end
        end
      end
      
      if File.exists?(web_folder)
      end
      
    end
    
    def make_mjob_files(action)
      content=<<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Action</key>
	<string>#{action}</string>
	<key>DocPath</key>
	<string>#{@document_path}</string>   

</dict>
</plist>
</xml>
      
EOF
      mjob_path=@document_path + "/#{action}.mJob"
      File.open(mjob_path, 'w'){|f| f.write content}
    end
  end
  
  
  # extract tagged graphics contents, so that we can replace them
  def extract_tagged_graphics_contents
    tagged_graphics=[]
    @spread_list.each do |spread|
      tagged_graphics<<spread.all_spread_graphics_with_tag
    end
    
    
  end

end

__END__

require 'minitest/autorun'

include MLayout

describe 'should parse mlayout' do
    before do
      @template_path='/Users/mskim/Development/mygems/mlayout/lib/experiments/pdf_manipulation/1.mlayoutP'
      @mdocument=MDocument.new(@template_path) 
      
    end
    
    it 'should create r.yaml' do
      sp=@mdocument.spread_list
      g_list=sp[0].graphics
      g_list.each do |g|
        puts g.kind
      end
      assert_kind_of(Array, sp)
      
    end
end



describe 'converting from m.layout to r.yaml html' do
    before do
      @path='/Users/mskim/Development/mygems/mlayout/lib/mlayout/templates/2E_Sample1.mlayoutP'
      @mdocument=MDocument.new(@path) 
      @r_path=@path + "/r.yaml"
    end
#     it 'should create r.yaml' do
#       @mdocument.m2r
#       assert(File.exists?(@r_path))
#       
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
  it 'should create html' do
    @path='/Users/mskim/Development/mygems/mlayout/lib/mlayout/templates/2E_Sample1.mlayoutP'
    @html_path='/Users/mskim/Development/mygems/mlayout/lib/mlayout/templates/2E_Sample1.mlayoutP/web'
    @mdocument=MDocument.new(@path) 
    
    @mdocument.save_html(@html_path)
    assert(File.exists?(@html_path))
    system("open #{@html_path}/1.html")
  end
  

end

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
