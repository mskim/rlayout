Marathon_Layout =<<EOF
RLayout::Page.new(nil, width:400, height:300)
  image(image_path:"logo.jpg")
  
EOF

module RLayout
  
  class MarathonTagGenerator
    attr_accessor :project_path, :starting, :count, :template, :numbers
    
    def initialize(path, starting=0, count=10, options={})
      @path       = path
      @starting   = starting
      @count      = count
      @template   = options.fetch(:template, "default.rb")
      @need_qrcode    = options.fetch(:need_qrcode, true)
      @need_barcode    = options.fetch(:need_barcode, true)
      setup
      generate_numbers
      # generate_pdf
      self
    end
    
    def pdf_path
      @path + "/pdf"
    end
    
    def images_path
      @path + "/images"
    end
    
    def qrcode_path
      images_path + "/qrcode"
    end
    
    def bar_path
      images_path + "/qrcode"
    end
    
    def setup
      FileUtils.mkdir_p(@path)        unless File.directory?(@path)
      FileUtils.mkdir_p(pdf_path)    unless File.directory?(pdf_path)
      FileUtils.mkdir_p(qrcode_path) unless File.directory?(qrcode_path)
      FileUtils.mkdir_p(bar_path)    unless File.directory?(bar_path)
    end
    
    def generate_numbers
      @numbers = []
      @count.times do |i|
        number = @starting + i
        rjusted_number = number.to_s.rjust(5,"0")
        puts "+++++:#{rjusted_number}"
        generate_qrcode(rjusted_number) if @need_qrcode 
        generate_barcode(rjusted_number) if @need_barcode 
        generate_pdf(rjusted_number)
      end
      # system("qrcode #{number} -o #{qrcode_path + "/#{number}")
    end
    
      
    def generate_qrcode(number)
      puts "generating qrcode:#{number}"
    end
    
    def generate_barcode(number)
      puts "generating barcode:#{number}"
    end
    
    def generate_pdf(number)
      puts "generating pdf:#{number}"
    end
  end
  
end

__END__
require 'minitest/autorun'
include RLayout
describe 'create MarathonTagGenerator class' do
  before do
    @path = "/Users/mskim/marthon"
    @m    = MarathonTagGenerator.new(@path)
  end
  
  it 'should create a class' do
    assert @m.class == MarathonTagGenerator
  end
end