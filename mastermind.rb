class Game
  def initialize
    @colors = ["red", "green", "orange", "yellow", "blue", "purple"]
    @array =[["red","red","red","red"]]
    @correct_place = []
    @correct_color = []
    @final_array = [nil, nil, nil, nil]
    @partial_array = []
    @color_array = []
    puts "Welcome to Mastermind!\nPlease think of a four color code using the following colors:
      \n#{@colors[0]}\n#{@colors[1]}\n#{@colors[2]}\n#{@colors[3]}\n#{@colors[4]}\n#{@colors[5]}\n\n"
  end

  def round
    if @correct_place[@correct_place.length - 1] == "4"
      return
    end
    puts "My guess is: #{@array[-1][-4]}, #{@array[-1][-3]}, #{@array[-1][-2]}, #{@array[-1][-1]}"
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
    if @color_array.length.to_i + @final_array.compact.length.to_i == 4
      return
    elsif @color_array.empty?
      (@total - @final_array.compact.length.to_i).times do |add|
        @color_array << @colors[@correct_place.length - 1] 
      end
    else
      (@total - @final_array.compact.length.to_i - 1).times do |add|
        @color_array << @colors[@correct_place.length - 1]
      end
    end
  end

  def correct_places
    if @correct_place.length >= 2
      #to be updated
      if @correct_color[@correct_color.length - 1] == "0" && (@correct_place[@correct_place.length - 1].to_i - @final_array.compact.length.to_i) >= 1
        @final_array[(@array[-1].index((@color_array[0])).to_i)] = @color_array.shift
      end
    end
    puts @color_array
    puts "_____"
    puts @final_array
  end

  def fill_in_known
    if !@final_array.compact.empty?
      @partial_array << @final_array[0] << @final_array[1] << @final_array[2] << @final_array[3]
    end
    if @partial_array.length < 4
      (4 - @partial_array.length).times do |add|
        @partial_array << nil
      end
    end
    if !@color_array.empty?
      if @array[-1].include?(@color_array[0])
        @partial_array[(@array[-1].index(@color_array[0]))] = @color_array[0]
      else
        if @partial_array[0] == nil
          @partial_array[0] = @color_array[0]
        elsif @partial_array[1] == nil
          @partial_array[1] = @color_array[0]
        elsif @partial_array[2] == nil
          @partial_array[2] = @color_array[0]
        elsif @partial_array[3] == nil
          @partial_array[3] = @color_array[0]
        end 
      end
    end
  end

  def reorder
    if @correct_color.length >= 2
      if @correct_color[@correct_color.length - 1] != 0
        @partial_array[(@partial_array.index(@color_array[0]).to_i + 1)] = @color_array[0]
        @partial_array[@partial_array.index(@color_array[0]).to_i] = nil  
      end
    end
  end

  def color_fill
    @partial_array.each_index do |index|
      if @partial_array[index] == nil
        if @color_array.length.to_i + @final_array.compact.length.to_i == 4
          @partial_array[index] = "grey"
        elsif @correct_place.length > 5
          @partial_array[index] = "grey"
        else
          @partial_array[index] = @colors[@correct_place.length]
        end
      end
    end
    @array << @partial_array
    @partial_array = []
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

  def complete_round(game)
    game.round
    game.color_check
    game.correct_places
    game.fill_in_known
    game.reorder
    game.color_fill
  end

  def complete_game(game)
    #round 1
    complete_round(game)
    #round 2
    complete_round(game)
    #round 3
    complete_round(game)
    #round 4
    complete_round(game)
    #round 5
    complete_round(game)
    #round 6
    complete_round(game)
    #round 7
    complete_round(game)
    #round 8
    complete_round(game)
    #round 9
    complete_round(game)
    #round 10
    complete_round(game)
    game.game_over
  end
end

game = Game.new
game.complete_game(game)