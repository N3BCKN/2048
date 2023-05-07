require 'ruby2d'

WIDTH             = 600
TILES_HEIGHT      = 600
PANEL_HEIGHT      = 100
GRID              = 600/4
BACKGROUND_COLOR  = '#B9AA9E'
TEXT_COLOR        = '#766E65'

class Game
  attr_accessor :tiles, :game_over

  def initialize
    @tiles = []
    @score = 0
    @game_over = false
    generate_tiles
    fill_random_tiles(3)
  end 

  def draw
    @tiles.each_with_index do |_,col|
      @tiles[col].each_with_index do |_,row|
        Square.new(x: col * GRID, y: row * GRID + PANEL_HEIGHT, size: GRID - 7, color: tile_colors[@tiles[row][col]])
        Text.new(@tiles[row][col], x: col * GRID + GRID/3, y: row * GRID + GRID/3 + PANEL_HEIGHT, size: GRID/2, color: TEXT_COLOR) if @tiles[row][col] > 0
      end
    end

    Text.new("Score: #{@score}", x: WIDTH/3, y: PANEL_HEIGHT/2 - 40, size: 30)
    Text.new("Game over", x: WIDTH/3, y: PANEL_HEIGHT/2, size: 30, color: 'red') if @game_over
  end

  def move_up
    @tiles.each_with_index do |_, i|
      tile = [@tiles[0][i], @tiles[1][i], @tiles[2][i], @tiles[3][i]]
      moved_tile = slide(tile)
      4.times { |n| @tiles[n][i] = moved_tile[n] }
    end
  end 

  def move_right
    @tiles.each_with_index do |tile, i|
      @tiles[i] = slide(tile.reverse).reverse
    end 
  end 

  def move_down 
    @tiles.each_with_index do |_, i|
      tile = [@tiles[0][i], @tiles[1][i], @tiles[2][i], @tiles[3][i]]
      moved_tile = slide(tile.reverse).reverse
      4.times { |n| @tiles[n][i] = moved_tile[n] }
    end
  end 

  def move_left
    @tiles.each_with_index do |tile, i|
      @tiles[i] = slide(tile)
    end 
  end

  def fill_random_tile 
    if @tiles.flatten.all? { |elem| elem != 0}
      @game_over = true
      return 
    end

    found = false 
    while !found 
      x,y = rand(4), rand(4)
      if @tiles[x][y] == 0
        init_value = rand > 0.8 ? 4 : 2 
        @tiles[x][y] = init_value
        found = true
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
      x,y = rand(4), rand(4)
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

  def slide(arr)
    arr.reject! { |elem| elem == 0 }
    if arr.size > 1
      arr.each_with_index do |elem, i|
        if arr[i] == arr[i+1]
          arr[i] *= 2 
          arr[i+1] = 0
          @score += arr[i]
        end
      end
    end

    arr.reject! { |elem| elem == 0 }
    while(arr.size < 4)
      arr << 0
    end
    arr
  end
end


set title: '2048'
set width: WIDTH
set height: TILES_HEIGHT + PANEL_HEIGHT
set background: BACKGROUND_COLOR

game = Game.new

update do
  clear
  game.draw
end

on :key_down do |event|
  case event.key 
  when 'up'
    game.move_up
  when 'down'
    game.move_down
  when 'left'
    game.move_left
  when 'right'
    game.move_right    
  end

  game.fill_random_tile
end

show
