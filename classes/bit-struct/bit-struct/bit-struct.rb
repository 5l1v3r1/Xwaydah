
#
class BitStruct < String
  VERSION = "0.13.6"

  class Field
    # Offset of field in bits.
    attr_reader :offset
    
    # Length of field in bits.
    attr_reader :length
    alias size length
    
    # Name of field (used for its accessors).
    attr_reader :name
    
    # Options, such as :default (varies for each field subclass).
    # In general, options can be provided as strings or as symbols.
    attr_reader :options
    
    # Display name of field (used for printing).
    attr_reader :display_name
    
    # Default value.
    attr_reader :default
    
    # Format for printed value of field.
    attr_reader :format
    

    def self.default; nil; end

    # Used in describe.
    def self.class_name
      @class_name ||= name[/\w+$/]
    end
    
    # Used in describe. Can be overridden per-subclass, as in NestedField.
    def class_name
      self.class.class_name
    end

    # Yield the description of this field, as an array of 5 strings: byte
    # offset, type, name, size, and description. The opts hash may have:
    #
    # :expand ::  if the value is true, expand complex fields
    #
    # (Subclass implementations may yield more than once for complex fields.)
    #
    def describe opts
      bits = size
      if bits > 32 and bits % 8 == 0
        len_str = "%dB" % (bits/8)
      else
        len_str = "%db" % bits
      end
      
      byte_offset = offset / 8 + (opts[:byte_offset] || 0)

      yield ["@%d" % byte_offset, class_name, name, len_str, display_name]
    end

    # Options are _display_name_, _default_, and _format_ (subclasses of Field
    # may add other options).
    def initialize(offset, length, name, opts = {})
      @offset, @length, @name, @options =
        offset, length, name, opts
      
      @display_name = opts[:display_name] || opts["display_name"]
      @default      = opts[:default] || opts["default"] || self.class.default
      @format       = opts[:format] || opts["format"]
    end
    
    # Inspect the value of this field in the specified _obj_.
    def inspect_in_object(obj, opts)
      val = obj.send(name)
      str =
        begin
          val.inspect(opts)
        rescue ArgumentError # assume: "wrong number of arguments (1 for 0)"
          val.inspect
        end
      (f=@format) ? (f % str) : str
    end
    
    # Normally, all fields show up in inspect, but some, such as padding,
    # should not.
    def inspectable?; true; end
  end
  
  NULL_FIELD = Field.new(0, 0, :null, :display_name => "null field")
  
  # Raised when a field is added after an instance has been created. Fields
  # cannot be added after this point.
  class ClosedClassError < StandardError; end

  # Raised if the chosen field name is not allowed, either because another
  # field by that name exists, or because a method by that name exists.
  class FieldNameError < StandardError; end
  
  @default_options = {}
  
  @initial_value = nil
  @closed = nil
  @rest_field = nil
  @note = nil

  class << self
    def inherited cl
      cl.instance_eval do
        @initial_value = nil
        @closed = nil
        @rest_field = nil
        @note = nil
      end
    end
    

    def fields
      @fields ||= self == BitStruct ? [] : superclass.fields.dup
    end
    
    # Return the list of fields defined by this class, not inherited
    # from the superclass.
    def own_fields
      @own_fields ||= []
    end

    # Add a field to the BitStruct (usually, this is only used internally).
    def add_field(name, length, opts = {})
      round_byte_length ## just to make sure this has been calculated
      ## before adding anything
      
      name = name.to_sym
      
      if @closed
        raise ClosedClassError, "Cannot add field #{name}: " +
          "The definition of the #{self.inspect} BitStruct class is closed."
      end

      if fields.find {|f|f.name == name}
        raise FieldNameError, "Field #{name} is already defined as a field."
      end

      if instance_methods(true).find {|m| m == name}
        if opts[:allow_method_conflict] || opts["allow_method_conflict"]
          warn "Field #{name} is already defined as a method."
        else
          #raise FieldNameError,"Field #{name} is already defined as a method."
        end
      end
      
      field_class = opts[:field_class]
      
      prev = fields[-1] || NULL_FIELD
      offset = prev.offset + prev.length
      field = field_class.new(offset, length, name, opts)
      field.add_accessors_to(self)
      fields << field
      own_fields << field
      @bit_length += field.length
      @round_byte_length = (bit_length/8.0).ceil

      if @initial_value
        diff = @round_byte_length - @initial_value.length
        if diff > 0
          @initial_value << "\0" * diff
        end
      end

      field
    end

    def parse_options(ary, default_name, default_field_class) # :nodoc:
      opts = ary.grep(Hash).first || {}
      opts = default_options.merge(opts)
      
      opts[:display_name]  = ary.grep(String).first || default_name
      opts[:field_class]   = ary.grep(Class).first || default_field_class
      
      opts
    end
    
#
    def default_options h = nil
      @default_options ||= superclass.default_options.dup
      if h
        @default_options.merge! h
      end
      @default_options
    end
    
#
    def bit_length
      @bit_length ||= fields.inject(0) {|a, f| a + f.length}
    end
    
#
    def round_byte_length
      @round_byte_length ||= (bit_length/8.0).ceil
    end
    
    def closed! # :nodoc:
      @closed = true
    end

    def field_by_name name
      @field_by_name ||= {}
      field = @field_by_name[name]
      unless field
        field = fields.find {|f| f.name == name}
        @field_by_name[name] = field if field
      end
      field
    end
  end
  
  # Return the list of fields for this class.
  def fields
    self.class.fields
  end
  
  # Return the rest field for this class.
  def rest_field
    self.class.rest_field
  end
  
  # Return the field with the given name.
  def field_by_name name
    self.class.field_by_name name
  end

#

  class << self
#
    DESCRIBE_FORMAT = "%8s: %-12s %-14s[%4s] %s"
    
    # Can be overridden to use a different format.
    def describe_format
      DESCRIBE_FORMAT
    end

#
    def describe(fmt = nil, opts = {})
      if fmt.kind_of? Hash
        opts = fmt; fmt = nil
      end
      
      if block_given?
        fields.each do |field|
          field.describe(opts) do |desc|
            yield desc
          end
        end
        nil
        
      else
        fmt ||= describe_format

        result = []

        unless opts[:omit_header]
          result << fmt % ["byte", "type", "name", "size", "description"]
          result << "-"*70
        end

        fields.each do |field|
          field.describe(opts) do |desc|
            result << fmt % desc
          end
        end

        unless opts[:omit_footer]
          result << @note if @note
        end

        result
      end
    end
    
    # Subclasses can use this to append a string (or several) to the #describe
    # output. Notes are not cumulative with inheritance. When used with no
    # arguments simply returns the note string
    def note(*str)
      @note = str unless str.empty?
      @note
    end
  end
  
#
  def initialize(value = nil)   # :yields: instance
    self << self.class.initial_value

    case value
    when Hash
      value.each do |k, v|
        send "#{k}=", v
      end
    
    when nil
      
    else
      if value.respond_to?(:read)
        value = value.read(self.class.round_byte_length)
      end

      self[0, value.length] = value
    end
    
    self.class.closed!
    yield self if block_given?
  end
  
  DEFAULT_TO_H_OPTS = {
    :convert_keys   => :to_sym,
    :include_rest   => true
  }
  
  # 
  def to_h(opts = DEFAULT_TO_H_OPTS)
    converter = opts[:convert_keys] || :to_sym

    fields_for_to_h = fields
    if opts[:include_rest] and (rest_field = self.class.rest_field)
      fields_for_to_h += [rest_field]
    end
    
    fields_for_to_h.inject({}) do |h,f|
      h[f.name.send(converter)] = send(f.name)
      h
    end
  end
  

#
  def to_a(include_rest = true)
    ary =
      fields.map do |f|
        send(f.name)
      end
    
    if include_rest and (rest_field = self.class.rest_field)
      ary << send(rest_field.name)
    end
    ary
  end
  
  ## temporary hack for 1.9
  if "a"[0].kind_of? String
    def [](*args)
      if args.size == 1 and args[0].kind_of?(Fixnum)
        super.ord
      else
        super
      end
    end

    def []=(*args)
      if args.size == 2 and (i=args[0]).kind_of?(Fixnum)
        super(i, args[1].chr)
      else
        super
      end
    end
  end
  
  class << self
   
    #
    def initial_value   # :yields: the initial value
      unless @initial_value
        iv = defined?(superclass.initial_value) ? 
          superclass.initial_value.dup : ""
        if iv.length < round_byte_length
          iv << "\0" * (round_byte_length - iv.length)
        end

        @initial_value = "" # Serves as initval while the real initval is inited
        @initial_value = new(iv)
        @closed = false # only creating the first _real_ instance closes.
        
        fields.each do |field|
          @initial_value.send("#{field.name}=", field.default) if field.default
        end
      end
      yield @initial_value if block_given?
      @initial_value
    end
    
    #
    def parse(data, *classes)
      classes.flatten.map do |c|
        c.new(data.slice!(0...c.round_byte_length))
      end
    end
    
    # Join the given structs (array or multiple args) as a string.
    # Actually, the inherited String#+ instance method is the same, as is using
    # Array#join.
    def join(*structs)
      structs.flatten.map {|struct| struct.to_s}.join("")
    end
  end

#

  DEFAULT_INSPECT_OPTS = {
    :format           => "#<%s %s>",
    :field_format     => "%s=%s",
    :separator        => ", ",
    :field_name_meth  => :name,
    :include_rest     => true,
    :brackets         => ["[", "]"],
    :include_class    => true,
    :simple_format    => "<%s>"
  }
  
  DETAILED_INSPECT_OPTS = {
    :format           => "%s:\n%s",
    :field_format     => "%30s = %s",
    :separator        => "\n",
    :field_name_meth  => :display_name,
    :include_rest     => true,
    :brackets         => [nil, "\n"],
    :include_class    => true,
    :simple_format    => "\n%s"
  }
  
  # A standard inspect method which does not add newlines.
  def inspect(opts = DEFAULT_INSPECT_OPTS)
    field_format = opts[:field_format]
    field_name_meth = opts[:field_name_meth]
    
    fields_for_inspect = fields.select {|field| field.inspectable?}
    if opts[:include_rest] and (rest_field = self.class.rest_field)
      fields_for_inspect << rest_field
    end
    
    ary = fields_for_inspect.map do |field|
      field_format %
       [field.send(field_name_meth),
        field.inspect_in_object(self, opts)]
    end
        
    body = ary.join(opts[:separator])
    
    if opts[:include_class]
      opts[:format] % [self.class, body]
    else
      opts[:simple_format] % body
    end
  end
  
  
#
  def inspect_detailed
    inspect(DETAILED_INSPECT_OPTS)
  end

  #
  def self.rest(name, *ary)
    if @rest_field
      raise ArgumentError, "Duplicate rest field: #{name.inspect}."
    end
    
    opts = parse_options(ary, name, String)
    offset = round_byte_length
    byte_range = offset..-1
    class_eval do
      field_class = opts[:field_class]
      define_method name do ||
        field_class.new(self[byte_range])
      end

      define_method "#{name}=" do |val|
        self[byte_range] = val
      end
      
      @rest_field = Field.new(offset, -1, name, {
        :display_name => opts[:display_name],
        :rest_class => field_class
      })
    end
  end
  
  # Not included with the other fields, but accessible separately.
  def self.rest_field; @rest_field; end
end
