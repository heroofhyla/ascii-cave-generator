UNSET = -1
EAST = 0
NORTH = 1
WEST = 2
SOUTH = 3
CENTER = 4

def sign(num)
  num <=> 0
end

def nth_index(str, substr, instance)
  index = -1
  (instance + 1).times do |i|
    index = str.index(substr, index + 1)
  end
  return index
end

# Runs a simple flood fill on a map to make sure all exits are reachable
# from the entrance
def connected?(map)
  return false unless map.include? "s"
  return true unless map.include? "e"

  map = map.dup

  map.sub! "s", "!"

  column_count = 1 + map_width(map)

  directions = [
    -column_count,
    column_count,
    -1,
    1
  ]

  made_progress = true

  while made_progress
    made_progress = false
    map.chars.each_with_index do |c, i|

      next unless c == '!'
      directions.each do |dir|

        next_space = dir+i
        next if next_space < 0

        if map[next_space] && "e.o".include?(map[next_space])
          map[next_space] = "!"
          made_progress = true
        end
      end
    end

    return true if map.count("e") == 0
  end

  return false
end

def create_center_start_map(width, height)
  map = (("." * width + "\n") * height).strip
  center_pos = (height / 2) * (width + 1) + (width / 2)
  map[center_pos] = 's'
  return map
end

def create_map(width,height,entrance_edge,entrance_pos)
  map = (("." * width + "\n") * height).strip
  map[get_edge_pos(map, entrance_edge, entrance_pos)] = 's'
  if not beyond_edge?(map, entrance_edge, entrance_pos + 1)
    map[get_edge_pos(map, entrance_edge, entrance_pos + 1)] = 'X'
  end
  if not beyond_edge?(map, entrance_edge, entrance_pos - 1)
    map[get_edge_pos(map, entrance_edge, entrance_pos - 1)] = 'X'
  end
  return map
end

def beyond_edge?(map,edge,pos)
  if edge == NORTH or edge == SOUTH
    return true if pos >= map_width(map)
  end
  if edge == EAST or edge == WEST
    return true if pos >= map_height(map)
  end
  return true if pos < 0
end

def place_exit(map, edge, pos)
  map = map.dup
  map[get_edge_pos(map, edge, pos)] = 'e'
  return map
end

def get_edge_pos(map, edge, pos)
  map = map.strip + "\n"
  width = map_width(map)
  height = (map.length) / (width + 1)
  if edge == NORTH
    return pos
  elsif edge == SOUTH
    return (width + 1) * (height - 1) + pos
  elsif edge == WEST
    return pos * (width + 1)
  elsif edge == EAST
    return pos * (width + 1) + width - 1
  else
    return -1
  end
end

def create_narrow_path(map)
  map = map.dup
  return map unless map.include? '.'
  while map.include? '.'
    random_spot_pos = random_walkable_spot(map)
    map[random_spot_pos] = "#"
    if not connected?(map)
      map[random_spot_pos] = 'o'
    end
  end
  map.gsub!('o','.')
  return map
end

def random_walkable_spot(map)
  free_space_count = map.count '.'
  random_spot_index = rand(free_space_count)
  return nth_index(map, ".", random_spot_index)
end

def grow_walkable_area(map)
  map = map.dup
  starting_spot = random_walkable_spot(map)
  column_count = map_width(map) + 1
  directions = [
    -column_count,
    column_count,
    -1,
    1
  ]

  directions.shuffle!
  directions.each do |dir|
    if map[dir + starting_spot] == "#"
      map[dir + starting_spot] = "."
      return map
    end
  end
  return map
end

def concat_maps(maps)
  width = map_width(maps[0])
  height = map_height(maps[0])
  rows = []
  height.times do
    rows << ""
  end
  maps.each do |map|
    map_rows = map.split("\n")
    map_rows.each_with_index do |map_row, i|
      rows[i] << map_row
    end
  end

  return rows.join("\n")
end

def map_width(map)
  return map.index("\n") if map.include?("\n")
  return map.length
end

def map_height(map)
  return (map.length) / (map_width(map) + 1) + 1
end

def clean_up_placeholders(map)
  return map.gsub('X','#').gsub('s', '.').gsub('e', '.')
end

def opposite_dir(dir)
  return SOUTH if dir == NORTH
  return NORTH if dir == SOUTH
  return EAST if dir == WEST
  return WEST if dir == EAST
  return UNSET
end
