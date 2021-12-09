require 'pry'

class LineMapper
  def initialize(file_name)
    @map = []
    @lines = []
    @height = 0
    @width = 0

    read_file(file_name)

    determine_height_and_width
    generate_lines
    populate_empty_map
    place_lines_on_map

    draw_map
  end

  def read_file(file_name)
    @input_array ||= File.read(file_name).split("\n")
  end

  def determine_height_and_width
    all_x_coords = []
    all_y_coords = []

    @input_array.each do |line|
      line.split(" -> ").flat_map do |coords| 
        coords = coords.split(",").map(&:to_i)
        all_x_coords << coords[0]
        all_y_coords << coords[1]
      end
    end

    # I think we need to add 1 to the width and height, because a point at 890 cant be at @map[890] otherwise
    # we have to add or subtract 1 somewhere to accomodate for 0 index notation, so we might as well do it here

    # this will make the board potentially one row & column too large, which should only matter 
    # if we start caring about empty spaces

    @width = all_x_coords.max + 1 
    @height = all_y_coords.max + 1
  end

  def populate_empty_map
    @height.times do |height_idx| 
      @map << []
      @width.times {|width_idx| @map[height_idx] << 0} 
    end
  end

  def generate_lines
    @input_array.each do |line|
      two_points = line.split(" -> ")
      point1 = make_point_from_string(two_points[0])
      point2 = make_point_from_string(two_points[1])
      line = Line.new(point1, point2)

      @lines << line if line.points.any?
    end
  end

  def make_point_from_string(point_string)
    coordinate_strings = point_string.split(",").map(&:to_i)
    
    Point.new(coordinate_strings[0], coordinate_strings[1])
  end

  def place_lines_on_map
    @lines.each do |line|
      line.points.each do |point|
        @map[point.y][point.x] += 1
      end
    end
  end

  def draw_map
    @map.each do |row|
      row.each do |wire_count|
        if wire_count != 0
          print wire_count 
        else
          print "."
        end
      end  
      puts ""
    end
  end

  def points_with_crossings
    points_where_lines_cross = 0

    @height.times do |column|
      @width.times do |row|
        points_where_lines_cross += 1 if @map[column][row] > 1
      end
    end

    puts "There are #{points_where_lines_cross} points where lines cross"
  end
end

class Line
  def initialize(point1, point2)
    @point1 = point1
    @point2 = point2
    @points = []

    generate_points
  end

  attr_reader :points

  def generate_points
    if @point1.x == @point2.x || @point1.y == @point2.y
      make_horizontal_or_vertical_line
    elsif (@point1.x - @point2.x).abs == (@point1.y - @point2.y).abs
      make_diagonal_line
    else
      puts "this is not a straight line"
      nil
    end
  end

  def make_horizontal_or_vertical_line
    #add the starting and ending point, then all the ones inbetween

    if @point1.x == @point2.x
      starting_point = @point1.y < @point2.y ? @point1 : @point2;
      @points << starting_point
      (@point2.y - @point1.y).abs.times do |idx|
        @points << Point.new(@point1.x, (starting_point.y + idx + 1))
      end
    elsif @point1.y == @point2.y
      starting_point = @point1.x < @point2.x ? @point1 : @point2;
      @points << starting_point
      (@point2.x - @point1.x).abs.times do |idx|
        @points << Point.new((starting_point.x + idx + 1), @point1.y)
      end
    else
      raise "can't calculate points since this is not a horizontal or vertical line"
    end

    points
  end

  def make_diagonal_line
    distance = @point1.x - @point2.x

    horizontal_up_or_down = (@point1.x - @point2.x) > 0 ? -1 : 1
    vertical_up_or_down = (@point1.y - @point2.y) > 0 ? -1 : 1

    @points = [@point1]

    distance.abs.times do |horizontal_idx|
      new_point_x = @point1.x + (horizontal_idx + 1) * horizontal_up_or_down
      new_point_y = @point1.y + (horizontal_idx + 1) * vertical_up_or_down
      @points << Point.new(new_point_x, new_point_y)
    end
  end
end

class Point
  def initialize(x, y)
    @x = x
    @y = y
  end

  attr_reader :x, :y
end


map = LineMapper.new('input.txt')
map.points_with_crossings