def is_connected(map)
  return false unless map.include? "s"
  return true unless map.include? "e"
  return false if map.include? "#"
end
