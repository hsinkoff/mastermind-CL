class MastermindEngine
  attr_reader :correct_color, :correct_place
  attr_accessor :guess

  def initialize(correct_color, correct_place, guess)
    @correct_color = correct_color
    @correct_place = correct_place
    @color_array = []
    @colors = ["red", "green", "orange", "yellow", "blue", "purple"]
    @partial_guess = []
    @guess = guess
    @final_guess = [nil, nil, nil, nil]
  end
	
  def color_check
     @total = @correct_place[@correct_place.length - 1].to_i + @correct_color[@correct_color.length - 1].to_i
    if @color_array.length.to_i + @final_guess.compact.length.to_i == 4
      return
    elsif @color_array.empty? && @count == 1
      (@total - 1).times do |add|
        @color_array << @colors[@correct_place.length - 1] 
      end
    elsif @color_array.empty? && @count == 0
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
    @count = 0
    if @correct_place.length >= 2 && @color_array.length >= 1
      if @correct_color[@correct_color.length - 1] == "0"
        if @correct_place[@correct_place.length - 1] >= "1"
          @final_guess[(@guess[-1].index((@color_array[0])).to_i)] = @color_array.shift
          @count = @count + 1
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
        else
          @partial_guess[index] = @colors[@correct_place.length]
        end
      end
    end
    @guess << @partial_guess
    @partial_guess = []
  end

  def final_round
    if @final_guess.compact.length == 4
      @guess << @final_guess
    elsif @final_guess.compact.length == 2 && @correct_color[@correct_color.length - 1].to_i == 1
      @partial_guess << @final_guess[0] << @final_guess[1] << @final_guess[2] << @final_guess[3]
      @partial_guess.each_index do |index|
        if @partial_guess[index] == nil
          @x = @color_array.shift
          @partial_guess[index] = @x
          @color_array.push(@x)
        end
      end
      @color_array.rotate!
      @guess << @partial_guess
    end
  end

  def complete_round
    self.correct_places
    self.color_check
    self.fill_in_known
    self.reorder
    self.color_fill
    self.final_round
  end
end

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

	def welcome
    puts "Welcome to Mastermind!\nPlease think of a four color code using the following colors:
      \nred\ngreen\norange\nyellow\nblue\npurple
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
      game.play
    else
      return
    end
  end

end

class Game
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
