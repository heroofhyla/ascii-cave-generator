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

    assert !connected?(map)
  end

  def test_start_only_map_connected?
    map = <<~MAP.strip
      .....
      .....
      s....
      .....
      .....
    MAP

    assert connected?(map)
  end

  def test_map_with_walls_blocking_route_is_not_connected
    map = <<~MAP.strip
      ..#..
      ..#..
      s.#..
      ..#.e
      ..#..
    MAP

    assert !connected?(map)
  end

  def test_map_with_walls_but_no_exit_connected?
    map = <<~MAP.strip
      ..#..
      ..#..
      s.#..
      ..#..
      ..#..
    MAP

    assert connected?(map)
  end 

  def test_can_find_exit_to_east_trivially
    map = <<~MAP.strip
      se...
      .....
      .....
      .....
      ..#..
    MAP

    assert connected?(map)
  end

  def test_can_find_exit_to_east_with_some_space
    map = <<~MAP.strip
      s..e.
      .....
      .....
      .....
      ..#..
    MAP

    assert connected?(map)
  end

  def test_can_find_exit_to_east_if_starting_past_0
    map = <<~MAP.strip
      #.s.e
      .....
      .....
      .....
      ..#..
    MAP

    assert connected?(map)
  end

  def test_can_find_exit_west
    map = <<~MAP.strip
      #.e.s
      .....
      .....
      .....
      ..#..
    MAP

    assert connected?(map)
  end

  def test_cannot_find_exit_by_wrapping
    map = <<~MAP.strip
      ..#.s
      e..##
      .....
      .....
      ..#..
    MAP

    assert !connected?(map)
  end

  def test_can_find_exit_south_trivially
    map = <<~MAP.strip
      #.s..
      ..e..
      .....
      .....
      ..#..
    MAP

    assert connected?(map)
  end

  def test_can_find_exit_south_with_space
    map = <<~MAP.strip
      #....
      ..s..
      .....
      .....
      ..e..
    MAP

    assert connected?(map)
  end

  def test_can_find_exit_north
    map = <<~MAP.strip
      #....
      ..e..
      .....
      .....
      ..s..
    MAP

    assert connected?(map)
  end

  def test_can_find_exit_diagonally
    map = <<~MAP.strip
      #....
      e....
      .....
      .....
      ..s..
    MAP

    assert connected?(map)
  end

  def test_can_find_in_complex_maze
    map = <<~MAP.strip
      #....
      ..#..
      ..#..
      .###.
      e#s..
    MAP

    assert connected?(map)
  end

  def test_all_exits_must_be_reachable
    map = <<~MAP.strip
      #....
      e.#..
      ..#..
      ####.
      e.#s.
    MAP

    assert !connected?(map)
  end

  def test_multiple_reachable_exits_pass
    map = <<~MAP.strip
      #....
      e.#..
      ..#..
      #.##.
      e.#s.
    MAP

    assert connected?(map)
  end

  def test_create_smallest_map
    map = <<~MAP.strip
      s
    MAP

    assert_equal(map, create_map(1,1,EAST,0))
  end

  def test_map_size_is_honored
    map = <<~MAP.strip
      sX.....
      .......
      .......
    MAP

    assert_equal(map, create_map(7,3,NORTH,0))
  end

  def test_map_height_7_by_3
    map = <<~MAP.strip
      .......
      X......
      s......
    MAP

    assert_equal(3, map_height(map))
  end
  def test_create_edges_west
    map = <<~MAP.strip
      .......
      X......
      s......
    MAP

    assert_equal(map, create_map(7,3,WEST,2))
  end

  def test_map_starting_pos_honored_on_north_edge
    map = <<~MAP.strip
      ...XsX.
      .......
      .......
    MAP

    assert_equal(map, create_map(7,3,NORTH,4))
  end

  def test_map_starting_pos_honored_on_south_edge
    map = <<~MAP.strip
      .......
      .......
      .XsX...
    MAP

    assert_equal(map, create_map(7,3,SOUTH,2))
  end

  def test_map_starting_pos_honored_on_west_edge
    map = <<~MAP.strip
      .......
      .......
      X......
      s......
      X......
    MAP

    assert_equal(map, create_map(7,5,WEST,3))
  end

  def test_map_starting_pos_honored_on_east_edge
    map = <<~MAP.strip
      .......
      ......X
      ......s
      ......X
      .......
    MAP

    assert_equal(map, create_map(7,5,EAST,2))

  end

  def test_placing_exit
    expected_map = <<~MAP.strip
      .......
      ......X
      ......s
      e.....X
      .......
    MAP

    map = create_map(7,5,EAST,2) 
    map = place_exit(map, WEST, 3)
    assert_equal(map, expected_map)
  end

  def test_fix_south_wall_placement
    assert_nothing_raised {create_map(12,14,SOUTH,3)}
  end

  def test_south_wall_entrance_tall_map
    map = <<~MAP.strip
      ....
      ....
      ....
      ....
      ....
      .XsX
    MAP

    assert_equal(map, create_map(4,6,SOUTH,2))
  end

  def test_nth_index
    assert_equal(4, nth_index("banana", 'n', 1))
  end

  def test_nth_index_first
    assert_equal(0, nth_index("america", 'a', 0))
  end

  def test_nth_index_fail_to_find
    assert_equal(nil, nth_index("banana", 'n', 2))
  end

  def test_south_wall_exit_on_ten_by_ten
    expected_map =<<~MAP.strip
      X.........
      s.........
      X.........
      ..........
      ..........
      ..........
      ..........
      ..........
      ..........
      ..e.......
    MAP

    map = create_map(10,10,WEST,1)
    map = place_exit(map, SOUTH,2)
    assert_equal(map, expected_map)
  end

  def test_map_width
    assert_equal(5, map_width(create_map(5,9,WEST,1)))
  end

  def test_map_width_for_single_column_map
    assert_equal(1, map_width(create_map(1,10,WEST,0)))
  end

  def test_map_width_for_single_row_map
    assert_equal(9, map_width(create_map(9,1,WEST,0)))
  end

  def test_map_height
    assert_equal(3, map_height(create_map(7,3,WEST,0)))
  end

  def test_map_height_square
    assert_equal(10, map_height(create_map(10,10,WEST,0)))
  end

  def test_map_height_for_single_row_map
    assert_equal(1, map_height(create_map(10,1,WEST,0)))
  end

  def test_map_height_for_single_column_map
    assert_equal(10, map_height(create_map(1,10,WEST,0)))
  end

  def test_beyond_edge_within_top_left_north

    map = <<~MAP.strip
      s#.....
      .......
      .......
    MAP

    assert(!beyond_edge?(map, NORTH,0))
  end

  def test_beyond_edge_before_top_left_north

    map = <<~MAP.strip
      s#.....
      .......
      .......
    MAP

    assert(beyond_edge?(map, NORTH,-1))
  end

  def test_beyond_edge_within_top_right_north

    map = <<~MAP.strip
      s#.....
      .......
      .......
    MAP

    assert(!beyond_edge?(map, NORTH,6))
  end

  def test_beyond_edge_after_top_right_north

    map = <<~MAP.strip
      s#.....
      .......
      .......
    MAP

    assert(beyond_edge?(map, NORTH,7))
  end

  def test_beyond_edge_within_bottom_left_south

    map = <<~MAP.strip
      s#.....
      .......
      .......
    MAP

    assert(!beyond_edge?(map, SOUTH,0))
  end

  def test_beyond_edge_before_bottom_left_south

    map = <<~MAP.strip
      s#.....
      .......
      .......
    MAP

    assert(beyond_edge?(map, SOUTH,-1))
  end

  def test_beyond_edge_within_bottom_right_south

    map = <<~MAP.strip
      s#.....
      .......
      .......
    MAP

    assert(!beyond_edge?(map, SOUTH,6))
  end

  def test_beyond_edge_after_bottom_right_south

    map = <<~MAP.strip
      s#.....
      .......
      .......
    MAP

    assert(beyond_edge?(map, SOUTH,7))
  end

  def test_beyond_edge_within_top_left_west

    map = <<~MAP.strip
      s#.....
      .......
      .......
    MAP

    assert(!beyond_edge?(map, WEST,0))
  end

  def test_beyond_edge_before_top_left_west

    map = <<~MAP.strip
      s#.....
      .......
      .......
    MAP

    assert(beyond_edge?(map, WEST,-1))
  end

  def test_beyond_edge_within_bottom_left_west

    map = <<~MAP.strip
      s#.....
      .......
      .......
    MAP

    assert(!beyond_edge?(map, WEST,2))
  end

  def test_beyond_edge_after_bottom_left_west

    map = <<~MAP.strip
      s#.....
      .......
      .......
    MAP

    assert(beyond_edge?(map, WEST,3))
  end

  def test_beyond_edge_within_top_right_east

    map = <<~MAP.strip
      s#.....
      .......
      .......
    MAP

    assert(!beyond_edge?(map, EAST,0))
  end

  def test_beyond_edge_before_top_right_east

    map = <<~MAP.strip
      s#.....
      .......
      .......
    MAP

    assert(beyond_edge?(map, EAST,-1))
  end

  def test_beyond_edge_within_bottom_right_east

    map = <<~MAP.strip
      s#.....
      .......
      .......
    MAP

    assert(!beyond_edge?(map, EAST,2))
  end

  def test_beyond_edge_after_bottom_right_east

    map = <<~MAP.strip
      s#.....
      .......
      .......
    MAP

    assert(beyond_edge?(map, EAST,3))
  end

  def test_create_center_start_map
    map = <<~MAP.strip
      .....
      .....
      ..s..
      .....
      .....
    MAP
    assert_equal(map, create_center_start_map(5,5))
  end

end
