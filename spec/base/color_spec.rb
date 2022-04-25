require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'test ColorList colors' do
  
  before do
    @pdf_path = "#{ENV["HOME"]}/test_data/color/list.pdf"
    h={}
    h[:fill_color] = 'green'
    h[:page_size] = "A4"
    size = SIZES[h[:page_size]]
    width = size[0]
    height = size[1]
    margin = 20
    column = 10
    row = 15
    box_width = (width - margin*2)/column
    box_height = (height - margin*2)/row
    @g = Container.new(h)
    x_pos = margin
    y_pos = margin
    row.times do |j|
      column.times do |i|
        keys = COLOR_LIST.keys
        color_name  = keys[column*j + i] 
        color = COLOR_LIST[color_name]
        h = {}
        h[:parent] = @g
        h[:x] = x_pos
        h[:y] = y_pos
        h[:width] = box_width
        h[:height] = box_height
        h[:fill_color] = color_name
        h[:text_string] = color_name
        h[:text_alignment] = "center"
        h[:font_size] = 9
        RLayout::Text.new(h)
        x_pos += box_width
      end
      x_pos = margin
      y_pos += box_height
    end
  end

  it 'should create red color' do
    @g.save_pdf(@pdf_path)
    system("open #{@pdf_path}")
  end
end

describe 'test Color named color' do
  
  before do
    @pdf_path = "#{ENV["HOME"]}/test_data/color/output.pdf"
    h={}
    h[:fill_color] = 'green'
    @g = Graphic.new(h)
  end

  it 'should create red color' do
    @g.save_pdf(@pdf_path)
    system("open #{@pdf_path}")
  end
end


describe 'text Color rgb color' do
  before do
    @pdf_path = "#{ENV["HOME"]}/test_data/color/05-05-00.pdf"
    h={}
    h[:fill_color] = [0.5,0.5,0.0]
    @g = Graphic.new(h)
  end

  it 'should create red color' do
    @g.save_pdf(@pdf_path)
    system("open #{@pdf_path}")
  end
end


describe 'text Color cmyk color' do
  before do
    @pdf_path = "#{ENV["HOME"]}/test_data/color/0-0-0-0tput3.pdf"
    h={}
    h[:fill_color] = [0.0,0.0,0.0,0.0]
    @g = Graphic.new(h)
  end

  it 'should create red color' do
    @g.save_pdf(@pdf_path)
    system("open #{@pdf_path}")
  end
end

describe 'text Color color list' do
  before do
    @pdf_path = "#{ENV["HOME"]}/test_data/color/LightSalmon.pdf"
    h={}
    h[:fill_color] = 'LightSalmon'
    @g = Graphic.new(h)
  end

  it 'should create LightSalmon color' do
    @g.save_pdf(@pdf_path)
    system("open #{@pdf_path}")
  end
end

describe ' color from list' do
  before do
    @pdf_path = "#{ENV["HOME"]}/test_data/color/AliceBlue.pdf"
    h={}
    # h[:fill_color] = 'LightSalmon'
    # h[:fill_color] = [240,248,255]
    h[:fill_color] = 'AliceBlue'
    
    @g = Graphic.new(h)
  end

  it 'should create AliceBlue color' do
    @g.save_pdf(@pdf_path)
    system("open #{@pdf_path}")
  end
end