require_relative "mastermind_play.rb"

require "test/unit"

class TestMastermindEngine < Test::Unit:TestCase

	def color_check_tests
		@total = 2
		@color_array = ["blue"]
		@colors = ["blue", "red"]
		assert_equal(["blue", "red"], Engine.new().color_check )

	end

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
