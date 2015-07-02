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

	# introduces game to user
  def welcome
    puts "Welcome to Mastermind!\nPlease think of a four color code using the following colors:
      \nred\ngreen\norange\nyellow\nblue\npurple
      \nYou may use colors more than once.\nPress enter once you are ready to begin.\n"
    $stdin.gets.chomp
  end

  # outputs guess and inputs information from user
  def round
    if correct_place[correct_place.length - 1] == "4"
      return
    end
    puts "My guess is: #{guess[-1][-4]}, #{guess[-1][-3]}, #{guess[-1][-2]}, #{guess[-1][-1]}"
    puts "How many are in the correct place?"
    correct_place << $stdin.gets.chomp.to_s
    if correct_place[correct_place.length - 1] == "4"
      return
    else
      puts "How many additional colors are correct?"
      correct_color << $stdin.gets.chomp.to_s
    end
  end

  # ends game and allows user to play again
  def game_over
    if correct_place[correct_place.length - 1] == "4"
      puts "Good Game, but I won."
    else
      puts "Good Game.  You won and beat me, the computer."
    end
    puts "Would you like to play again (y or n)?"
    answer = $stdin.gets.chomp
    if answer == "y" || answer == "Y"
      game = Game.new
      game.play
    else
      return
    end
  end

end