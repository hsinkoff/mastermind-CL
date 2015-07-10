require 'minitest/autorun'
require_relative './mastermind_engine'

class TestMastermind < Minitest::Test
  
  def test_check
    assert_equal 1, 1
  end

  def test_determine_colors_in_answer
    @color = MastermindColor.new([0], [0], [["red", "red", "red", "red"]])
    @color.add_colors_to_color_array
    assert_equal [], @color.color_array
    
    @color.correct_color << 1
    @color.correct_place << 0
    @color.add_colors_to_color_array
    assert_equal ["green"], @color.color_array
    
    @color.correct_color << 2
    @color.correct_place << 0
    @color.add_colors_to_color_array
    assert_equal ["green", "orange", "orange"], @color.color_array
    
    @color.final_guess = ["green"]
    @color.color_array = ["orange", "orange"]
    @color.correct_color << 3
    @color.correct_place << 0
    @color.add_colors_to_color_array
    assert_equal ["orange", "orange", "yellow"], @color.color_array

    @color1 = MastermindColor.new([0], [1], [["red", "red", "red", "red"]])
    @color1.add_colors_to_color_array
    assert_equal ["red"], @color1.color_array
    @color1.correct_color << 1
    @color1.correct_place << 1
    @color1.add_colors_to_color_array
    assert_equal ["red", "green", "green"], @color1.color_array
  end

  def test_place_color


  end

  def test_guess_for_this_turn

  end
end