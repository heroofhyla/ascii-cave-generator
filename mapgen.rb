EAST = 0
NORTH = 1
WEST = 2
SOUTH = 3

# why is there not a built-in for this
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
def is_connected(map)
  return false unless map.include? "s"
  return true unless map.include? "e"

  map = map.dup

  map.sub! "s", "!"

  column_count = 1 + map.index("\n")

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

        if map[next_space] == "e" || map[next_space] == "." || map[next_space] == 'o'
          map[next_space] = "!"
          made_progress = true
        end
      end
    end

    return true if map.count("e") == 0
  end

  return false
end

def create_map(width,height,entrance_edge,entrance_pos)
  map = ("." * width + "\n") * height
  map[get_edge_pos(map, entrance_edge, entrance_pos)] = 's'
  return map[0...-1]
end

def place_exit(map, edge, pos)
  map = map.dup
  map[get_edge_pos(map +"\n", edge, pos)] = 'e'
  return map
end

def get_edge_pos(map, edge, pos)
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
    free_space_count = map.count '.'
    random_spot_index = rand(free_space_count)
    random_spot_pos = nth_index(map, ".", random_spot_index)
    map[random_spot_pos] = "#"
    if not is_connected(map)
      map[random_spot_pos] = 'o'
    end
  end
  map.gsub!('o','.')
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

  rows.join("\n")
  return rows
end

def map_width(map)
  return map.index("\n") if map.include?("\n")
  return map.length
end

def map_height(map)
  return (map.length) / (map_width(map) + 1) + 1
end

