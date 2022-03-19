require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'creating MemberItem' do
  before do
    @pdf_path = "/Users/Shared/rlayout/output/member/minsookim.pdf"
    image_path = "/Users/mskim/Pictures/Photo_Booth/minsookim.jpg"
    @member   = MemberItem.new(image_path: image_path, name: "김민수", spouse: "(김지윤)", phone: "010-7468-0000", cell: "010-7468-8222")
  end
  
  it 'should create MemberItem' do
    assert @member.class == MemberItem
    assert @member.name == "김민수"
    assert @member.container_object.class == Container
  end
  
  it 'should save member_item' do
    @member.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
  end
  
end

__END__
describe 'should create MemberDirectory' do
  before do
    @pdf_path = "/Users/Shared/rlayout/output/member_item.pdf"
    @pdf_path = File.dirname(__FILE__) + "/member.csv"
    @directory = MemberDirectory.new(csv_path: @csv_path )
  end
  
  # it 'should save MemberDirectory' do
  #   @member.save_pdf(@pdf_path)
  #   File.exist?(@pdf_path).must_equal true
  #   system("open #{@pdf_path}")
  # end
end