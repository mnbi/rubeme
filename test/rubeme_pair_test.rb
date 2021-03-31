# frozen_string_literal: true

require "test_helper"

class RubemePairTest < Minitest::Test
  include Rubeme

  def test_it_can_construct_a_pair_object
    pair = Pair.new(1, 2)
    refute_nil pair
  end

  def test_it_can_retrieve_car_part
    pair = Pair.new(1, 2)
    assert_equal 1, pair.car
  end

  def test_it_can_retrieve_cdr_part
    pair = Pair.new(1, 2)
    assert_equal 2, pair.cdr
  end

  def test_it_can_convert_to_string_with_dot_notation
    pair = Pair.new(1, 2)
    str = pair.to_s
    assert_equal "(1 . 2)", str
  end

  def test_it_can_convert_to_string_when_cdr_part_is_nil
    pair = Pair.new(1, nil)
    str = pair.to_s
    assert_equal "(1)", str
  end

  def test_it_can_convert_to_string_when_nested
    pair = Pair.new(1, Pair.new(2, Pair.new(3, 4)))
    str = pair.to_s
    assert_equal "(1 . (2 . (3 . 4)))", str
  end

  def test_it_can_replace_car_part
    pair = Pair.new(1, 2)
    assert_equal 1, pair.car
    pair.set_car!(3)
    assert_equal 3, pair.car
  end

  def test_it_can_replace_cdr_part
    pair = Pair.new(1, 2)
    assert_equal 2, pair.cdr
    pair.set_cdr!(4)
    assert_equal 4, pair.cdr
  end

  def test_it_can_convert_to_array
    pair = Pair.new(1, 2)
    array = pair.to_a
    assert_equal [1, 2], array
  end

  def test_it_can_convert_to_array_if_nested
    pair = Pair.new(1, Pair.new(2, 3))
    array = pair.to_a
    assert_equal [1, [2, 3]], array
  end

  def test_it_can_convert_to_array_if_nested_deeper
    pair = Pair.new(4, Pair.new(3, Pair.new(2, 1)))
    array = pair.to_a
    assert_equal [4, [3, [2, 1]]], array
  end

end
