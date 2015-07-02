require "./mastermind_engine.rb"
require "./mastermind_run.rb"

class Game
  def initialize
    @run = MastermindRun.new
    @engine = MastermindEngine.new(@run.correct_color, @run.correct_place, @run.guess)
  end
  
  def play
    @run.welcome
    10.times do
      @run.round
      @engine.complete_round
    end
    @run.game_over
    @run.play_another_game
  end
end

game = Game.new
game.play