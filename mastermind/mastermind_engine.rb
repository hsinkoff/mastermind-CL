require "./mastermind_run.rb"

class MastermindColor
  attr_reader :correct_color, :correct_place, :guess
  attr_accessor :color_array, :final_guess, :colors

  def initialize(args)
    @correct_color = args[:correct_color]
    @correct_place = args[:correct_place]
    @color_array = []
    @colors = ["red", "green", "orange", "yellow", "blue", "purple"]
    @guess = args[:guess]
    @final_guess = []
    @final_guess = [nil, nil, nil, nil]
  end
  
  def add_colors_to_color_array
    return if all_colors_known?
    number_of_color_in_answer
    @total.times do
      @color_array << @colors[correct_place.length - 1]
    end
  end

  private

  def all_colors_known?
    @color_array.length.to_i + @final_guess.compact.length.to_i == 4
  end

  def number_of_color_in_answer
    @total = ((correct_place[-1].to_i + correct_color[-1].to_i) - @final_guess.compact.length.to_i)
    if (guess[-1].uniq.length.to_i - @final_guess.compact.uniq.length.to_i) != 1
      @total = @total - 1
    end
  end
end

class MastermindFinalPlace
  attr_accessor :final_guess, :color_array
  attr_reader :correct_color, :guess

  def initialize(args)
    @final_guess = args[:final_guess]
    @color_array = args[:color_array]
    @correct_color = args[:correct_color]
    @guess = args[:guess]
  end

  def final_placement
    known_color_into_final_location
    final_placement_known_immediately
  end

  private

  def known_color_into_final_location
    if correct_color.length >= 2 && @color_array[0] != nil && guess[-1].count(@color_array[0]) == 1 
      if correct_color[-1] == "0"
        @final_guess[(guess[-1].index(@color_array[0]).to_i)] = @color_array.shift
      elsif (guess[-1].index(@color_array[0]) + 1) == @final_guess.rindex(nil)
        @final_guess[@final_guess.rindex(nil)] = @color_array.shift
      end
    end
  end

  def final_placement_known_immediately
    if guess[-1].count(@color_array[0]) == 1 && guess[-1].uniq.count == 2 && @correct_color[-1] >= "2"
      @final_guess[guess[-1].index(color_array[0])] = @color_array.pop
    end
  end
end

class MastermindColorPlacement
  attr_accessor :final_guess, :color_array, :partial_guess, :guess, :correct_color

  def initialize(args)
    @final_guess = args[:final_guess]
    @color_array = args[:color_array]
    @guess = args[:guess]
    @correct_color = args[:correct_color]
    @partial_guess = []
  end

  def place_color
    set_partial_guess
    last_two_rounds
    if !partial_full?
      place_known_color
      move_known_color
    end
    place_known_entries
  end

  private

  def set_partial_guess
    @partial_guess = [nil, nil, nil, nil]
  end

  def last_two_rounds
    if @final_guess.compact.length == 2 && @color_array.length == 2
      @partial_guess.each_index do |index|
        if @final_guess[index] == nil
          @partial_guess[index] = @color_array.shift
          @color_array << @partial_guess[index]
        end
      end
      @color_array.reverse!
    end
  end

  def partial_full?
    @final_guess.compact.length == 2 && @color_array.length == 2
  end

  def place_known_color
    if !@color_array.empty?
      if guess[-1].include?(@color_array[0]) && @final_guess[(guess[-1].index(@color_array[0]))] == nil
        @partial_guess[(guess[-1].index(@color_array[0]))] = @color_array[0]
      else
        @partial_guess.each_index do |index|
          if @final_guess[index] == nil
            @partial_guess[index] = @color_array[0]
            return
          end
        end
      end  
    end
  end

  def move_known_color
    if @partial_guess.index(@color_array[0]) == guess[-1].index(@color_array[0])
      if correct_color.length >= 2 && correct_color[-1] != "0"
        if (@partial_guess.index(@color_array[0]).to_i + 1) < 4 && @final_guess[(@partial_guess.index(@color_array[0]).to_i + 1)] == nil
          @partial_guess[(@partial_guess.index(@color_array[0]).to_i + 1)] = @color_array[0]
        elsif (@partial_guess.index(@color_array[0]).to_i + 2) < 4 && @final_guess[(@partial_guess.index(@color_array[0]).to_i + 2)] == nil
          @partial_guess[(@partial_guess.index(@color_array[0]).to_i + 2)] = @color_array[0]
        elsif (@partial_guess.index(@color_array[0]).to_i + 3) < 4 && @final_guess[(@partial_guess.index(@color_array[0]).to_i + 3)] == nil
          @partial_guess[(@partial_guess.index(@color_array[0]).to_i + 3)] = @color_array[0]
        end
        @partial_guess[(@partial_guess.index(@color_array[0]).to_i)] = nil 
      end
    end
  end

  def place_known_entries
    @final_guess.each_index do |index|
      if @final_guess[index] != nil
        @partial_guess[index] = @final_guess[index]
      end
    end
  end
end

class MastermindGuessCompletion
  attr_reader :final_guess, :correct_place, :colors
  attr_accessor :color_array, :partial_guess, :guess

  def initialize(args)
    @correct_place = args[:correct_place]
    @final_guess = args[:final_guess]
    @color_array = args[:color_array]
    @partial_guess = args[:partial_guess]
    @guess = args[:guess]
    @colors = args[:colors]
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
          @partial_guess[index] = (@colors - @color_array - @final_guess)[0]
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
  def initialize(args)
    @correct_color = args[:correct_color]
    @correct_place = args[:correct_place]
    @guess = args[:guess]
    @color = MastermindColor.new(:correct_color => @correct_color,
                                 :correct_place => @correct_place,
                                 :guess => @guess)
  end

  def complete_round
    @color.add_colors_to_color_array
    @final = MastermindFinalPlace.new(:final_guess => @color.final_guess, 
                                      :color_array => @color.color_array, 
                                      :correct_color => @color.correct_color, 
                                      :guess => @color.guess)
    @final.final_placement
    @placement = MastermindColorPlacement.new(:final_guess => @final.final_guess, 
                                              :color_array => @final.color_array, 
                                              :guess => @color.guess, 
                                              :correct_color => @color.correct_color)
    @placement.place_color
    @guess = MastermindGuessCompletion.new(:correct_place => @color.correct_place, 
                                            :final_guess => @placement.final_guess, 
                                            :color_array => @placement.color_array, 
                                            :partial_guess => @placement.partial_guess, 
                                            :guess => @color.guess, 
                                            :colors => @color.colors)
    @guess.guess_for_this_turn
  end
end