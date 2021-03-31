# coding: utf-8
# frozen_string_literal: true
require "test_helper"

class RubemeCharTest < Minitest::Test
  include Rubeme

  def setup
    @ch_a = "a"
    @ch_b = "b"
    @ch_a_ja = "あ"             # UTF-8
    @ch_i_ja = "い"             # UTF-8
  end

  def test_it_can_generate_from_string_with_a_character
    char = Char.new(@ch_a)
    refute_nil char

    char_ja = Char.new(@ch_a_ja)
    refute_nil char
  end

  def test_it_can_convert_to_string
    char = Char.new(@ch_a)
    assert_equal @ch_a, char.to_s

    char_ja = Char.new(@ch_a_ja)
    assert_equal @ch_a_ja, char_ja.to_s
  end

  def test_it_can_compare_to_other_char
    char_a = Char.new(@ch_a)
    char_a_other = Char.new(@ch_a)
    char_b = Char.new(@ch_b)

    refute_same char_a, char_a_other
    assert char_a == char_a_other
    assert char_a != char_b

    char_a_ja = Char.new(@ch_a_ja)
    char_a_ja_other = Char.new(@ch_a_ja)
    char_i_ja = Char.new(@ch_i_ja)

    refute_same char_a_ja, char_a_ja_other
    assert char_a_ja == char_a_ja_other
    assert char_a_ja != char_i_ja
  end

  def test_it_can_be_used_as_key_of_a_hash
    keys = [Char.new(@ch_a), Char.new(@ch_b),
            Char.new(@ch_a_ja), Char.new(@ch_i_ja),]
    values = [:foo, :bar, :hoge, :gebo]

    h = {}

    keys.each_with_index { |k, i| h[k] = values[i] }

    assert_equal keys.size, h.keys.size
    keys.each_with_index { |k, i|
      assert_equal values[i], h[k]
    }
  end

  def test_two_chars_made_from_a_character_can_be_used_as_the_same_key
    char_a = Char.new(@ch_a)
    char_a_other = Char.new(@ch_a)

    h = {}

    h[char_a] = :apple
    h[char_a_other] = :orange

    assert_equal 1, h.size
    assert_equal :orange, h[char_a]
  end

  def test_it_can_be_converted_to_string
    char_a = Char.new(@ch_a)
    char_a_ja = Char.new(@ch_a_ja)

    assert_equal @ch_a, char_a.to_s
    assert_equal @ch_a_ja, char_a_ja.to_s
  end

end
