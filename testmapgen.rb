require_relative "mapgen.rb"
require "test/unit"

class TestMapGen < Test::Unit::TestCase
  def test_map_with_no_start_is_not_connected
    map = <<~MAP.strip
      .....
      .....
      .....
      .....
      .....
    MAP

    assert !is_connected(map)
  end

  def test_start_only_map_is_connected
    map = <<~MAP.strip
      .....
      .....
      s....
      .....
      .....
    MAP

    assert is_connected(map)
  end

  def test_map_with_walls_blocking_route_is_not_connected
    map = <<~MAP.strip
      ..#..
      ..#..
      s.#..
      ..#.e
      ..#..
    MAP

    assert !is_connected(map)
  end

  def test_map_with_walls_but_no_exit_is_connected
    map = <<~MAP.strip
      ..#..
      ..#..
      s.#..
      ..#..
      ..#..
    MAP

    assert is_connected(map)
  end 

  def test_can_find_exit_to_east_trivially
    map = <<~MAP.strip
      se...
      .....
      .....
      .....
      ..#..
    MAP

    assert is_connected(map)
  end

  def test_can_find_exit_to_east_with_some_space
    map = <<~MAP.strip
      s..e.
      .....
      .....
      .....
      ..#..
    MAP

    assert is_connected(map)
  end

  def test_can_find_exit_to_east_if_starting_past_0
    map = <<~MAP.strip
      #.s.e
      .....
      .....
      .....
      ..#..
    MAP

    assert is_connected(map)
  end

  def test_can_find_exit_west
    map = <<~MAP.strip
      #.e.s
      .....
      .....
      .....
      ..#..
    MAP
    
    assert is_connected(map)
  end

  def test_cannot_find_exit_by_wrapping
    map = <<~MAP.strip
      ..#.s
      e..##
      .....
      .....
      ..#..
    MAP
    
    assert !is_connected(map)
  end

end
