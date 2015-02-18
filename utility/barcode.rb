
def createBarcode(label, output_path)
  return unless label

  puts "Generating Barcode ..."
  # Check if we have barcode for this 
  barcodePath= "#{RAILS_ROOT}/public/images/barcode/"
  
  `clibar -o "#{output_path}" -d "#{upcString}" -f "#{optionsTextUPCPath}"`
  
end


# 
# def createBarcode(label)
#   if label==nil
#     return false
#   end
#   unless label.validBarcode?
#     puts "we have invalid barcode"
#     label.markZigmc("'NB'")
#     return false
#   end
#   # puts "Generating Barcode ..."
#   # Check if we have barcode for this 
#   barcodePath= "#{RAILS_ROOT}/public/images/barcode/"
#   eanString=label.getEANString
#   eanPath=barcodePath+"#{eanString}"+".png"
#   
#   upcString=label.getUPCString
#   upcPath=barcodePath+"#{upcString}"+".png"
#   if File.exists?(eanPath) && File.exists?(upcPath)
#     if label.zimgc==' ' || label.zimgc=='nb'
#       label.markZigmc("'b'")
#       
#       puts 'Barcode exists for this label ==============='
#       puts eanPath
#       puts upcPath
#     end
#   else
#     # label.markZigmc('nb') for now we assume that there is a barcode
#     puts 'No Barcode for this label so create one.'
#     label.markZigmc("'nb'")
#     
#     optionsTextEANPath= "#{RAILS_ROOT}/public/images/barcode/optionsEAN.txt"
#     optionsTextUPCPath= "#{RAILS_ROOT}/public/images/barcode/optionsUPC.txt"
#     eanString=label.getEANString
#     puts "EAN String: #{eanString}"
#     eanPath=barcodePath+"#{eanString}"+".png"
#     upcString=label.getUPCString
#     puts "UPC String: #{upcString}"
#     upcPath=barcodePath+"#{upcString}"+".png"
# 
#     puts 'createBarcode'
#     puts "#{eanPath}"
#     puts "#{eanString}"
#     # puts "#{optionsTextPath}"
# 
#     `clibar -o "#{eanPath}" -d "#{eanString}" -f "#{optionsTextEANPath}"`
#     `clibar -o "#{upcPath}" -d "#{upcString}" -f "#{optionsTextUPCPath}"`
#   end
# end
# 


