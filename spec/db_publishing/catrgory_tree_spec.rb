require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

CSV_DATA = [
  ["category", "Area", "Name", "Spouse"],
  ["category1", "Jookjun", "Min Soo kim", "Jeeyoon Kim"],
  ["category1", "Jookjun", "Tae Soo kim", "Yunhee Kim"],
  ["category1", "Jookjun", "Dongmyung Lee", "Someone Kim"],
  ["category1", "Jookjun", "Duke kim", "Someone Park"],
  ["category1", "Jookjun", "Young Kwan Yoon", "Some Choi"],
  ]
  

describe 'create CategoryTree' do
  before do
    @ct = CategoryTree.new(:csv => CSV_DATA)
  end
  
  it 'should create CategoryTree' do
    @ct.must_be_kind_of CategoryTree
  end
  
end