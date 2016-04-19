require File.dirname(__FILE__) + "/../spec_helper"

# describe 'TextField creation' do
#   before do
#     options={
#       key: "name",
#       data: "Min Soo Kim"
#     }
#     @t_field = TextField.new(options)
#   end
#   
#   it 'should create TextField' do
#     @t_field.must_be_kind_of TextField
#   end
#   
#   it 'TextField should have layout_direction as horizontal ' do
#     @t_field.layout_direction.must_equal 'horizontal'
#   end
#   
#   it 'label should be kind of text, and have string as name ' do
#     @t_field.label.must_be_kind_of Text
#     @t_field.label.text_string.must_equal "name"
#   end
#   
#   it 'data_field should be kind of text, and have string as Min Soo Kim ' do
#       @t_field.data_field.must_be_kind_of Text
#       @t_field.data_field.text_string.must_equal "Min Soo Kim"
#   end
#   
# end

describe 'TextForm' do
  before do
    @page     = Page.new(nil)
    @pdf_path = "/Users/Shared/rlayout/output/text_form.pdf"
    options   = {
        keys: ["Name", "Email","Phone",],
        data: ["Min Soo Kim", "mskimsid@gmail.com", "010-7468-8222"],
        # left_margin: 200,
        x: 100,
        y: 100,
        width: 400,
        height: 50,
        # layout_expand: [],
        # fill_color: 'green'
    }
    @t_form   = TextForm.new(@page, options)
    @t_form.relayout!
    @t_form.fit_text_to_box
    @t_form.puts_frame
    
    @t_form.graphics.each do |graphic|
      puts "+++++++ "
      graphic.puts_frame
      @t_form.puts_margin
    end
  end
  
  # it 'should create TextForm' do
  #   @t_form.must_be_kind_of TextForm
  # end
  
  it 'should save_pdf' do
    @page.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
    system("open #{@pdf_path}")
  end
end