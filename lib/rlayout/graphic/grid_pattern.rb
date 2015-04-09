
HEADING_COLUMNS_TABLE = {
  1 => 1,
  2 => 2,
  3 => 2,
  4 => 2,
  5 => 3,
  6 => 3,
  7 => 3
}

GRID_PATTERNS = {"3x3/5"=>
  [[0, 0, 3, 1], [0, 1, 3, 1], [0, 2, 1, 1], [1, 2, 1, 1], [2, 2, 1, 1]],
 "3x3/6"=>
  [[0, 0, 3, 1],
   [0, 1, 2, 1],
   [2, 1, 1, 1],
   [0, 2, 1, 1],
   [1, 2, 1, 1],
   [2, 2, 1, 1]],
 "3x3/7"=>
  [[0, 0, 3, 1],
   [0, 1, 1, 1],
   [1, 1, 1, 1],
   [2, 1, 1, 1],
   [0, 2, 1, 1],
   [1, 2, 1, 1],
   [2, 2, 1, 1]],
 "3x3/8"=>
  [[0, 0, 1, 1],
   [1, 0, 1, 1],
   [2, 0, 1, 1],
   [0, 1, 1, 1],
   [1, 1, 1, 1],
   [2, 1, 1, 1],
   [0, 2, 1, 1],
   [1, 2, 2, 1]],
 "3x3/8_1"=>
  [[2, 0, 1, 1],
   [1, 0, 1, 1],
   [0, 0, 1, 1],
   [2, 1, 1, 1],
   [1, 1, 1, 1],
   [0, 1, 1, 1],
   [2, 2, 1, 1],
   [0, 2, 2, 1]],
 "3x3/8_2"=>
  [[2, 2, 1, 1],
   [1, 2, 1, 1],
   [0, 2, 1, 1],
   [2, 1, 1, 1],
   [1, 1, 1, 1],
   [0, 1, 1, 1],
   [2, 0, 1, 1],
   [0, 0, 2, 1]],
 "3x3/9"=>
  [[0, 0, 1, 1],
   [1, 0, 1, 1],
   [2, 0, 1, 1],
   [0, 1, 1, 1],
   [1, 1, 1, 1],
   [2, 1, 1, 1],
   [0, 2, 1, 1],
   [1, 2, 1, 1],
   [2, 2, 1, 1]],
 "6x6/1"=>[[0, 0, 1, 1]],
 "6x6/3"=>[[0, 0, 1, 1], [0, 0, 1, 1], [0, 0, 1, 1]],
 "7x11/3"=>[[0, 6, 7, 5], [0, 0, 4, 6], [4, 0, 3, 6]],
 "7x11/4"=>[[0, 5, 3, 6], [0, 0, 4, 5], [4, 0, 3, 5], [3, 5, 4, 6]],
 "7x11/5"=>
  [[4, 3, 3, 4], [0, 3, 4, 3], [0, 6, 4, 5], [4, 7, 3, 4], [0, 0, 7, 3]],
 "7x11/6"=>
  [[4, 4, 3, 3],
   [0, 3, 4, 3],
   [0, 6, 4, 5],
   [4, 7, 3, 4],
   [0, 0, 4, 3],
   [4, 0, 3, 4]],
 "7x12/5"=>
  [[0, 0, 7, 1], [0, 7, 7, 5], [4, 1, 3, 4], [0, 1, 4, 4], [0, 5, 7, 2]],
 "7x12/7"=>
  [[0, 0, 7, 1],
   [0, 7, 7, 5],
   [4, 1, 3, 4],
   [0, 1, 4, 2],
   [0, 3, 4, 2],
   [0, 5, 4, 2],
   [4, 5, 3, 2]]}

NEWS_PAPER_DEFAULTS = {
  name: "Ourtown News",
  period: "daily",
  paper_size: "A2"
}

NEW_SECTION_DEFAULTS = {
  :width        => 1190.55,
  :height       => 1683.78,
  :grid         => [7, 12],
  :lines_in_grid=> 10,
  :gutter       => 10,
  :left_margin  => 50,
  :top_margin   => 50,
  :right_margin => 50,
  :bottom_margin=> 50,
}

module RLayout
	class GridPattern



	end

end
