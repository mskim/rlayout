require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create LeaderCell' do
  before do
    @leader_cell = LeaderCell.new(leader_char: '.', style_name:'leader_celll')
  end

  it 'should create LeaderCell ' do
    assert LeaderCell, @leader_cell.class
  end


end
