# frozen_string_literal: true

module Rubeme
  # Holds a String object which made with a single character.  All
  # characters are assumed to be in the UTF-8 encoding.
  #
  # The main purpose of this class is to distinguish a character to a
  # string made with a single character, when performing to convert a
  # Ruby object to a Scheme object.
  #
  # This class includes "Comparable" module.  So, instances are
  # comparable.
  class Char
    include Comparable

    attr_reader :codepoint

    def initialize(char)
      @codepoint = char.codepoints[0]
    end

    def <=>(other)              # :nodoc:
      @codepoint <=> other.codepoint
    end

    def hash                    # :nodoc:
      @codepoint.hash
    end

    def eql?(other)             # :nodoc:
      other.is_a?(Char) && self.hash == other.hash
    end

    def to_s                    # :nodoc:
      begin
        ch = @codepoint.chr
      rescue RangeError => _
        ch = @codepoint.chr("UTF-8")
      end
      ch
    end

  end
end
