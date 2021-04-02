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

    def scm_set_car!(scm_obj)
      @scm_car = scm_obj
      SCM_UNDEF
    end

    def scm_set_cdr!(scm_obj)
      @scm_cdr = scm_obj
      SCM_UNDEF
    end

    # :stopdoc:
    def scm_value
      self
    end

    def value
      [@scm_car.value, @scm_cdr.value]
    end

    def to_s
      if scm_cdr.equal?(SCM_EMPTY_LIST)
        "(#{scm_car})"
      else
        "(#{scm_car} . #{scm_cdr})"
      end
    end
    # :startdoc:
  end

  class << self

    # Converts a Pair object to a ScmPair object.
    def rb2scm_pair(pair)
      raise ArgumentError, "not Pair object: %s" % pair.class.to_s unless Pair === pair
      car, cdr = pair.to_a
      ScmPair.cons(rb2scm(car), rb2scm(cdr))
    end

    def rb2scm_list(array)
      if array.nil?
        SCM_EMPTY_LIST
      else
        rb2scm_pair([array[0], rb2scm_list(array[1..-1])])
      end
    end

    def scm_list?(scm_obj)
      case scm_obj
      when SCM_EMPTY_LIST.class
        SCM_TRUE
      when ScmPair
        scm_list?(scm_obj.scm_cdr)
      else
        SCM_FALSE
      end
    end

    def scm_make_list(*scm_objects)
      return SCM_EMPTY_LIST if scm_objects.size == 0
      scm_pair = scm_objects.reverse_each.reduce(SCM_EMPTY_LIST) { |r, obj|
        ScmPair.cons(obj, r)
      }
      scm_pair
    end

  end

end
