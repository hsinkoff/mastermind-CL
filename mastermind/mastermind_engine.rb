require "./mastermind_run.rb"

class MastermindColor
  attr_reader :correct_color, :correct_place, :guess
  attr_accessor :color_array, :final_guess, :colors

  def initialize(correct_color, correct_place, guess)
    @correct_color = correct_color
    @correct_place = correct_place
    @color_array = []
    @colors = ["red", "green", "orange", "yellow", "blue", "purple"]
    @guess = guess
    @final_guess = []
    @final_guess = [nil, nil, nil, nil]
  end
  
  def determine_colors_in_answer
    known_color_into_final_location
    add_colors_to_color_array
  end

  private

  def known_color_into_final_location
    if correct_color.length >= 2
      puts guess[-1].index(@color_array[0])
      puts guess[-2].index(@color_array[0])
      if guess[-1].index(@color_array[0]) == guess[-2].index(@color_array[0]) && correct_color[-1] == "0"
        @final_guess[(guess[-1].index(@color_array[0]).to_i)] = @color_array.shift
      end
    end
  end

  def all_colors_known?
    @color_array.length.to_i + @final_guess.compact.length.to_i == 4
  end

  def number_of_color_in_answer
    @total = ((correct_place[-1].to_i + correct_color[-1].to_i) - @final_guess.compact.length.to_i)
    if (guess[-1].uniq.length.to_i - @final_guess.compact.uniq.length.to_i) != 1
      @total = @total - 1
    end
  end

  def add_colors_to_color_array
    return if all_colors_known?
    number_of_color_in_answer
    @total.times do
      @color_array << @colors[correct_place.length - 1]
    end
  end
 
end

class MastermindPlacement
  attr_accessor :final_guess, :color_array, :partial_guess, :guess, :correct_color

  def initialize(final_guess, color_array, guess, correct_color)
    @final_guess = final_guess
    @color_array = color_array
    @guess = guess
    @correct_color = correct_color
    @partial_guess = []
  end

  def place_color
    place_known_entries
    place_known_color
    move_known_color
  end

  private

  def place_known_entries
    @partial_guess = []
    @partial_guess << @final_guess[0] << @final_guess[1] << @final_guess[2] << @final_guess[3]
  end

  def place_known_color
    if !@color_array.empty?
      if guess[-1].include?(@color_array[0]) && @final_guess[(guess[-1].index(@color_array[0]))] == nil
        @partial_guess[(guess[-1].index(@color_array[0]))] = @color_array[0]
      elsif guess[-1].include?(@color_array[0]) && @final_guess[(guess[-1].index(@color_array[0]))] != nil && (guess[-1].index(@color_array[0]) + 1) < 4
        @partial_guess[(guess[-1].index(@color_array[0]) + 1)] = @color_array[0]
      else
        @partial_guess.each_index do |index|
          if @partial_guess[index] == nil
            @partial_guess[index] = @color_array[0]
            return
          end
        end
      end  
    end
  end

  def move_known_color
    if correct_color.length >= 2
      if correct_color[-1] != "0"
        if (@partial_guess.index(@color_array[0]).to_i + 1) < 4 && @final_guess[(@partial_guess.index(@color_array[0]).to_i + 1)] == nil
          @partial_guess[(@partial_guess.index(@color_array[0]).to_i + 1)] = @color_array[0]
          @partial_guess[(@partial_guess.index(@color_array[0]).to_i)] = nil 
        end
      end
    end 
  end
end

class MastermindGuess
  attr_reader :final_guess, :correct_place, :colors
  attr_accessor :color_array, :partial_guess, :guess

  def initialize(correct_place, final_guess, color_array, partial_guess, guess, colors)
    @correct_place = correct_place
    @final_guess = final_guess
    @color_array = color_array
    @partial_guess = partial_guess
    @guess = guess
    @colors = colors
  end

  def guess_for_this_turn
    complete_partial_guess_with_next_color
    add_next_guess_to_guess
  end

  private

  def complete_partial_guess_with_next_color
    @partial_guess.each_index do |index|
      if @partial_guess[index] == nil
        if @final_guess.compact.length + @color_array.length == 4
          @partial_guess[index] = (@colors - @final_guess - @color_array)[0]
        else
          @partial_guess[index] = @colors[correct_place.length]
        end
      end
    end
  end

  def add_next_guess_to_guess
    guess << @partial_guess
  end
end

class MastermindRound
  def initialize(correct_color, correct_place, guess)
    @color = MastermindColor.new(correct_color, correct_place, guess)
  end

  def complete_round
    @color.determine_colors_in_answer
    @placement = MastermindPlacement.new(@color.final_guess, @color.color_array, @color.guess, @color.correct_color)
    @placement.place_color
    @guess = MastermindGuess.new(@color.correct_place, @placement.final_guess, @placement.color_array, @placement.partial_guess, @color.guess, @color.colors)
    @guess.guess_for_this_turn
  end
end
