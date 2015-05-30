class Game
	def initialize
		@colors = ["blue", "green", "red", "yellow", "white", "black"]
		@array =[["blue","blue","blue","blue"]]
		@correct_place = []
		@correct_color = []
		@final_array = []
		@partial_array =[]
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
		if @correct_place[@correct_place.length - 1] == "4"
		  return
		end
		@total = @correct_place[@correct_place.length - 1].to_i + @correct_color[@correct_color.length - 1].to_i
		if @total == 4
			@final_array = @array
		else
			(@total - @final_array.length).times do |enter|
				@final_array << @colors[@correct_place.length - 1]
			end
		end
		@partial_array << @final_array
		while @partial_array.flatten.length < 4
			(4 - @partial_array.flatten.length).times do |enter|
				@partial_array << @colors[@correct_place.length]
			end
		end
		@array << @partial_array.flatten!
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
		if answer == "y" || answer = "Y"
			game = Game.new
			self.complete_game(game)
		else
			return
		end
	end

	def complete_game(game)
		#round 1
		game.round
		game.color_check
		#round 2
		game.round
		game.color_check
		#round 3
		game.round
		game.color_check
		#round 4
		game.round
		game.color_check
		#round 5
		game.round
		game.color_check
		#round 6
		game.round
		game.color_check
		#round 7
		game.round
		game.color_check
		#round 8
		game.round
		game.color_check
		#round 9
		game.round
		game.color_check
		#round 10
		game.round
		game.color_check
		game.game_over
	end
end

game = Game.new
game.complete_game(game)