require File.dirname(__FILE__) + '/char-field.rb'

class BitStruct
  # 
  class HexOctetField < BitStruct::OctetField
    # Used in describe.
    def self.class_name
      @class_name ||= "hex_octets"
    end
    
    SEPARATOR = ":"
    FORMAT    = "%02x"
    BASE      = 16
  end
end
