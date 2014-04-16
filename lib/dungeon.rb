# Game lib
require 'chingu'
# GUI
require 'fidgit'
# repl
require 'pry'

include Gosu

module Dungeon
end

# Traits
require_relative 'dungeon/lighting'

# Actor is the game objects base class
# Except for map which uses Chingu::GameObject
# because it could be extracted from this.
require_relative 'dungeon/actor'
require_relative 'dungeon/actor/stance'

# Game Entities
require_relative 'dungeon/player'
require_relative 'dungeon/tiles'

# Maps
require_relative 'dungeon/map'

# States
require_relative 'dungeon/level'
require_relative 'dungeon/menu'
require_relative 'dungeon/game'

def Dungeon::start 
	Dungeon::Game.new(1024, 768, true).show
end

Dungeon::start()
