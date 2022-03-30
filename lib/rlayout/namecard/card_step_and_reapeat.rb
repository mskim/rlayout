#
#  step_and_reapeat.rb
#  CaraYongImposition
#
#  Created by Min Soo Kim on 2/19/12.
#  Copyright 2012 __MyCompanyName__. All rights reserved.
#
# framework 'cocoa'
# framework 'Quartz'


# def mm2pt(mm)
#   if mm.kind_of?(NSSize)
#     NSSize.new(mm2pt(mm.width), mm2pt(mm.height))
#   elsif mm.kind_of?(NSRect)
#     NSRect.new(NSPoint.new(mm2pt(mm.origin.x), mm2pt(mm.origin.y)), NSSize.new(mm2pt(mm.size.width), mm2pt(mm.size.height)))
#   else
#     mm * 2.834646
#   end
# end

# Step N Repeat Page draws front and back side as @front_page_mode is true or false
# It return PDF page data to object that calls paf_data
# In this case CardStepAndRepeat calls CardSnrPage 

# class CardSnrPage < NSView
module RLayout
class CardSnrPage < Container

  # front_page_mode: we have two drawing mode, one is for front side page and other mode is when printing back side page. 
  #{}"front_page_mode=true" indicates front page printing mode
  attr_accessor :front_page_mode, :right_most_x, :card_width, :card_height, :x_margin, :y_margin, :rows, :columns, :card_front_side, :card_back_side, :delivery_address
  attr_accessor :card_path

  def initialize(options={})
    super
    @front_page_mode = options[:front_page_mode] || true
    @card_path = options[:card_path]
    @columns = 3
    @rows = 8
    # @card_width=150
    # @card_height=90
    @x_margin=mm2pt(7)
    @y_margin=mm2pt(11)
    @x_gutter=mm2pt(7.556)
    @y_gutter=mm2pt(3.5278)
    @bleed=mm2pt(1)
    layout_cards
    self
  end
  
  def layout_cards
  # def drawRect(r)
    # NSColor.grayColor.set
    x=@x_margin
    y=@y_margin
    @card_width = mm2pt(90)
    @card_height = mm2pt(50)
    
    # @right_most_x=bounds.size.width - (@x_margin+@card_size.width) 
    @rows.times do |row|
      return unless @card_path
      x=@x_margin 
      @columns.times do |c|
        h = {}
        h[:parent] = self
        h[:image_path] = @card_path
        h[:x] = x
        h[:y] = y
        h[:width] = @card_width
        h[:height] = @card_height
        Image.new(h)
        # draw_registation_mark_around_card(rect) if @front_page_mode
        x += @card_width + @x_gutter
      end  
      y += @card_height + @y_gutter
      # draw_delivery_address     
    end
    # draw_starting_mark_bar
  end
  
  # def draw_starting_mark_bar
  #   rect=NSMakeRect(190,8,50,2)
  #   NSColor.blackColor.set
	# 	NSRectFill(mm2pt(rect))
  # end
  
  def draw_registation_mark_around_card(rect)
    path= NSBezierPath.bezierPath
    # left top
    path.moveToPoint(NSPoint.new(rect.origin.x,rect.origin.y-2))
    path.lineToPoint(NSPoint.new(rect.origin.x,rect.origin.y-4))
    path.stroke 
    path.moveToPoint(NSPoint.new(rect.origin.x-2,rect.origin.y))
    path.lineToPoint(NSPoint.new(rect.origin.x-4,rect.origin.y))
    path.stroke 
    # right top
    path.moveToPoint(NSPoint.new(rect.origin.x+ rect.size.width+2,rect.origin.y))
    path.lineToPoint(NSPoint.new(rect.origin.x+ rect.size.width+4,rect.origin.y))
    path.stroke 
    path.moveToPoint(NSPoint.new(rect.origin.x+ rect.size.width,rect.origin.y-2))
    path.lineToPoint(NSPoint.new(rect.origin.x+ rect.size.width,rect.origin.y-4))
    path.stroke 
    # right bottom
    path.moveToPoint(NSPoint.new(rect.origin.x+ rect.size.width+2,rect.origin.y+rect.size.height))
    path.lineToPoint(NSPoint.new(rect.origin.x+ rect.size.width+4,rect.origin.y+rect.size.height))
    path.stroke 
    path.moveToPoint(NSPoint.new(rect.origin.x+ rect.size.width,rect.origin.y+rect.size.height+2))
    path.lineToPoint(NSPoint.new(rect.origin.x+ rect.size.width,rect.origin.y+rect.size.height+4))
    path.stroke 
    # left bottom
    path.moveToPoint(NSPoint.new(rect.origin.x-2,rect.origin.y+rect.size.height))
    path.lineToPoint(NSPoint.new(rect.origin.x-4,rect.origin.y+rect.size.height))
    path.stroke 
    path.moveToPoint(NSPoint.new(rect.origin.x, rect.origin.y+rect.size.height+2))
    path.lineToPoint(NSPoint.new(rect.origin.x, rect.origin.y+rect.size.height+4))
    path.stroke 
  end
  
  # def draw_delivery_address
    
  # end
  
  # def save_pdf(path)
  #   dataWithPDFInsideRect(bounds).writeToFile(path, atomically:true)
  # end
  
  # def paf_data
  #   self.dataWithPDFInsideRect(bounds)
  # end
  
end

# CardStepAndRepeat
# given single card pdf(*.pdf), save step and reapeat pdf(*_snr.pdf)
class CardStepAndRepeat
  attr_accessor :card_path, :step_pdf_path, :view, :card_width, :card_height
  attr_accessor :paper_size, :rows, :columns, :x_margin, :y_margin, :x_gutter, :y_gutter
  def initialize(card_path, options={})
    @card_path= card_path
    if options[:step_pdf_path]
      @step_pdf_path= options[:step_pdf_path]
    else
      @step_pdf_path= @card_path.gsub(".pdf", "_snp.pdf")
    end
    @paper_size= options.fetch(:paper_size,'A3')
    @rows     = options.fetch(:rows,8)
    @columns  = options.fetch(:columns,3)
    @x_margin = mm2pt(options.fetch(:x_margin,10))
    @y_margin = mm2pt(options.fetch(:y_margin,10))
    @x_gutter = mm2pt(options.fetch(:x_gutter,2))
    @y_gutter = mm2pt(options.fetch(:y_gutter,2))
    
    if @paper_size=="A3"      
      # @frame=NSRect.new(NSPoint.new(0,0),NSSize.new(mm2pt(595.28), mm2pt(841.89)))
      @frame=[0, mm2pt(595.28), 0, mm2pt(841.89)]
      @columns=3
      @rows=8
    elsif @paper_size=="A4"
      # @frame=NSRect.new(NSPoint.new(0,0),NSSize.new(1190.55, 841.89))
      # @frame=NSRect.new(NSPoint.new(0,0),NSSize.new(mm2pt(315), mm2pt(467)))
      @frame=[0, mm2pt(315), 0, mm2pt(467)]
      @columns=2
      @rows=4
    end    
    # @view=CardSnrPage.new(frame: @frame)
    # @view.rows = @rows
    # @view.columns = @columns
    # @view.x_margin = @x_margin
    # @view.y_margin = @y_margin
    # @x_gutter = @x_gutter
    # @y_gutter = @y_gutter

    @card_pdf = HexaPDF::Document.open(@card_path)
    
    # @card_front_side = @card_pdf.pages[0]
    # @card_back_side = @card_pdf.pages[1] if @card_pdf.pages.length > 1

    # check if the pdf file is two page document
    snr_doc = RLayout::RDocument.new(paper_size: 'A3', page_count: 0)

    if @card_pdf.pages.length > 1
      @snr_front_page = RLayout::CardSnrPage.new(paper_size: @paper_size, card_path: @card_path)
      snr_doc.add_page(@snr_front_page)

      # TODO we want to draw back side
      # save back side as pdf document

      folder_path  = File.dirname(@card_path)
      pdf_basename = File.basename(@card_path, '.pdf')
      first_page = "#{pdf_basename}_0001.pdf"
      second_page = "#{pdf_basename}_0002.pdf"
      @back_card_pdf = folder_path + "/#{second_page}"
      # puts folder_path
      # puts pdf_basename
      # puts first_page
      # puts second_page
      # puts @back_card_pdf
      # puts "cd #{folder_path} && hexapdf split #{pdf_basename} --force"
      # puts "cd #{folder_path} && rm #{first_page} && rm #{second_page}"
      # split output_path pdf into 4 digit single page pdfs
      # 0001.pdf, 0002.pdf, 0003.pdf ...
      system("cd #{folder_path} && hexapdf split #{pdf_basename}.pdf --force")
      # system("cd hexapdf split #{@card_path}")
      @snr_back_page = RLayout::CardSnrPage.new(paper_size: @paper_size, card_path: @back_card_pdf, front_page_mode: false)
      snr_doc.add_page(@snr_back_page)
      # delete spit pages
      # sleep 3
      system("cd #{folder_path} && rm #{first_page}")
    else
      @snr_front_page = RLayout::CardSnrPage.new(paper_size: @paper_size, card_path: @card_path)
      snr_doc.add_page(@snr_front_page)
    end
    snr_doc.save_pdf(@step_pdf_path)
  end 

  # process folder with card pdf
  def self.process_folder(pdf_folder, options={})
    Dir.glob("#{pdf_folder}/*.pdf").each do |card_pdf|
      basename = File.basename(card_pdf, ".pdf")
      output_path = pdf_folder + "#{basename}_snr.pdf"
      CardStepAndRepeat.new(card_path, output_path)        
    end
    
  end
  
end
end

