
@output_path = "/Users/mskim/Development/ruby/gems/rlayout/samples/2.container/layout/dimemsion_sample.pdf"
RLayout::Container.new(nil, width: 500, height: 600, layout_space: 0, pdf_path: @output_path) do
   rectangle(fill_color: "red", inset: 0, margin: 0, stroke_width: 2)
   rectangle(fill_color: "red", inset: 0, margin: 0, stroke_width: 2)
   rectangle(fill_color: "red", inset: 0, margin: 0, stroke_width: 2)
   relayout!
   
   puts "@layout_space:#{@layout_space}"
end