require_relative "mapgen.rb"

big_map = ""

maps = []
5.times do
  maps << []
end
last_exit = rand(8) + 1
5.times do |row|
  5.times do |i|
    if i == 0
      map = create_map(10,10,NORTH,5)
    else
      map = create_map(10,10,WEST,last_exit)
    end
    last_exit = rand(8) + 1
    map = place_exit(map,EAST, last_exit)
    if i == 0
      map = place_exit(map, SOUTH, 5)
    end
    map = create_narrow_path(map)
    maps[row] << map
  end
  big_map << concat_maps(maps[row]) << "\n"
end

1000.times do
  big_map = grow_walkable_area(big_map)
end

big_map = clean_up_placeholders(big_map)
puts big_map
