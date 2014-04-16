class Dungeon::Menu < Fidgit::GuiState
	attr_accessor :exit

	def setup
		super

		self.exit = false

		vertical align: :center, spacing_h: 20 do
			label "Dungeon", align_h: :center

			button "New game", align_h: :center do
				push_game_state Dungeon::Level
			end

			button "Exit", align_h: :center do
				self.exit = true
				close
			end
		end
	end

	def finalize
		close_game if self.exit
	end
end
