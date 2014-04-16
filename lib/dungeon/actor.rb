class Dungeon::Actor < Chingu::GameObject
	traits :velocity, :asynchronous, :timer, :collision_detection

	attr_accessor :x_before_move, :y_before_move

	def move_on(axis, offset, &block)
		# Tweening doesn't keep previous_{x,y} so 
		# save them before. Collision is easier that
		# way.
		@x_before_move = @x
		@y_before_move = @y

		async do |q|
			q.tween @movement_delay || 100, axis => send(axis) + offset * $window.factor
			after @movement_delay || 100 do
				@x_before_move = @x
				@y_before_move = @y

				block.call if block_given?
			end
		end
	end
end

