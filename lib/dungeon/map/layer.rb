class Dungeon::Map::Layer
	def initialize(name, tiles)
		@name = name
		@tiles = tiles
		@properties = {}
	end

	# Sets tile properties.
	def set(property, tiles, opts = {}, filter = nil)
		@properties[property] = { tiles: tiles, opts: opts, filter: filter }
	end

	# Returns each tile, filtered by a specific property.
	# The default property filter is a simple class mask.
	def get(name = nil)
		property = @properties[name]
		if property
			@tiles.select do |tile|
				filter = property[:filter] || default_filter
				property[:tiles].inject(false) do |kept, tile_klass|
					filter.call tile, kept, tile_klass, property[:opts]
				end
			end
		else
			@tiles
		end
	end

	private

	# Returns all matching tiles with same class.
	def default_filter
		lambda { |tile, kept, tile_klass, opts|
			kept || tile.is_a?(tile_klass)
		}
	end
end
