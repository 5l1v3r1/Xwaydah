def all_my_ipv4_interfaces
socket.ip_address_list.select{|intf| intf.ipv4?}
end

def my_loopback_ipv4
socket.ip_address_list.detect{|intf| intf.ipv4_loopback?}
end

def my_first_private_ipv4
socket.ip_address_list.detect{|intf| intf.ipv4_private?}
end

def my_first_public_ipv4
socket.ip_address_list.detect{|intf| intf.ipv4? and !intf.ipv4_loopback? and !intf.ipv4_multicast? and !intf.ipv4_private?}
end

all_my_ipv4_interfaces
=> [#<Addrinfo: 127.0.0.1>, #<Addrinfo: 10.212.142.73>, #<Addrinfo: 62.127.4.80>]
my_first_private_ipv4
=> #<Addrinfo: 10.212.142.73>
my_first_public_ipv4.ip_address
=> "62.127.4.80"