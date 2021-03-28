# frozen_string_literal: true

module Rubeme
  # Constructs a structure like 'cons cell' in Scheme.  Use Pair.cons
  # to instantiate a Pair object instead of Pair.new.
  #
  # :call-seq:
  #     cons(car_obj, cdr_obj) -> Pair
  class Pair
    private_class_method :new

    class << self
      def cons(car, cdr)
        new(car, cdr)
      end
    end

    attr_reader :car, :cdr

    def initialize(car, cdr)    # :nodoc:
      @car = car
      @cdr = cdr
    end

    # Replace the car part with a given object.  It returns the given
    # object.
    def set_car!(obj)
      @car = obj
    end

    # Replace the cdr part with a given object.  It returns the given
    # object.
    def set_cdr!(obj)
      @cdr = obj
    end

    # Convers to an Array which members are the car part and the cdr
    # part.
    def to_a
      [@car, @cdr].map { |e| Pair === e ? e.to_a : e}
    end

    # Converts to a String represents a notation as a pair in Scheme.
    def to_s
      if @cdr.nil?
        "(#{@car})"
      else
        "(#{@car} . #{@cdr})"
      end
    end

  end
end
