require_relative "mapgen.rb"

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
  puts concat_maps(maps[row])
end

