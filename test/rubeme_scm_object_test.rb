# frozen_string_literal: true

require "test_helper"

class RubemeScmObjectTest < Minitest::Test

  # empty list

  def test_it_can_generate_empty_list
    scm_obj = Rubeme::SCM_EMPTY_LIST
    assert_scm_object_class Rubeme::ScmObject, scm_obj

    # EMPTY_LIST must be a singleton
    other_scm_obj = Rubeme::SCM_EMPTY_LIST
    assert_same scm_obj, other_scm_obj
  end

  def test_it_can_convert_empty_list_to_ruby_true
    scm_obj = Rubeme::SCM_EMPTY_LIST
    assert scm_obj.to_bool
  end

  # boolean: #f

  def test_false_exists
    scm_obj = Rubeme::SCM_FALSE
    assert_scm_object_class Rubeme::ScmBoolean, scm_obj
  end

  def test_false_is_scm_boolean
    scm_obj = Rubeme::SCM_FALSE
    assert_scm_object scm_obj.scm_boolean?
  end

  def test_false_is_false
    scm_obj = Rubeme::SCM_FALSE
    refute scm_obj.to_bool
  end

  # boolean: #t

  def test_true_exists
    scm_obj = Rubeme::SCM_TRUE
    assert_scm_object_class Rubeme::ScmBoolean, scm_obj
  end

  def test_true_is_scm_boolean
    scm_obj = Rubeme::SCM_TRUE
    assert_scm_object scm_obj.scm_boolean?
  end

  def test_true_is_true
    scm_obj = Rubeme::SCM_TRUE
    assert scm_obj.to_bool
  end

  # symbol

  def test_it_can_generate_from_ruby_symbol
    scm_obj = Rubeme::ScmSymbol.register(:scm_sym_from_rb_sym)
    assert_scm_object_class Rubeme::ScmSymbol, scm_obj
  end

  def test_it_can_generate_from_ruby_string
    scm_obj = Rubeme::ScmSymbol.register("scm_sym_from_rb_string")
    assert_scm_object_class Rubeme::ScmSymbol, scm_obj
  end

  def test_two_symbols_made_from_the_same_string_are_identical
    scm_obj = Rubeme::ScmSymbol.register("scm_sym_001")
    scm_obj_other = Rubeme::ScmSymbol.register("scm_sym_001")
    assert_same scm_obj, scm_obj_other
  end

  def test_symbol_is_scm_symbol
    scm_obj = Rubeme::ScmSymbol.register("scm_sym_002")
    assert_scm_object scm_obj.scm_symbol?
  end

  # number

  def test_it_can_generate_from_ruby_integer
    scm_obj = Rubeme::ScmNumber.new(123456)
    assert_scm_object_class Rubeme::ScmNumber, scm_obj
    assert_scm_object scm_obj.scm_integer?
  end

  def test_it_can_generate_from_ruby_float
    scm_obj = Rubeme::ScmNumber.new(Math::PI)
    assert_scm_object_class Rubeme::ScmNumber, scm_obj
    assert_scm_object scm_obj.scm_real?
    refute_scm_obj scm_obj.scm_integer?
  end

  def test_it_can_generate_from_ruby_rational
    scm_obj = Rubeme::ScmNumber.new(Rational(123, 456))
    assert_scm_object_class Rubeme::ScmNumber, scm_obj
    assert_scm_object scm_obj.scm_rational?
    refute_scm_obj scm_obj.scm_integer?
  end

  def test_it_can_generate_from_ruby_complex
    real_part = Rational(-1, 2)
    imaginary_part = Rational(Math.sqrt(3), 2)
    scm_obj = Rubeme::ScmNumber.new(Complex(real_part, imaginary_part))
    assert_scm_object_class Rubeme::ScmNumber, scm_obj
    assert_scm_object scm_obj.scm_complex?
    refute_scm_obj scm_obj.scm_integer?
  end

  # char

  # string

  # vector

  # port

  # procedure

  private
  def assert_scm_object_class(klass, obj)
    refute_nil obj
    assert_kind_of klass, obj
  end

  def assert_scm_object(scm_bool)
    assert_scm_object_class Rubeme::ScmBoolean, scm_bool
    assert Rubeme::SCM_TRUE.equal?(scm_bool)
  end

  def refute_scm_obj(scm_bool)
    assert_scm_object_class Rubeme::ScmBoolean, scm_bool
    assert Rubeme::SCM_FALSE.equal?(scm_bool)
  end

end
