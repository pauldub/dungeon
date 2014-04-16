class Dungeon::Tile < Chingu::GameObject
	trait :bounding_box
	traits :collision_detection

	include Dungeon::Lighting

	def initialize(options)
		super options
		lighting_initialize()
		@preloaded_colors = get_preloaded_colors
	end

	def update
		super
		updatecolor(@preloaded_colors)
	end
end

class Dungeon::StoneFloor < Dungeon::Tile
	def setup
		@image = Image['media/stone_floor.png']
	end
end

class Dungeon::StoneWall < Dungeon::Tile
	def setup
		@image = Image['media/stone_wall.png']
	end
end

class Dungeon::StoneWallV < Dungeon::Tile
	def setup
		@image = Image['media/stone_wall_v.png']
	end
end
