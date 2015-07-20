require "./mastermind_engine.rb"
require "./mastermind_run.rb"

class Game
  def initialize
    @run = MastermindRun.new
    @round = MastermindRound.new(:correct_color => @run.correct_color, 
                                 :correct_place => @run.correct_place, 
                                 :guess => @run.guess)
  end
  
  def play
    @run.welcome_message
    10.times do
      @run.round
      @round.complete_round
    end
    @run.game_over
    @run.play_another_game
  end
end

game = Game.new
game.play