module RLayout
  require 'rqrcode'
  class QrGenerator
    attr_reader :name, :org, :title, :tel, :url, :email, :address

    def initialize(card_data)
      @name = card_data[:name]
      @org = card_data[:org]
      @title = card_data[:title]
      @tel = card_data[:tel]
      @url = card_data[:url]
      @email = card_data[:email]
      self
    end

    def slug
      @name.gsub(" ",  "_")
    end
  
    def generate(output_path)
      qrcode = RQRCode::QRCode.new(vcard)
      png = qrcode.as_png(
        bit_depth: 1,
        border_modules: 1,
        color_mode: ChunkyPNG::COLOR_GRAYSCALE,
        color: "black",
        file: nil,
        fill: "white",
        module_px_size: 20,
        resize_exactly_to: false,
        resize_gte_to: false,
        border: 2,
        size: 150
      )
      IO.binwrite(output_path, png.to_s)
    end
  
    def vcard
      <<~EOF
      BEGIN:VCARD
      VERSION:3.0
      N:#{@name}
      ORG:#{@org}
      TITLE:#{@title}
      TEL:#{@tel}
      URL:#{@url}
      EMAIL:#{@email}
      ADR:#{@address}
      END:VCARD
      EOF
    end

    def self.generate(vard_hash, output_path)
      RLayout::QrGenerator.new(vard_hash).generate(output_path)
    end

  end

end