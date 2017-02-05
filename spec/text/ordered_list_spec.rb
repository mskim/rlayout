require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create UpperAlphaList' do
  before do
    @sample_text =<<EOF
1. 구나 절이 주어로 쓰인 경우 본동사 파악하기
주어로 쓰인 to부정사구나 동명사구, 또는 접속사나 의문사가 이끄는 절이 어디까지인지 확인하고, 그 뒤에 이어지는 본동사를 파악한다.
[To tell Miley about her mistake] is important regardless of her achievements. (to부정사구 주어)
	S	V
마일리에게 그녀의 실수에 대해 말하는 것은 그녀의 성취와 상관없이 중요한 일이다.
[Walking alone at night in urban areas] is viewed as a dangerous choice. (동명사구 주어)
	S	V
도시 지역을 밤에 혼자 걷는 것은 위험한 선택으로 여겨진다.
[That traditional marketing strategies are becoming less effective in today’s markets] is obvious. (접속사절 주어)
	S	V
전통적인 마케팅 전략이 오늘날의 시장에서 덜 효과적이 되고 있다는 것은 명백하다.
[Where they came from and why they disappeared] remains an open question. (의문사절 주어)
	S	V
그들이 어디에서 왔고 왜 사라졌는지는 미해결 문제로 남아 있다.
[What is frightening him] is the sense of the unknown stretching into the black distance. (관계대명사절 주어)
	S	V
그를 두렵게 하는 것은 미지의 것이 어두운 먼 곳까지 뻗어 있다는 느낌이다.
EOF
    @ol = OrderedSection.new(text_block: @sample_text)
  end

  # it 'should create OrderedList' do
  #   assert @ol.class == OrderedList
  # end

  it 'should create OrderedListItems' do
    assert @ol.graphics.first.class == OrderedListItem
    @ol.graphics.length.must_equal 17
  end

  it 'should create para_strings' do
    assert_equal  @ol.graphics[0].para_string, "1. 구나 절이 주어로 쓰인 경우 본동사 파악하기"
    assert_equal  @ol.graphics[2].para_string, "[To tell Miley about her mistake] is important regardless of her achievements. (to부정사구 주어)"

  end
end

__END__

describe 'create UpperAlphaList' do
  before do
    @sample_text =<<EOF
A 각 네모 안에서 어법에 맞는 표현을 고르시오.
1	People who use visualization as a support for cancer treatment  discovered the importance of careful image selection.
2	Enough sunlight  on Earth to meet our energy needs ten thousand times over.
3	The study found that the amount of gray and white matter in the left side of the brain  up to ten percent.
4	A good hair stylist knows that what a customer thinks she wants  often not what she really wants.
5	He found that after this period those who had walked in the nature preserve  better than the other participants on a standard proofreading task.
6	If you care about gaining genuine commitment,  the other person the opportunity to say yes to a very specific agreement.
EOF
    @ol = UpperAlphaList.new(text_block: @sample_text)
  end

  # it 'should create OrderedList' do
  #   assert @ol.class == OrderedList
  # end

  it 'should create OrderedListItems' do
    assert @ol.graphics.first.class == OrderedListItem
    assert @ol.graphics.length      == 7
  end

  it 'should create para_strings' do
    assert_equal  @ol.graphics[0].para_string, "A 각 네모 안에서 어법에 맞는 표현을 고르시오."
    assert_equal  @ol.graphics[2].para_string, "2	Enough sunlight  on Earth to meet our energy needs ten thousand times over."

  end
end


describe 'create OrderedList' do
  before do
    @sample_text =<<EOF
. This is first line.
. This is the second line.
.. This is the second and level 1-1 line.
.. This is the second and level 1-2line.
... This is the second and level 1-2-1line.
. This is the third line.
.. This is level 3-1 line.
EOF
    @ol = OrderedList.new(text_block: @sample_text)
  end

  # it 'should create OrderedList' do
  #   assert @ol.class == OrderedList
  # end

  it 'should create OrderedListItems' do
    assert @ol.graphics.first.class == OrderedListItem
    assert @ol.graphics.length      == 7
    assert @ol.graphics[1].order    == 1
    assert @ol.graphics[1].level    == 0
    assert @ol.graphics[2].order    == 0
    assert @ol.graphics[2].level    == 1
    assert @ol.graphics[4].level    == 2
    assert @ol.graphics[4].order    == 0
  end

  it 'should create para_strings' do
    assert  @ol.graphics[0].para_string == "1. This is first line."
    assert  @ol.graphics[2].para_string == "\ta. This is the second and level 1-1 line."

  end
end

describe 'create UnorderedList' do
  before do
    @sample_text =<<EOF
* This is first line.
* This is the second line.
** This is the second and level 1-1 line.
** This is the second and level 1-2line.
*** This is the second and level 1-2-1line.
* This is the third line.
** This is level 3-1 line.
EOF
    @ul = UnorderedList.new(text_block: @sample_text)
  end

  it 'should create UnorderedList' do
    assert @ul.class == UnorderedList
  end

  it 'should create UnrrderedListItems' do
    assert @ul.graphics.first.class == UnorderedListItem
    assert @ul.graphics.length      == 7
    assert @ul.graphics[1].order    == 1
    assert @ul.graphics[1].level    == 0
    assert @ul.graphics[2].order    == 0
    assert @ul.graphics[2].level    == 1
    assert @ul.graphics[4].level    == 2
    assert @ul.graphics[4].order    == 0
  end
  #
  # it 'should create para_strings' do
  #   assert  @ol.graphics[0].para_string == "1. This is first line."
  #   assert  @ol.graphics[2].para_string == "\ta. This is the second and level 1-1 line."
  #
  # end
end
