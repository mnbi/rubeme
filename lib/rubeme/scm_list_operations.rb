# frozen_string_literal: true

module Rubeme
  module ListOperations
    # Constructs a Scheme list structure with arguments.  Each
    # arguments must be an instance of the ScmObject system.
    def scm_make_list(*scm_objects)
      scm_objects.reverse_each.reduce(SCM_EMPTY_LIST) { |r, obj|
        ScmPair.cons(obj, r)
      }
    end

    # Returns a number of elements in a list structure.  The return
    # value is a Scheme number object.
    def scm_length(scm_list)
      if list?(scm_list)
        if null?(scm_list)
          rb2scm(0)
        else
          count = 0
          tail = scm_list
          until null?(tail)
            count += 1
            head, tail = tail.scm_decompose
          end
          rb2scm(count)
        end
      else
        raise ArgumentError, "proper list required: got=%s" % scm_list
      end
    end

    def scm_print(scm_object)
      list?(scm_object) ? scm_print_list(scm_object) : scm_object.to_s
    end

    def scm_print_list(scm_list)
      raise ArgumentError, ("proper list required: got=%s" % scm_list) unless list?(scm_list)
      result = []
      map_scm(scm_list) { |e|
        str = list?(e) ? scm_print_list(e) : e.to_s
        result.push(str)
      }
      "(#{result.join(' ')})"
    end

    def scm_cdar(scm_list)
      if list?(scm_list)
        scm_list.scm_cdr.scm_car
      else
        raise ArgumentError, ("proper list required: got=%s" % scm_list)
      end
    end

    def scm_append(scm_a, scm_b)
      if null?(scm_a)
        scm_b
      else
        ScmPair.cons(scm_a.scm_car, scm_append(scm_a.scm_cdr, scm_b))
      end
    end

    def scm_reverse(scm_list)
      if null?(scm_list)
        scm_list
      elsif list?(scm_list)
        head, tail = scm_list.scm_decompose
        if null?(tail)
          scm_make_list(head)
        else
          scm_append(scm_reverse(tail), scm_make_list(head))
        end
      else
        raise ArgumentError, ("proper list required: got=%s" % scm_list)
      end
    end

    def scm_list_ref(scm_list, scm_num)
      k = eval_scm(scm_num)
      if eval_scm(scm_length(scm_list)) > k
        if k == 0
          scm_list.scm_car
        else
          scm_list_ref(scm_list.scm_cdr, rb2scm(k - 1))
        end
      else
        raise ArgumentError, ("argument out of range: got=%d" % k)
      end
    end

    # Returns true (Ruby boolean value) if the given Scheme object
    # represents an empty list.  Otherwise, returns false.
    def null?(scm_object)
      SCM_EMPTY_LIST.equal?(scm_object)
    end

    # Returns true (Ruby boolean value) if the given Scheme object
    # represents a Scheme list structure.  Otherise, returns false.
    def list?(scm_object)
      eval_scm(scm_object.scm_list?)
    end

    # Performs map function with the given block to the argument,
    # which must be a Scheme list structure.
    def map_scm(scm_list, &proc)
      return [] if null?(scm_list)
      return [] unless list?(scm_list)

      result = []
      tail = scm_list
      until null?(tail)
        head, tail = tail.scm_decompose
        result.push(yield head)
      end

      result
    end

  end
end
