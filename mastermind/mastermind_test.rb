require 'minitest/autorun'
require_relative './mastermind_engine'

class TestMastermind < Minitest::Test
  
  def test_check
    assert_equal 1, 1
  end

  def test_initialize
    game = MastermindEngine.new([0], [0], [["red", "red", "red", "red"]])
    assert_equal [0], game.correct_color
    assert_equal [0], game.correct_place
    assert_equal [["red", "red", "red", "red"]], game.guess
  end

  def test_complete_round
    game = MastermindEngine.new([0], [0], [["red", "red", "red", "red"]])
    game.complete_round
    assert_equal [], game.instance_variable_get(:@color_array)
    assert_equal ["green", "green", "green", "green"], game.guess[-1]
   
    game1 = MastermindEngine.new([1], [0], [["red", "red", "red", "red"]])
    game1.complete_round
    assert_equal ["red"], game1.instance_variable_get(:@color_array)
    assert_equal ["red", "green", "green", "green"], game1.guess[-1]

    game2 = MastermindEngine.new([2], [0], [["red", "red", "red", "red"]])
    game2.complete_round
    assert_equal ["red", "green", "green", "green"], game2.guess[-1]
    assert_equal ["red", "red"], game2.instance_variable_get(:@color_array)

    game3 = MastermindEngine.new([3], [0], [["red", "red", "red", "red"]])
    game3.complete_round
    assert_equal ["red", "green", "green", "green"], game3.guess[-1]
    assert_equal ["red", "red", "red"], game3.instance_variable_get(:@color_array)
    
    game4 = MastermindEngine.new([4], [0], [["red", "red", "red", "red"]])
    game4.complete_round
    assert_equal ["red", "purple", "purple", "purple"], game4.guess[-1]
    assert_equal ["red", "red", "red", "red"], game4.instance_variable_get(:@color_array)

  end
end