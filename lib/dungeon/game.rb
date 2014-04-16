class Dungeon::Game < Chingu::Window
	def setup
		retrofy
		self.factor = 2
		push_game_state Dungeon::Menu
	end
end
