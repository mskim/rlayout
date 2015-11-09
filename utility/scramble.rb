require 'base64' 
month = {
  "msk": 1,       #min soo
  "jyk": 1,       #jeeyoung
  "eewol": 2,
  "skk": 3,       #sungkun
  "sa": 4,
  "uhrineenal": 5,     #childrens day
  "onouwol": 5,
  "guenal": 6,    #6.25
  "yukeeoh": 6,    #6.25
  "sbokk": 6,
  "csnal": 7,     #chilsuknal
  "ymk": 8,       #youngmi
  "goowol": 9,    #youngmi
  "jyoonk": 10,   #jeeyoon
  "jookshim": 10, #janmonim
  "sant": 12,     #santa
  }
month_a = [["msk", "jyk"], ["eewol", "dool"], ["skk","sam"], ]
# def scramble(date, mac_address)
#   
#   key = "yck3456#{date}azcZX#{mac_address}C3567"
# 
# end
# 
# def descramble(string)
# 
#   date = string.match(/yck3456)/)
# end

def scramble_data(data)
  
end

def unscramble_data(string)
  
end


string = "2015-10-12/@"
string = "msk"
puts encoded = [string].pack("m") 
puts decoded = encoded.unpack("m").first 
puts decoded
# puts decoded = Base64::decode(encoded)
puts month[decoded.to_sym]
