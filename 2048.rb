require 'ruby2d'

WIDTH = 600
HEIGHT = 600
GRID = 600/4
BACKGROUND_COLOR = '#B9AA9E'
TEXT_COLOR = '#766E65'


class Game
  attr_accessor :tiles

  def initialize
    @tiles = []
    generate_tiles
    fill_random_tiles(3)
  end 

  def draw
    @tiles.each_with_index do |_,col|
      @tiles[col].each_with_index do |_,row|
        p @tiles[col][row]
        p tile_colors[@tiles[col][row]]
        Square.new(x: col * GRID, y: row * GRID, size: GRID - 5, color: tile_colors[@tiles[col][row]])
        Text.new(@tiles[col][row], x: col * GRID + GRID/3, y: row * GRID + GRID/3, size: GRID/2, color: TEXT_COLOR)
      end
    end
  end

  private
  def generate_tiles
    4.times do |n|
      @tiles << []
      @tiles[n] = Array.new(4).fill(0)
    end
  end

  def fill_random_tiles(n)
    while n > 0
      x,y = rand(3), rand(3)
      if @tiles[x][y] == 0
        init_value = rand > 0.8 ? 4 : 2 
        @tiles[x][y] = init_value
        n -= 1
      end 
    end 
  end 

  def tile_colors
    {
      0 => '#CCC0B3',
      2 => '#EEE4DA',
      4 => '#EDE0C8',
      8 => '#F2B179',
      16 => '#F59563',
      32 => '#F67C5F',
      64 => '#F65E3B',
      128 => '#EDCF72',
      256 => '#EDCC61',
      512 => '#EDC850',
      1024 => '#EDC53F',
      2048 => '#EDC22E'
    }
  end
end


set title: '2048'
set width: WIDTH
set height: HEIGHT
set background: BACKGROUND_COLOR

game = Game.new
game.draw

on :key_down do |event|
  p event.key
end

show
