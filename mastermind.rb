class Game
  def initialize
    @guess =[["red","red","red","red"]]
    @final_guess = [nil, nil, nil, nil]
    @correct_color = []
    @correct_place = []
    @color_array = []
    @colors = ["red", "green", "orange", "yellow", "blue", "purple"]
    @partial_guess = []
  end

  def welcome
    puts "Welcome to Mastermind!\nPlease think of a four color code using the following colors:
      \n#{@colors[0]}\n#{@colors[1]}\n#{@colors[2]}\n#{@colors[3]}\n#{@colors[4]}\n#{@colors[5]}
      \nYou may use colors more than once.\nPress enter once you are ready to begin.\n"
    $stdin.gets.chomp
  end

  def round
    if @correct_place[@correct_place.length - 1] == "4"
      return
    end
    puts "My guess is: #{@guess[-1][-4]}, #{@guess[-1][-3]}, #{@guess[-1][-2]}, #{@guess[-1][-1]}"
    puts "How many are in the correct place?"
    @correct_place << $stdin.gets.chomp.to_s
    if @correct_place[@correct_place.length - 1] == "4"
      return
    else
      puts "How many additional colors are correct?"
      @correct_color << $stdin.gets.chomp.to_s
    end
  end

  def color_check
    @total = @correct_place[@correct_place.length - 1].to_i + @correct_color[@correct_color.length - 1].to_i
    if @color_array.length.to_i + @final_guess.compact.length.to_i == 4
      return
    elsif @color_array.empty?
      @total.times do |add|
        @color_array << @colors[@correct_place.length - 1] 
      end
    elsif !@color_array.empty?
      (@total - 1).times do |add|
        @color_array << @colors[@correct_place.length - 1]
      end
    end
  end

  def correct_places
    if @correct_place.length >= 2 && @color_array.length >= 1
      if @correct_color[@correct_color.length - 1] == "0"
        if @correct_place[@correct_place.length - 1] >= "1"
          @final_guess[(@guess[-1].index((@color_array[0])).to_i)] = @color_array.shift
        end
      end
    end
  end

  def fill_in_known
    if @partial_guess.length < 4
      (4 - @partial_guess.length).times do |add|
        @partial_guess << nil
      end
    end
    if !@color_array.empty?
      if @guess[-1].include?(@color_array[0])
        @partial_guess[(@guess[-1].index(@color_array[0]))] = @color_array[0]
      else
        if @partial_guess[0] == nil
          @partial_guess[0] = @color_array[0]
        elsif @partial_guess[1] == nil
          @partial_guess[1] = @color_array[0]
        elsif @partial_guess[2] == nil
          @partial_guess[2] = @color_array[0]
        elsif @partial_guess[3] == nil
          @partial_guess[3] = @color_array[0]
        end 
      end
    end
  end

  def reorder
    if @correct_color.length >= 2
      if @correct_color[@correct_color.length - 1] != 0
        if (@partial_guess.index(@color_array[0]).to_i + 1) <= (3 - @final_guess.compact.length.to_i)
          @partial_guess[(@partial_guess.index(@color_array[0]).to_i + 1)] = @color_array[0]
          @partial_guess[@partial_guess.index(@color_array[0]).to_i] = nil 
        elsif @partial_guess[3 - @final_guess.compact.length.to_i] == @color_array[0] #(@partial_guess.index(@color_array[0]).to_i - 3) < 4
          @final_guess[3 - (3 - @final_guess.compact.length.to_i)] = @color_array.shift
          @partial_guess[3 - @final_guess.compact.length.to_i] = nil
          @partial_guess[1] = @color_array[0] 
        end
      end
    end
  end

  def color_fill
    @partial_guess.each_index do |index|
      if @partial_guess[index] == nil
        if @color_array.length.to_i + @final_guess.compact.length.to_i == 4
          @partial_guess[index] = ((@colors - @color_array) - @final_guess)[-1]
        elsif @correct_place.length > 5
          puts "Oops, you must have gotten confused.\nYour answers tell me that your code doesn't follow the rules."
          restart
          return       
        else
          @partial_guess[index] = @colors[@correct_place.length]
        end
      end
    end
    @guess << @partial_guess
    @partial_guess = []
  end

  def final_round
    if @final_guess.compact.length == 3
      @final_guess.each_index do |index|
        if @final_guess[index] == nil
          @final_guess[index] = @color_array.shift
        end
      end
      @guess << @final_guess
    elsif @final_guess.compact.length == 2
      @partial_guess << @final_guess[0] << @final_guess[1] << @final_guess[2] << @final_guess[3]
      @partial_guess.each_index do |index|
        if @partial_guess[index] == nil
          x = @color_array.shift
          @partial_guess[index] = x
          @color_array.push(x)
        end
      end
      @color_array.rotate!
      @guess << @partial_guess
    end
  end

  def game_over
    if @correct_place[@correct_place.length - 1] == "4"
      puts "Good Game, but I won."
    else
      puts "Good Game.  You won and beat me, the computer."
    end
    puts "Would you like to play again (y or n)?"
    answer = $stdin.gets.chomp
    if answer == "y" || answer == "Y"
      game = Game.new
      self.complete_game(game)
    else
      return
    end
  end

  def restart
    game = Game.new
    self.complete_game(game)
  end

  def complete_round(game)
    game.round
    game.correct_places
    game.color_check
    game.fill_in_known
    game.reorder
    game.color_fill
    game.final_round
  end

  def complete_game(game)
    game.welcome
    10.times do 
      complete_round(game)
    end
    game.game_over
  end
end

game = Game.new
game.complete_game(game)