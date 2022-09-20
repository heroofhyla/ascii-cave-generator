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

  def test_can_find_exit_south_trivially
    map = <<~MAP.strip
      #.s..
      ..e..
      .....
      .....
      ..#..
    MAP
    
    assert is_connected(map)
  end

  def test_can_find_exit_south_with_space
    map = <<~MAP.strip
      #....
      ..s..
      .....
      .....
      ..e..
    MAP
    
    assert is_connected(map)
  end

  def test_can_find_exit_north
    map = <<~MAP.strip
      #....
      ..e..
      .....
      .....
      ..s..
    MAP
    
    assert is_connected(map)
  end
  
  def test_can_find_exit_diagonally
    map = <<~MAP.strip
      #....
      e....
      .....
      .....
      ..s..
    MAP
    
    assert is_connected(map)
  end

  def test_can_find_in_complex_maze
    map = <<~MAP.strip
      #....
      ..#..
      ..#..
      .###.
      e#s..
    MAP
    
    assert is_connected(map)
  end

  def test_all_exits_must_be_reachable
    map = <<~MAP.strip
      #....
      e.#..
      ..#..
      ####.
      e.#s.
    MAP
    
    assert !is_connected(map)
  end

  def test_multiple_reachable_exits_pass
    map = <<~MAP.strip
      #....
      e.#..
      ..#..
      #.##.
      e.#s.
    MAP
    
    assert is_connected(map)
  end

  def test_create_smallest_map
    map = <<~MAP.strip
      s
    MAP

    assert_equal(map, create_map(1,1,EAST,0))
  end

  def test_map_size_is_honored
    map = <<~MAP.strip
      s......
      .......
      .......
    MAP

    assert_equal(map, create_map(7,3,NORTH,0))
  end

  #TODO
  def test_map_starting_pos_honored_on_north_edge
    map = <<~MAP.strip
      ....s..
      .......
      .......
    MAP

    assert_equal(map, create_map(7,3,NORTH,4))
  end
end
