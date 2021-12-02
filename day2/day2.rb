require 'pry'

class Navigator
  def initialize(file_name)
    @input_array = File.read(file_name).split("\n")
    @depth = 0
    @position = 0
  end

  def calculate_position
    puts "POSITION"

    @input_array.each do |line|
      direction_and_distance = line.split(" ")
      direction = direction_and_distance[0]
      distance = direction_and_distance[1].to_i

      if direction == "up"
        change_depth(distance * -1)
      elsif direction == "down"
        change_depth(distance)
      elsif direction == "forward"
        change_position(distance)
      else
        raise Exception.new "this direction isn't up, down, or forward"
      end
    end

    puts "FINAL DEPTH: #{@depth}, FINAL POSITION: #{@position}"
    puts "multipled: #{@depth * @position}"
  end

  def change_depth(distance)
    @depth += distance
  end

  def change_position(distance)
    @position += distance
  end
end

navigator = Navigator.new('input.txt')
navigator.calculate_position
  