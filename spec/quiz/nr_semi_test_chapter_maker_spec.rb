require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create NRSemiTestChapterMaker' do
  before do
    @path       = '/Users/mskim/demo_english_parts/semi_test'
    @path       = "/Users/mskim/demo_book_plan/PART1_어법/03_가주어와_가목적어/어법_Semi_Test_01"
    @path       = "//Users/mskim/Development/rails_rlayout/tree/public/1/6/28/29"
    @q_chapter  = NRSemiTestChapterMaker.new(project_path: @path)
  end
  
  it 'should create NRSemiTestChapterMaker' do
    assert  @q_chapter.class == NRSemiTestChapterMaker
  end
end

__END__

describe 'convert tsv to csv' do
  before do
tsv_text =<<EOF
	(A)	(B)	(C)
① creates   ······   which   ······   disrupts
② creates   ······   who   	······   disrupt
③ create   	······   which   ······   disrupt
④ create   	······   who   	······   disrupt
⑤ create   	······   who   	······   disrupts
EOF
    @csv = ENQuizParser.convert_tsv_to_csv(tsv_text)
    puts @csv  
  end
  
  it 'should convert' do
    assert true == true
  end 
end

