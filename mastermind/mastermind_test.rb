require 'minitest/autorun'
require_relative 'mastermind_engine'

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

  def test_correctplaces
    game = MastermindEngine.new([0], [0], [["red", "red", "red", "red"]])
    game.correct_places
    assert_equal [["red", "red", "red", "red"]], game.guess
  end
end