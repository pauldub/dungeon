module Dungeon::Utils 
	def player
		@player || Dungeon::Player.all.first
	end

	def draw_last_position(obj)
		viewport.apply { draw_rect [obj.x_before_move - 8 , obj.y_before_move - 8, 16, 16], Color::GREEN, 100, :add } if obj.x_before_move
	end
end

require 'ashton'

module Dungeon::States; end

class Dungeon::States::GameWindow < Fidgit::GuiState
	def button_up(id)
		if id == KbEscape
			pop_game_state(setup: false) 
		else
			super id
		end
	end
	
	def draw
		super
	end
end

require 'pry'
require 'pry-remote'

class Dungeon::States::Pry < Fidgit::GuiState
	include Dungeon::Utils

	def setup
		self.input = { v: :start_pry, esc: :go_back }
		@font = Font[35]
		z = Chingu::DEBUG_ZORDER + 1

		vertical align: :center do
			@status_label = label help_text, z: z
		end
	end

	def help_text
		"Press v to start pry"
	end

	def start_pry
		@status_label.text = "Pry started."
		binding.pry
		@status_label.text = help_text
	end

	def go_back
		push_game_state previous_game_state, setup: false
	end

	def draw
		super

		previous_game_state.draw
	end
end

class Dungeon::States::CharacterInfo < Dungeon::States::GameWindow
	def setup
		@font = Font[35]
		z = Chingu::DEBUG_ZORDER + 1

		vertical align: :center, 
						 background_color: Color::GRAY,
						 border_thickness: 2, 
						 border_color: Color::WHITE,
						 z: z do
			label "Name: foo", z: z

			horizontal spacing_h: 20 do
				label "HP: 10/10", z: z
				label "SP: 3/3", z: z
			end
		end
	end

	def draw
		super

		previous_game_state.draw
	end
end

class Dungeon::Level < Chingu::GameState
	include Dungeon::Utils

	trait :viewport

	def setup
		self.input = { esc: Dungeon::Menu,
										 c: Dungeon::States::CharacterInfo,
										 v: Dungeon::States::Pry,
										 p: Chingu::GameStates::Pause }

		$window.cursor = true

		@map = Dungeon::Map.build do
			tiles = layer :tiles, 'maps/test_map.bmp', { 
				# Hmm, colors are weird the 1st is supposed to be 170 170 170
				[43690, 43690, 43690] => Dungeon::StoneFloor,
				[11308, 11308, 11308]	=> Dungeon::StoneWall,
				[24929, 24929, 24929]	=> Dungeon::StoneWallV
			}

			tiles.set :solid, [Dungeon::StoneWall, Dungeon::StoneWallV]
			tiles.set :floor, [Dungeon::StoneFloor]
		end

		@floor = Chingu::GameObjectMap.new(game_objects: @map.layers[:tiles].get(:floor) , grid: [16, 16], debug: true)

		@player = Dungeon::Player.create x: 32, y: 32
		@player.input = { up: :move_up,
											down: :move_down,
											left: :move_left,
											right: :move_right }

		viewport.game_area = [0, 0, 100 * 16, 100 * 16]		
		viewport.lag = 0
	end

	def update
		super 

		viewport.center_around @player

		tiles = @map.layers[:tiles]

		@player.each_collision tiles.get(:solid) do |player, wall|
			x_before_move = @player.x_before_move
			y_before_move = @player.y_before_move
			offset = 16 * $window.factor
			
			# Move player on the tile next to the one he collides with
			if @player.x != x_before_move 
				@player.x = @player.x > x_before_move ? wall.x - offset : wall.x + offset
			end

			if @player.y != y_before_move
				@player.y = @player.y > y_before_move ? wall.y - offset : wall.y + offset
			end
		end
	
		@hud.destroy if @hud
		@hud = Chingu::Text.create("(#{@player.x}, #{@player.y})", :x => 200, :y => 150, :zorder => 155)
		tiles.get.each do |tile|
			tile.updatelight('dynamic', 180, 235, @player.x, @player.y, 1)

			# Room corners
			tile.updatelight('dynamic', 256, 150, 32, 32, 2)
			tile.updatelight('dynamic', 256, 150, 32, 128, 3)
			tile.updatelight('dynamic', 256, 150, 160, 128, 4)
			tile.updatelight('dynamic', 256, 150, 160, 32, 5)

			# Room center
			tile.updatelight('dynamic', 300, 200, 96, 64, 6)
		end

		game_objects.destroy_if { |go| viewport.outside_game_area? go } 
	end

	def draw
		super
		draw_last_position @player
	end
end
