class Tordist::BaseGenerator

  class GenField
    
    def value(obj)
      raise 'not implemented'
    end
    
    def value_or_default(obj)
      v = obj.send(@opts[:prop]) if @opts.has_key? :prop
      if v != nil
        return v
      end
      if @opts.has_key? :default
        return @opts[:default]
      end
    end
  end

  class FixField
    def initialize(name, content, type, start_position, end_position, opts)
      @content = opts[:default]
    end
    def value(obj)
      @content
    end
  end
  
  class StrField < GenField
    def initialize(name, description, type, start_position, end_position, opts)
      @size = end_position - start_position + 1
      @opts = opts
    end
    def value(obj)
      value_or_default(obj).to_s.ljust(@size, ' ')
    end
  end
  
  class IntField < GenField
    def initialize(name, description, type, start_position, end_position, opts)
      @size = end_position - start_position + 1
      @name = name
      @opts = opts
    end
    def value(obj)
      #puts "parse #{@name} => #{value_or_default(obj)}" if @opts[:debug]
      value_or_default(obj).to_i.abs().to_s.rjust(@size, '0')
    end
  end
  
  class DecField < GenField
    def initialize(name, description, type, start_position, end_position, opts)
      m = type.match(/N\(([0-9]+)\)V([0-9]+)/)
      int = m[1].to_i
      dec = m[2].to_i
      tot = int + dec + 1
      @opts = opts
      @formatter = "%0#{tot}.#{dec}f".to_s
    end
    def value(obj)
       (@formatter % value_or_default(obj).abs()).gsub("." , "")
    end
  end
  
  class SigField < GenField
    def initialize(name, description, type, start_position, end_position, opts)
      m = type.match(/N\(([0-9]+)\)V([0-9]+)/)
      int = m[1].to_i
      dec = m[2].to_i
      tot = int + dec + 1
      @opts = opts
      @formatter = "%+0#{tot}.#{dec}f".to_s
    end
    def value(obj)
       (@formatter % value_or_default(obj).abs()).gsub("." , "")
    end
  end
end