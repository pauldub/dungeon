module Dungeon::Actor::Stance
	def standing?
		@x_before_move == @x  && @y_before_move == @y
	end

	def move_left
		@frame = :left
		move_on :x, -16 
	end

	def move_right
		@frame = :right
		move_on :x, 16
	end

	def move_down
		@frame = :down
		move_on :y, 16
	end

	def move_up
		@frame = :up
		move_on :y, -16
	end

	def update_stance
		if standing?
			@image = animations[@frame].first
		else
			@image = animations[@frame].next
		end
	end
end
