require 'rmagick'

module Dungeon::Map
end

require_relative 'map/layer'

class Dungeon::Map::Builder
	Layer = Dungeon::Map::Layer

	attr_reader :layers

	def initialize(&block)
		@layers = {}

		instance_eval(&block)
	end

	# Create a new layer from a file.
	def layer(name, file_name, spec, opts = { size: [16, 16], factor: nil })
		tile_width, tile_height = opts[:size]
		factor = opts[:factor] || $window.factor || 1
		tiles_spec = Hash[spec.map { |c, k| [Magick::Pixel.new(*c), k] }]
		tiles = []

		image = Magick::Image.read("media/#{file_name}").first
		image.each_pixel do |pixel, x, y|
			tile = tiles_spec[pixel]
			tile && tiles << tile.create(x: x * tile_width * factor, y: y * tile_height * factor)
		end

		layer = Layer.new name, tiles

		@layers[name] = layer

		return layer
	end
end

module Dungeon::Map
	class << self
		def build(&block)
			Builder.new(&block)
		end
	end
end

