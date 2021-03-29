# frozen_string_literal: true

require "singleton"

module Rubeme

  class << self
    # Evaluate Scheme object to Ruby object.
    #
    # For example,
    #   - ()             -> nil
    #   - #f             -> false
    #   - #t             -> true
    #   - 123 (number)   -> 123 (Numeric)
    #   - foo (symbol)   -> :foo (Symbol)
    #   - "bar"          -> "bar" (String)
    #     :
    #     :
    #
    def eval(scm_obj)
      scm_obj.value
    end
  end

  # ScmObject is a root date type of all Scheme data objects.
  # Following types are deraived from this class.
  #
  #   - ScmBoolean
  #   - ScmPair
  #   - ScmSymbol
  #   - ScmNumber
  #   - ScmChar
  #   - ScmString
  #   - ScmVector
  #   - ScmPort
  #   - ScmProcedure
  #
  # Those classes correspond to one of predicates of Scheme.
  class ScmObject

    # predicate methods for Scheme objects, those are defined in the
    # spec of Scheme language (r5rs).

    # Returns '#t' (Scheme boolean object) when the object is boolean
    # in Scheme.  Otherwise, returns '#f'.
    def scm_boolean?;  SCM_FALSE; end

    # Returns '#t' (Scheme boolean object) when the object is pair
    # in Scheme.  Otherwise, returns '#f'.
    def scm_pair?;     SCM_FALSE; end

    # Returns '#t' (Scheme boolean object) when the object is symbol
    # in Scheme.  Otherwise, returns '#f'.
    def scm_symbol?;   SCM_FALSE; end

    # Returns '#t' (Scheme boolean object) when the object is number
    # in Scheme.  Otherwise, returns '#f'.
    def scm_number?;   SCM_FALSE; end

    # Returns '#t' (Scheme boolean object) when the object is char
    # in Scheme.  Otherwise, returns '#f'.
    def scm_char?;     SCM_FALSE; end

    # Returns '#t' (Scheme boolean object) when the object is string
    # in Scheme.  Otherwise, returns '#f'.
    def scm_string?;   SCM_FALSE; end

    # Returns '#t' (Scheme boolean object) when the object is vector
    # in Scheme.  Otherwise, returns '#f'.
    def scm_vector?;   SCM_FALSE; end

    # Returns '#t' (Scheme boolean object) when the object is port
    # in Scheme.  Otherwise, returns '#f'.
    def scm_port?;     SCM_FALSE; end

    # Returns '#t' (Scheme boolean object) when the object is
    # procedure in Scheme.  Otherwise, returns '#f'.
    def scm_procedure?; SCM_FALSE; end

    # Returns a value as Scheme object.  The method is intended to be
    # called by the evaluator of Scheme.
    def scm_value
      SCM_EMPTY_LIST
    end

    # Returns a Ruby object which generates the Scheme object.
    def value
      nil
    end

    # Returns a String object in Ruby which is intended to be used to
    # display a Scheme object for human beings.
    def to_s
      nil
    end

    # Returns a true of false in Ruby.
    def to_bool
      true
    end

    # An empty list is a special and an unique object of Scheme
    # language.  It does not belong to any other object type of
    # Scheme.
    class ScmEmptyList < ScmObject
      include Singleton

      def scm_value; self; end  # :nodoc:
      def value;     nil;  end  # :nodoc:
      def to_s;      "()"; end  # :nodoc:

    end

  end

  # A constant which holds an empty list in Scheme.
  SCM_EMPTY_LIST = ScmObject::ScmEmptyList.instance

  # Represents a boolean object in Scheme.  Do not instantiate this
  # class.  Instead, use SCM_FALSE or SCM_TRUE those represents '#f'
  # and '#t' respectively.
  class ScmBoolean < ScmObject
    # :stopdoc:

    def scm_boolean?
      SCM_TRUE
    end

    def scm_value
      self
    end

    class ScmFalse < ScmBoolean
      include Singleton
      def value;   false; end
      def to_bool; false; end
      def to_s;    "#f";  end
    end

    class ScmTrue < ScmBoolean
      include Singleton
      def value;   true; end
      def to_bool; true; end
      def to_s;    "#t"; end
    end

    # :stopdoc:
  end

  # A constant which holds the '#f'.  It represents boolean false in
  # Scheme.  The instance is the only one object which evaluated as
  # '#f' in Scheme.
  SCM_FALSE = ScmBoolean::ScmFalse.instance

  # A constant which holds the '#t'.  It represents boolean true in
  # Scheme.
  SCM_TRUE  = ScmBoolean::ScmTrue.instance

  # Represents a symbol object in Scheme.  It is a sequence of
  # characters as same as a string.  However, a symbol is unique.
  # That is, if two symbols are the same sequence of characters, they
  # must be identical.  So, do not instantiate this class with 'new'
  # method.  Instead, use ScmSymbol::regist.
  class ScmSymbol < ScmObject
    TABLE = {}
    class << self
      def regist(s)
        sym = s.to_sym
        if TABLE.key?(sym)
          TABLE[sym]
        else
          TABLE[sym] = new(sym)
        end
      end
    end

    # :stopdoc:

    private_class_method :new

    def scm_symbol?
      SCM_TRUE
    end

    def scm_value
      self
    end

    def value
      @value
    end

    def to_s
      @value.to_s
    end

    private

    def initialize(sym)
      @value = sym
    end

    # :startdoc:
  end

  # Represents a number in Scheme.  Following data types belong to number.
  #
  #   - complex
  #   - real
  #   - rational
  #   - integer
  #
  # Note, for example, that a mathematical set of all rational number
  # includes any integer number as its member.  So a scheme object
  # must be always evaluated as #t applying rational?, real? or
  # complex? if the object is an integer.
  class ScmNumber < ScmObject
    def initialize(num)
      @value = num
    end

    def scm_number?             # :nodoc:
      SCM_TRUE
    end

    # numeric predicates

    def scm_complex?
      Rubeme.rb2scm_bool(true)
    end

    def scm_real?
      Rubeme.rb2scm_bool(@value.imag == 0)
    end

    def scm_rational?
      Rubeme.rb2scm_bool(@value.imag == 0)
    end

    def scm_integer?
      result = false

      case @value
      when Complex
        result = @value.imag.zero? && (@value.real.denominator == 1)
      when Float
        decimal = @value - @value.to_i
        result = decimal.zero?
      when Rational
        result = (@value.denominator == 1)
      when Integer
        result = true
      end

      Rubeme.rb2scm_bool(result)
    end

    # :stopdoc:

    def scm_value
      self
    end

    def value
      @value
    end

    def to_s
      @value.to_s
    end

    # :startdoc:

  end

  # Represents a Scheme character object.
  class ScmChar < ScmObject
    def initialize(char)
      @value = char[0]
    end

    def scm_char_eq?(other_scm_char)
      Rubeme.rb2scm_bool(@value == other_scm_char.value)
    end

    def scm_char_lt?(other_scm_char)
      Rubeme.rb2scm_bool(@value < other_scm_char.value)
    end

    def scm_char_gt?(other_scm_char)
      Rubeme.rb2scm_bool(@value > other_scm_char.value)
    end

    def scm_char_le?(other_scm_char)
      Rubeme.rb2scm_bool(@value <= other_scm_char.value)
    end

    def scm_char_ge?(other_scm_char)
      Rubeme.rb2scm_bool(@value >= other_scm_char.value)
    end

    def scm_char_to_integer
      Rubeme.rb2scm_numeric(@value.ord)
    end

    # :stopdoc:
    def scm_char?
      SCM_TRUE
    end

    def scm_value
      self
    end

    def value
      @value
    end

    def to_s
      "\#\\#{@value}"
    end

    # :sartdoc:

  end

  class ScmString < ScmObject
    def initialize(str)
      @value = str
    end

    def scm_string_length
      Rubeme::rb2scm_numeric(@value.length)
    end

    # :stopdoc:

    def scm_string?
      SCM_TRUE
    end

    def scm_value
      self
    end

    def value
      @value
    end

    def to_s
      @value
    end

    # :startdoc:

  end

  # Represents a Scheme vector object.  Scheme vector data is very
  # similar to Ruby Array class.
  class ScmVector < ScmObject
    def initialize(scm_num, scm_initial_value = SCM_FALSE)
      @value = Array.new(scm_num.value, scm_initial_value)
    end

    # Returns the number of elements as ScmNumeric object.
    def scm_vector_length
      Rubeme.rb2scm_numeric(@value.length)
    end

    # Returns the member indexed with an argument.  The argument must
    # be a valid index, which means 0 <= index < vector_length.
    def scm_vector_ref(scm_num)
      index = scm_num.value
      if index >= 0 &&  index < @value.length
        @value[index]
      else
        raise ArgumentError, "index out of range: %d" % index
      end
    end

    # Replace the member.  The first argument must be a valid index.
    def scm_vector_set!(scm_num, scm_obj)
      index = scm_num.value
      if index >= 0 &&  index < @value.length
        @value[scm_num.value] = scm_obj
      else
        raise ArgumentError, "index out of range: %d" % index
      end
    end

    # :stopdoc:

    def scm_vector?
      SCM_TRUE
    end

    def scm_value
      self
    end

    def value
      @value.map(&:value)
    end

    def to_s
      result = "\#("
      result += @value.map(&:to_s).join(" ")
      result += ")"
    end

    # :startdoc:

    class << self
      def scm_vector(*scm_objs)
        sv = ScmVector.new(Rubeme.rb2scm_numeric(scm_objs.length))
        scm_objs.each_with_index { |e, i|
          sv.scm_vector_set!(Rubeme.rb2scm_numeric(i), e)
        }
        sv
      end
    end

  end

  # not implemented yet
  class ScmPort < ScmObject
    def scm_port?
      SCM_TRUE
    end

    def scm_value
      self
    end
  end

  class ScmProcedure < ScmObject
    def scm_procedure?
      SCM_TRUE
    end
  end

  class << self
    # Converts a Ruby bool object to a Scheme boolean object.
    def rb2scm_bool(bool)
      bool ? SCM_TRUE : SCM_FALSE
    end

    # Converts a Ruby Numeric object to a Scheme number object.
    def rb2scm_numeric(num)
      ScmNumber.new(num)
    end

    # Generates a Scheme character object using a Ruby Integer object
    # as its codepoint.
    def rb2scm_character(integer)
      ch = nil
      begin
        ch = integer.chr
      rescue RangeError => _
        ch = integer.chr("UTF-8")
      end
      ScmChar.new(ch)
    end

  end

end
