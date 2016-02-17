require File.dirname(__FILE__) + "/../spec_helper"


describe 'create music_chapter' do
  before do
    @source_path = "/Users/Shared/piano_cord"
    # @music_ch    = MusicChapter.new(title: 'my first music sample', source_path: @source_path)
    @pdf_path = "/Users/Shared/rlayout/output/music_chapter_sample.pdf"
  end
  
  it 'should save pdf' do

script = <<-EOF
  @output_path = "#{@pdf_path}"
  @title       = "This is sample title"
  RLayout::MusicChapter.new(title: @title, source_path: "#{@source_path}")
EOF
    system "echo '#{script}' | /Applications/rjob.app/Contents/MacOS/rjob"
    File.exists?(@pdf_path).must_equal true
  end
end

__END__
describe 'create music_chapter' do
  before do
    @source_path = "/Users/Shared/piano_cord"
    @music_ch    = MusicChapter.new(title: 'my first music sample', source_path: @source_path)
    @pdf_path = "/Users/Shared/rlayout/output/music_chapter_sample.pdf"
  end
  
  it 'should create MusicChapter' do
    @music_ch.must_be_kind_of MusicChapter
    @music_ch.pages.length.must_equal 2
  end
  
  it 'should save yml' do
     @yml_path = "/Users/Shared/rlayout/output/music_chapter_sample.yml"
     @music_ch.save_yml(@yml_path)
     File.exists?(@yml_path).must_equal true
   end
end 

describe 'create music_chapter' do
  before do
    @source_path = "/Users/Shared/piano_cord"
    @music_ch    = MusicChapter.new(title: 'my first music sample', source_path: @source_path)
    @first_page  = @music_ch.pages.first
    @main_box   = @first_page.main_box
    puts @first_page.left_margin
    puts @first_page.top_margin
    @main_box.puts_frame
  end
  
  it 'should create MusicChapter' do
    assert @music_ch.class == MusicChapter
  end
end

