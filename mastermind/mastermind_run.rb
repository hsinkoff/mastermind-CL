require "./mastermind_engine.rb"

class MastermindRun
  attr_accessor :correct_color, :correct_place, :guess

  def initialize
    correct_color = []
    correct_place = []
    @correct_color = correct_color 
    @correct_place = correct_place
    @guess = []
    @guess = [["red","red","red","red"]]
  end

  def welcome_message
    puts "Welcome to Mastermind!\nPlease think of a four color code using the following colors:
      \nred\ngreen\norange\nyellow\nblue\npurple
      \nYou may use colors more than once.\nPress enter once you are ready to begin.\n"
    $stdin.gets.chomp
  end

  def round
    return if game_ends
    current_guess
    number_in_correct_place
    return if game_ends    
    number_of_correct_color
  end

  def game_over
    if game_ends
      puts "Good Game, but I won."
    else
      puts "Good Game.  You won and beat me, the computer."
    end
  end

  def play_another_game
    puts "Would you like to play again (y or n)?"
    answer = $stdin.gets.chomp
    if answer == "y" || answer == "Y"
      game = Game.new
      game.play
    else
      return
    end
  end

  private

  def game_ends
    correct_place[correct_place.length - 1] == "4"
  end

  def current_guess
    puts "My guess is: #{guess[-1][-4]}, #{guess[-1][-3]}, #{guess[-1][-2]}, #{guess[-1][-1]}"
  end

  def number_in_correct_place
    puts "How many are in the correct place?"
    correct_place << $stdin.gets.chomp.to_s
  end

  def number_of_correct_color
    puts "How many additional colors are correct?"
    correct_color << $stdin.gets.chomp.to_s
  end
end