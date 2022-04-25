require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create RLaerTable' do
  before do
    data = [
      ["여기는 Chapter_1 제목 입니다", '4'],
      ["여기는 Chapter_1 제목 입니다", '8'],
      ["여기는 Chapter_1 제목 입니다", '20'],
      ["여기는 Chapter_1 제목 입니다", '30'],
      ["여기는 Chapter_1 제목 입니다", '40'],
    ]
    @document_path  = "#{ENV["HOME"]}/test_data/r_leader_table"
    @pdf_path       = "#{ENV["HOME"]}/test_data/r_leader_table/toc.pdf"
    @table          = RLeaderTable.new(document_path: @document_path, table_data: data)
    @link_info      = @table.link_info
  end

  it 'should create RLeaderTable' do
    assert_equal RLeaderTable, @table.class 
  end

  it 'should create link_info' do
    assert_equal @link_info.class, Array 
    assert_equal @link_info.first.class, Hash
    assert_equal @link_info.first[:page_number], '4'
    assert_equal @link_info[1][:page_number], '8'

  end
end