# I found an improved way of finding mac address.
# It should to be pretty difficult to get this, but nice imprivement.
# Following will display mac address of the machine
# name = gets 
# system("/usr/sbin/networksetup -getinfo Ethernet | grep Address")
# puts name
# I can use it to save hidden files somewhere, for quick and dirty copy protection
# system("touch /Users/Shared/CardYong/.info")
# system("touch /Users/Shared/.mac_address")
# system("/usr/sbin/networksetup -getinfo Ethernet | grep Address > /Users/Shared/.mac_address")
# system("/usr/sbin/networksetup -getinfo Ethernet | grep Address > /Users/Shared/CardYong/.info")
# key=File.open("/Users/Shared/.mac_address", "r"){|f| f.read}
# mac_address=File.open("/Users/Shared/CardYong/.info", "r"){|f| f.read}

# mac_address "#{key.split(" ")[2]}"
# if key==mac_address
#   puts "key matches the machine"
# else
#   puts "key does not match the machine"
# end


key=`/usr/sbin/networksetup -getinfo Ethernet | grep Address`
puts key
# puts key.split(" ")[2]}
