require 'minitest/autorun'
require_relative './mastermind_engine'

class TestMastermind < Minitest::Test
  
  def test_check
    assert_equal 1, 1
  end
#MastermindColor class tests
  def test_no_colors_added  
    color_helper
    @color.add_colors_to_color_array
    assert_equal [], @color.color_array
  end

  def test_one_color_added 
    color_helper 
    @color.correct_color << 1
    @color.correct_place << 0
    @color.add_colors_to_color_array
    assert_equal ["green"], @color.color_array
  end

  def test_two_colors_added  
    color_helper
    @color.color_array = ["red"]
    @color.correct_color << 2
    @color.correct_place << 0
    @color.add_colors_to_color_array
    assert_equal ["red", "green", "green"], @color.color_array
  end

  def test_color_added_when_final_is_not_empty
    color_helper
    @color.final_guess = ["red"]
    @color.color_array = ["orange", "orange"]
    @color.correct_color << 3
    @color.correct_place << 0
    @color.add_colors_to_color_array
    assert_equal ["orange", "orange", "green"], @color.color_array
  end

  def test_color_added_when_place_and_color_involved
    @color1 = MastermindColor.new(:correct_color => [0], 
                                  :correct_place => [1], 
                                  :guess => [["red", "red", "red", "red"]])
    @color1.add_colors_to_color_array
    assert_equal ["red"], @color1.color_array
    @color1.correct_color << 1
    @color1.correct_place << 1
    @color1.add_colors_to_color_array
    assert_equal ["red", "green", "green"], @color1.color_array
  end
  
#MastermindFinalPlace class tests
  def test_first_color_into_final_place
    final_place_helper
    @final.final_placement
    assert_equal ["red", nil, nil, nil], @final.final_guess
    assert_equal [], @final.color_array
  end

  def test_second_color_into_final_place
    final_place_helper
    @final.final_guess = ["red", nil, nil, nil]
    @final.color_array = ["green"]
    @final.correct_color << "0"
    @final.guess[-1] = ["red", "orange", "green", "orange"]
    @final.final_placement
    assert_equal ["red", nil, "green", nil], @final.final_guess
    assert_equal [], @final.color_array
  end

  def test_color_not_added_to_final
    final_place_helper
    @final.final_guess = ["red", nil, "green", nil]
    @final.correct_color << "1"
    @final.color_array = ["orange"]
    @final.guess[-1] = ["red", "blue", "green", "orange"]
    assert_equal ["red", nil, "green", nil], @final.final_guess
    assert_equal ["orange"], @final.color_array
  end

  def test_color_not_added_in_first_round
    @final1 = MastermindFinalPlace.new(:final_guess => [nil, nil, nil, nil], 
                                       :color_array => ["red"], 
                                       :correct_color => ["0"], 
                                       :guess => [["red", "red", "red", "red"]])
    @final1.final_placement
    assert_equal [nil, nil, nil, nil], @final1.final_guess
  end

  def test_color_into_final_place_immediately
    @final1 = MastermindFinalPlace.new(:final_guess => [nil, nil, nil, nil], 
                                       :color_array => ["green", "red"], 
                                       :correct_color => ["2"], 
                                       :guess => [["green", "red", "red", "red"]])
    @final1.final_placement
    assert_equal ["red", nil, nil, nil], @final1.final_guess
  end

  def test_color_not_into_final_place_immediately
    @final1 = MastermindFinalPlace.new(:final_guess => [nil, nil, nil, nil], 
                                       :color_array => ["green", "red"], 
                                       :correct_color => ["1"], 
                                       :guess => [["green", "red", "red", "red"]])
    @final1.final_placement
    assert_equal [nil, nil, nil, nil], @final1.final_guess
  end

#MastermindColorPlacement class tests
  def test_color_into_place
    color_place_helper
    @placement.place_color
    assert_equal ["red", nil, nil, nil], @placement.partial_guess
  end

  def test_color_into_place_when_final_is_not_empty
    color_place_helper
    @placement.final_guess = ["orange", nil, nil, nil]
    @placement.place_color
    assert_equal ["orange", "red", nil, nil], @placement.partial_guess
  end

  def test_color_moves
    color_place_helper
    @placement.final_guess = ["orange", nil, nil, nil]
    @placement.color_array = ["blue"]
    @placement.guess[-1] = ["purple", "blue", "purple", "purple"]
    @placement.correct_color << "1"
    @placement.place_color
    assert_equal ["orange", nil, "blue", nil], @placement.partial_guess
    @placement.guess[-1] = ["purple", "purple", "blue", "purple"]
    @placement.place_color
    assert_equal ["orange", nil, nil, "blue"], @placement.partial_guess
  end

  def test_final_rounds_color_placement
    color_place_helper
    @placement.final_guess = ["red", nil, "blue", nil]
    @placement.color_array = ["green", "orange"]
    @placement.place_color
    assert_equal ["red", "green", "blue", "orange"], @placement.partial_guess
    @placement.place_color
    assert_equal ["red", "orange", "blue", "green"], @placement.partial_guess
  end

#MastermindGuessCompletion class tests
  def test_guess_with_all_new_entries
    guess_completion_helper
    @guess.guess_for_this_turn
    assert_equal ["orange", "orange", "orange", "orange"], @guess.partial_guess
  end

  def test_guess_with_one_repeat_entry
    guess_completion_helper
    @guess.correct_place << "1"
    @guess.partial_guess = ["red", nil, nil, nil]
    @guess.guess_for_this_turn
    assert_equal ["red", "green", "green", "green"], @guess.partial_guess
  end

  def test_guess_with_final_guess_not_empty
    guess_completion_helper
    @guess.final_guess[0] = "red"
    @guess.final_guess[2] = "green"
    assert_equal ["red", nil, "green", nil], @guess.final_guess
    @guess.partial_guess = ["red", nil, "green", nil]
    @guess.color_array = ["orange", "orange"] 
    @guess.colors << "blue"
    @guess.guess_for_this_turn
    assert_equal ["red", "blue", "green", "blue"], @guess.partial_guess
  end

  private

  def color_helper
    @color = MastermindColor.new(:correct_color => [0],
                                 :correct_place => [0],
                                 :guess => [["red", "red", "red", "red"]])
  end

  def final_place_helper
    @final = MastermindFinalPlace.new(:final_guess => [nil, nil, nil, nil],
                                      :color_array => ["red"],
                                      :correct_color => ["0", "0"],
                                      :guess => [["red", "red", "red", "red"], ["red", "green", "green", "green"]])
  end

  def color_place_helper
    @placement = MastermindColorPlacement.new(:final_guess => [nil, nil, nil, nil], 
                                              :color_array => ["red"], 
                                              :guess => [["red", "red", "red", "red"]], 
                                              :correct_color => ["0"])
  end

  def guess_completion_helper
    @guess = MastermindGuessCompletion.new(:correct_place => [0], 
                                           :final_guess => [nil, nil, nil, nil], 
                                           :color_array => ["red"], 
                                           :partial_guess => [nil, nil, nil, nil], 
                                           :guess => [["red", "red", "red", "red"]], 
                                           :colors => ["red", "orange", "green"])
  end
end