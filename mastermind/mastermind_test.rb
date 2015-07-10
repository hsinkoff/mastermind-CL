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

  def test_find_final_location_of_colors
    @final = MastermindFinalPlace.new([nil, nil, nil, nil],["red"],["0", "0"],[["red", "red", "red", "red"], ["red", "green", "green", "green"]])
    @final.known_color_into_final_location
    assert_equal ["red", nil, nil, nil], @final.final_guess
    assert_equal [], @final.color_array

    @final.color_array = ["green"]
    @final.correct_color << "0"
    @final.guess[-1] = ["red", "orange", "green", "orange"]
    @final.known_color_into_final_location
    assert_equal ["red", nil, "green", nil], @final.final_guess
    assert_equal [], @final.color_array

    @final.correct_color << "1"
    @final.color_array = ["orange"]
    @final.guess[-1] = ["red", "blue", "green", "orange"]
    assert_equal ["red", nil, "green", nil], @final.final_guess
    assert_equal ["orange"], @final.color_array

    @final1 = MastermindFinalPlace.new([nil, nil, nil, nil], ["red"], ["0"], [["red", "red", "red", "red"]])
    @final1.known_color_into_final_location
    assert_equal [nil, nil, nil, nil], @final1.final_guess
  end

  def test_color_placement
    @placement = MastermindColorPlacement.new([nil, nil, nil, nil], ["red"], [["red", "red", "red", "red"]], ["0"])
    @placement.place_color
    assert_equal ["red", nil, nil, nil], @placement.partial_guess

    @placement.final_guess = ["orange", nil, nil, nil]
    @placement.place_color
    assert_equal ["orange", "red", nil, nil], @placement.partial_guess

    @placement.color_array = ["blue"]
    @placement.place_color
    assert_equal ["orange", "blue", nil, nil], @placement.partial_guess

    @placement.guess[-1] = ["purple", "blue", "purple", "purple"]
    @placement.correct_color << "1"
    @placement.place_color
    assert_equal ["orange", nil, "blue", nil], @placement.partial_guess

    @placement.guess[-1] = ["purple", "purple", "blue", "purple"]
    @placement.correct_color << "1"
    @placement.place_color
    assert_equal ["orange", nil, nil, "blue"], @placement.partial_guess
  end

  def test_guess_for_this_turn

  end
end