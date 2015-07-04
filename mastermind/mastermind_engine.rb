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

  def number_of_color_in_answer
    @total = correct_place[-1].to_i + correct_color[-1].to_i
    if guess[-1].uniq.length != 1
      @total = @total - 1
    end
  end

  def add_colors_to_color_array
    return if self.all_colors_known?
    self.number_of_color_in_answer
    @total.times do |add|
      @color_array << @colors[correct_place.length - 1]
    end
  end

#chain the requirements vs. if statements?
  def correct_places
    if correct_place.length >= 2 && @color_array.length >= 1
      if correct_color[-1] == "0"
        if correct_place[-1] >= "1"
          @final_guess[(guess[-1].index(@color_array[0]).to_i)] = @color_array.shift
        end
      end
    end
  end

  def set_up_partial_guess
    4.times do
      @partial_guess << nil
    end
  end

  def add_known_color
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

  def reorder_known_color
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
    elsif @final_guess.compact.length == 2 && (correct_color[-1].to_i == 2 || @color_array.length == 2)
      @partial_guess << @final_guess[0] << @final_guess[1] << @final_guess[2] << @final_guess[3]
      @partial_guess.each_index do |index|
        if @partial_guess[index] == nil
          @partial_guess[index] = @color_array.shift
          @color_array << (@partial_guess[index])
        end
      end
    elsif @final_guess.compact.length == 3 && @color_array.length == 1
      @partial_guess << @final_guess[0] << @final_guess[1] << @final_guess[2] << @final_guess[3]
      @partial_guess.each_index do |index|
        if @partial_guess[index] == nil
          @partial_guess[index] = @color_array.shift
        end
      end
    end
  end

  def complete_partial_guess_with_next_color
     @partial_guess.each_index do |index|
      if @partial_guess[index] == nil
        if @color_array.length.to_i + @final_guess.compact.length.to_i == 4
          @partial_guess[index] = ((@colors - @color_array) - @final_guess)[-1]
        else
          @partial_guess[index] = @colors[correct_place.length]
        end
      end
    end
  end

  def fill_in_partial_guess
    self.set_up_partial_guess
    self.add_known_color
    self.reorder_known_color
    self.final_round
    self.complete_partial_guess_with_next_color
  end

  def add_partial_guess_to_guess
    guess << @partial_guess
    @partial_guess = []
  end

  def complete_round
    self.correct_places
    self.add_colors_to_color_array
    self.fill_in_partial_guess
    self.add_partial_guess_to_guess
  end
end