#!/usr/bin/ruby -w
require 'curses'

class Conway
	def initialize(width, height)
		@current_state = Array.new
		height.times do @current_state << Array.new(width) {0} end
		random_plots(500)
		#@current_state[2][2] = 1
		#@current_state[3][2] = 1
		#@current_state[4][2] = 1
		#@current_state[10][7] = 1
		#@current_state[11][7] = 1
		#@current_state[10][8] = 1
		#@current_state[11][8] = 1
	end

	def random_plots(num)
		num.times do 
			x = rand(@current_state[0].count)
			y = rand(@current_state.count)
			@current_state[y][x] = 1
		end
	end

	def calc_board
		size = @current_state.count
		neighbor_count = Array.new
		size.times do neighbor_count << Array.new(@current_state[0].count) {0} end
		@current_state.each_with_index do |row, y|
			row.each_with_index do |state, x|
				if state == 1
					#increase state count of neighbors
					if y-1 > 0
						if x-1 > 0
							neighbor_count[y-1][x-1] += 1
						end
						if x+1 < row.count
							neighbor_count[y-1][x+1] += 1
						end
						neighbor_count[y-1][x] += 1
					end
					if y+1 < size
						if x-1 > 0
							neighbor_count[y+1][x-1] += 1
						end
						if x+1 < row.count
							neighbor_count[y+1][x+1] += 1
						end
						neighbor_count[y+1][x] += 1
					end
					if x-1 > 0
						neighbor_count[y][x-1] += 1
					end
					if x+1 < row.count
						neighbor_count[y][x+1] += 1
					end
				end
			end
		end
		update_board(neighbor_count)
	end

	def update_board(neighbor_count)
		next_state = Array.new
		@current_state.count.times do next_state << Array.new(@current_state[0].count) {0} end
		@current_state.each_with_index do |row, y|
			row.each_with_index do |state, x|
				if state == 1
					#if 2 <= neighbor_count[y][x] < 4
					if neighbor_count[y][x] == 2 || neighbor_count[y][x] == 3
						next_state[y][x] = 1
					else
						next_state[y][x] = 0
					end
				else
					if neighbor_count[y][x] == 3
						next_state[y][x] = 1
					end
				end
			end
		end
		@current_state = next_state
	end


	def print_board
		print @current_state
	end
end


Curses.init_screen
Curses.start_color
if Curses.has_colors?
	Curses.init_pair(1, Curses::COLOR_RED, Curses::COLOR_WHITE)
	Curses.init_pair(2, Curses::COLOR_GREEN, Curses::COLOR_WHITE)
end
begin
	nb_lines = Curses.lines
	nb_cols = Curses.cols
ensure
	Curses.close_screen
end

board = Conway.new(nb_cols,nb_lines)
while TRUE
	board.instance_variable_get(:@current_state).each_with_index do |row, y|
		row.each_with_index do |state, x|
			Curses.setpos(y,x)
			if state == 1
				Curses.attrset(Curses.color_pair(2) | Curses::A_BOLD)
				Curses.addstr(".")
			else 
				Curses.attrset(Curses.color_pair(1) | Curses::A_BOLD)
				Curses.addstr("X")
			end
		end
	end
	Curses.refresh
	sleep(1)
	board.calc_board
end
