class Dungeon::Player < Dungeon::Actor
	trait :bounding_box, scale: 0.8
	trait :animation

	include Stance

	def setup
		@frame = :down
		@movement_delay = 120
	end

	def update
		# TODO: Make Stance a trait!
		update_stance
	end
end
