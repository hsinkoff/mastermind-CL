require "./mastermind_engine.rb"
require "./mastermind_run.rb"

class Game
  # sets up and runs one complete game
  def play
    run = MastermindRun.new
    engine = MastermindEngine.new(run.correct_color, run.correct_place, run.guess)
    run.welcome
    10.times do
      run.round
      engine.complete_round
    end
    run.game_over
  end
end

game = Game.new
game.play