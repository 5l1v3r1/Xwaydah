class BitStruct
  class << self
   
    #
    def char(name, length, *rest)
      opts = parse_options(rest, name, CharField)
      add_field(name, length, opts)
    end
    alias string char
    BitStruct.autoload :CharField, File.dirname(__FILE__) + "/char-field.rb"

  
    #
    def float name, length, *rest
      opts = parse_options(rest, name, FloatField)
      add_field(name, length, opts)
    end
    BitStruct.autoload :FloatField, File.dirname(__FILE__) + "/float-field.rb"

  
    #
    def hex_octets(name, length, *rest)
      opts = parse_options(rest, name, HexOctetField)
      add_field(name, length, opts)
    end
    BitStruct.autoload :HexOctetField, File.dirname(__FILE__) + "/hex-octet-field.rb"

  
    # 
    def nest(name, *rest, &block)
      nested_class = rest.grep(Class).find {|cl| cl <= BitStruct}
      rest.delete nested_class
      opts = parse_options(rest, name, NestedField)
      nested_class = opts[:nested_class] ||= nested_class
      
      unless (block and not nested_class) or (nested_class and not block)
        raise ArgumentError,
          "nested field must have either a nested_class option or a block," +
          " but not both"
      end
      
      unless nested_class
        nested_class = Class.new(BitStruct)
        nested_class.class_eval(&block)
      end
      
      opts[:default] ||= nested_class.initial_value.dup
      opts[:nested_class] = nested_class
      field = add_field(name, nested_class.bit_length, opts)
      field
    end
    alias struct nest
    BitStruct.autoload :NestedField, File.dirname(__FILE__) + "/nested-field.rb"

   
    #
    def octets(name, length, *rest)
      opts = parse_options(rest, name, OctetField)
      add_field(name, length, opts)
    end
    BitStruct.autoload :OctetField, File.dirname(__FILE__) + "/octet-field.rb"

  
    #
    def pad(name, length, *rest)
      opts = parse_options(rest, name, PadField)
      add_field(name, length, opts)
    end
    alias padding pad
    BitStruct.autoload :PadField, File.dirname(__FILE__) + "/pad-field.rb"


    #
    def signed name, length, *rest
      opts = parse_options(rest, name, SignedField)
      add_field(name, length, opts)
    end
    BitStruct.autoload :SignedField, File.dirname(__FILE__) + "/signed-field.rb"

    #
    def text(name, length, *rest)
      opts = parse_options(rest, name, TextField)
      add_field(name, length, opts)
    end
    BitStruct.autoload :TextField, File.dirname(__FILE__) + "/text-field.rb"

 
    #
    def unsigned name, length, *rest
      opts = parse_options(rest, name, UnsignedField)
      add_field(name, length, opts)
    end
    BitStruct.autoload :UnsignedField, File.dirname(__FILE__) + "/unsigned-field.rb"

   
    # 
    def vector(name, *rest, &block)
      opts = parse_options(rest, name, nil)
      cl = opts[:field_class]
      opts[:field_class] = VectorField
      
      unless (block and not cl) or (cl and not block)
        raise ArgumentError,
          "vector must have either a class or a block, but not both"
      end
      
      case
      when cl == nil
        vector_class = Class.new(BitStruct::Vector)
        vector_class.class_eval(&block)

      when cl < BitStruct
        vector_class = Class.new(BitStruct::Vector)
        vector_class.struct_class cl

      when cl < BitStruct::Vector
        vector_class = cl
      
      else raise ArgumentError, "Bad vector class: #{cl.inspect}"
      end
      
      vector_class.default_options default_options
      
      length = opts[:length] || rest.grep(Integer).first
        ## what about :length => :lenfield
      unless length
        raise ArgumentError,
          "Must provide length as argument N or as option :length => N"
      end

      opts[:default] ||= vector_class.new(length) ## nil if variable length
      opts[:vector_class] = vector_class
      
      bit_length = vector_class.struct_class.round_byte_length * 8 * length
      
      field = add_field(name, bit_length, opts)
      field
    end
    BitStruct.autoload :VectorField, File.dirname(__FILE__) + "/vector-field.rb"
  end
  
  autoload :Vector, File.dirname(__FILE__) + "/vector.rb"
end
