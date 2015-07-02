require "./mastermind_run.rb"

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
	
  def all_colors_known?
    @color_array.length.to_i + @final_guess.compact.length.to_i == 4
  end
  
  def add_colors_to_color_array
    @total.times do |add|
      @color_array << @colors[correct_place.length - 1]
    end
  end

  def color_check
    return if self.all_colors_known?
    @total = correct_place[-1].to_i + correct_color[-1].to_i
    if guess[-1].uniq.length != 1
      @total = @total - 1
    end
    self.add_colors_to_color_array
  end

  # checks if any pieces are in their correct place
  # adds them to the final_guess
  def correct_places
    if correct_place.length >= 2 && @color_array.length >= 1
      if correct_color[-1] == "0"
        if correct_place[-1] >= "1"
          @final_guess[(guess[-1].index(@color_array[0]).to_i)] = @color_array.shift
        end
      end
    end
  end

  # creates partial_guess (the next guess)
  # adds in one known color whose position is unknown
  def fill_in_known
    if @partial_guess.length < 4
      (4 - @partial_guess.length).times do |add|
        @partial_guess << nil
      end
    end
    if !@color_array.empty?
      if guess[-1].include?(@color_array[0]) && @final_guess[(guess[-1].index(@color_array[0]))] == nil
        @partial_guess[(guess[-1].index(@color_array[0]))] = @color_array[0]
      elsif guess[-1].include?(@color_array[0]) && @final_guess[(guess[-1].index(@color_array[0]))] != nil
        if (guess[-1].index(@color_array[0]) + 1) < 4
          @partial_guess[(guess[-1].index(@color_array[0]) + 1)] = @color_array[0]
        else 
          @partial_guess[(guess[-1].index(@color_array[0]) - 1)] = @color_array[0]
        end
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

  # moves known color to next position if necessary
  # if known color is in last available position, adds to final_guess
  def reorder
    if correct_color.length >= 2
      if correct_color[-1] != "0"
        if ((@partial_guess.index(@color_array[0]).to_i + 1) < (3 - @final_guess.compact.length.to_i)) && @final_guess[(@partial_guess.index(@color_array[0]).to_i + 1)] == nil
          @partial_guess[(@partial_guess.index(@color_array[0]).to_i + 1)] = @color_array[0]
          @partial_guess[@partial_guess.index(@color_array[0]).to_i] = nil 
        elsif ((@partial_guess.index(@color_array[0]).to_i + 1) == (3 - @final_guess.compact.length.to_i)) && @final_guess.uniq.length <= 2
          @final_guess[(@partial_guess.index(@color_array[0]).to_i + 1)] = @color_array.shift
          @partial_guess = [@color_array[0], nil, nil, nil]
        end
      end
    end 
  end

  # fills in partial_guess with final_guess
  # fills in blanks with next color
  def final_round
    if @final_guess.compact.length == 4
      guess << @final_guess
      return
    elsif @final_guess.compact.length >= 2 && (correct_color[-1].to_i == 2 || @color_array.length == 2)
      @partial_guess << @final_guess[0] << @final_guess[1] << @final_guess[2] << @final_guess[3]
      @partial_guess.each_index do |index|
        if @partial_guess[index] == nil
          @partial_guess[index] = @color_array.shift
          @color_array << (@partial_guess[index])
        end
      end
    end
     @partial_guess.each_index do |index|
      if @partial_guess[index] == nil
        if @color_array.length.to_i + @final_guess.compact.length.to_i == 4
          @partial_guess[index] = ((@colors - @color_array) - @final_guess)[-1]
        else
          @partial_guess[index] = @colors[correct_place.length]
        end
      end
    end
    guess << @partial_guess
    @partial_guess = []
  end

  # runs through methods once
  def complete_round
    self.correct_places
    self.color_check
    self.fill_in_known
    self.reorder
    self.final_round
  end
end