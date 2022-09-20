require_relative "mapgen.rb"

TILE_WIDTH = 7
TILE_HEIGHT = 7
X_TILES = 6
Y_TILES = 4

center_x = X_TILES / 2
center_y = Y_TILES / 2

maps = []

Y_TILES.times do
  maps << []
end

minimap = []
Y_TILES.times do
  row = []
  X_TILES.times do
    row << UNSET
  end
  minimap << row
end

minimap[center_y][center_x] = CENTER
maps[center_y][center_x] = create_center_start_map(TILE_WIDTH, TILE_HEIGHT)

def build(mini, full, start_y, start_x)
  directions = [
    [1,0, SOUTH],
    [0,1, EAST],
    [-1,0, NORTH],
    [0,-1, WEST]
  ]

  directions.shuffle!

  for direction in directions
    new_y = start_y + direction[0]
    new_x = start_x + direction[1]
    next if new_x >= X_TILES
    next if new_x < 0
    next if new_y >= Y_TILES
    next if new_y < 0
    const_dir = direction[2]
    if mini[new_y][new_x] == UNSET
      entry_point = rand(TILE_WIDTH - 2) + 1
      mini[new_y][new_x] = const_dir
      full[start_y][start_x] = place_exit(full[start_y][start_x], const_dir, entry_point)
      full[new_y][new_x] = create_map(TILE_WIDTH,TILE_HEIGHT, opposite_dir(const_dir), entry_point)
      build(mini, full, new_y, new_x)
    end
  end

  full[start_y][start_x] = create_narrow_path(full[start_y][start_x])

end

build(minimap, maps, center_y, center_x)

big_map = ""
for row in maps
  big_map << concat_maps(row) << "\n"
end

(rand(500) + 400).times do
  big_map = grow_walkable_area(big_map)
end

big_map = clean_up_placeholders(big_map)
puts big_map
