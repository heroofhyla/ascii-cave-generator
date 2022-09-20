# why is there not a built-in for this
def sign(num)
  num <=> 0
end

def is_connected(map)
  return false unless map.include? "s"
  return true unless map.include? "e"

  start_index = map.index "s"
  end_index = map.index "e"

  step_sign = sign(end_index - start_index)
  
  start_index.step(end_index, step_sign) do |i|
    c = map[i]
    return false if c == "\n"
    return false if c == "#"
    return true if c == "e"
  end

  return false
end
