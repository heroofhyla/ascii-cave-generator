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
end
