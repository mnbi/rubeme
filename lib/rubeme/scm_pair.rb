# frozen_string_literal: true

module Rubeme
  class ScmPair < ScmObject
    private_class_method :new

    class << self
      def cons(scm_car = SCM_EMPTY_LIST, scm_cdr = SCM_EMPTY_LIST)
        new(scm_car, scm_cdr)
      end
    end

    def initialize(scm_car, scm_cdr) # :nodoc:
      @scm_car = scm_car
      @scm_cdr = scm_cdr
    end

    def scm_pair?
      SCM_TRUE
    end

    def scm_car
      @scm_car
    end

    def scm_cdr
      @scm_cdr
    end

    # Replace the CAR part with the given instance of ScmObject.  Then
    # returns SCM_UNDEF.
    def scm_set_car!(scm_obj)
      @scm_car = scm_obj
      SCM_UNDEF
    end

    # Replace the CDR part with the given instance of ScmObject.  Then
    # returns SCM_UNDEF.
    def scm_set_cdr!(scm_obj)
      @scm_cdr = scm_obj
      SCM_UNDEF
    end

    # Returns SCM_TRUE if the given Scheme object is a Scheme list.
    # Otherwise, returns SCM_FALSE.
    #
    # A list structure constructs with ScmPair objects like;
    #
    #   (1 . 2)  ... dot pair, NOT a list.
    #   (1 . ()) ... a list which length is 1.
    #   (1 . (2 . (3 . ()))) ... a list which length is 3.
    def scm_list?
      return SCM_TRUE if Rubeme.null?(@scm_cdr)

      tail = @scm_cdr
      while tail.is_a?(ScmPair)
        tail = tail.scm_cdr
      end

      Rubeme.null?(tail) ? SCM_TRUE : SCM_FALSE
    end

    # Constructs an Array which consists the CAR part (the 1st
    # element) and the CDR (the 2nd element) part of the pair.
    #
    # The function is intended to be used in a multiple assignment
    # expression of Ruby.  It will look like:
    #
    #   head, tail = scm_pair.scm_decompose
    def scm_decompose
      [@scm_car, @scm_cdr]
    end

    # :stopdoc:
    def scm_value
      self
    end

    def value
      [@scm_car.value, @scm_cdr.value]
    end

    def to_s
      "(#{scm_car} . #{scm_cdr})"
    end
    # :startdoc:
  end

  class << self

    # Converts a Pair object to a ScmPair object.
    def rb2scm_pair(pair)
      raise ArgumentError, ("not Pair object: %s" % pair.class.to_s) unless pair.is_a?(Pair)
      car, cdr = pair.to_a
      ScmPair.cons(rb2scm(car), rb2scm(cdr))
    end

    # Converts an Array object to a Scheme list structure.
    def rb2scm_list(array)
      if array.nil?
        SCM_EMPTY_LIST
      else
        m = Rubeme.method(:rb2scm)
        scm_make_list(*array.map(&m))
      end
    end

  end

end
