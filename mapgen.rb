EAST = 0
NORTH = 1
WEST = 2
SOUTH = 3

# why is there not a built-in for this
def sign(num)
  num <=> 0
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

        if map[next_space] == "e" || map[next_space] == "."
          map[next_space] = "!"
          made_progress = true
        end
      end
    end

    return true if map.count("e") == 0
  end

  return false
end

def create_map(width,height,entrance_wall,entrance_pos)
  map = ("." * width + "\n") * height
  map[0] = 's'
  return map[0...-1]
end
