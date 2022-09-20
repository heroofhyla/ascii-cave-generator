# why is there not a built-in for this
def sign(num)
  num <=> 0
end

def is_connected(map)
  return false unless map.include? "s"
  return true unless map.include? "e"

  start_index = map.index "s"
  end_index = map.index "e"

  column_count = 1 + map.index("\n")

  return true if start_index + column_count == end_index

  step_sign = sign(end_index - start_index)
  
  # Check by row
  start_index.step(end_index, step_sign) do |i|
    c = map[i]
    break if c == "\n"
    break if c == "#"
    return true if c == "e"
  end

  # Check by column
  start_index.step(end_index, column_count * step_sign) do |i|
    c = map[i]
    break if c == "\n"
    break if c == "#"
    return true if c == "e"
  end

  return false
end
