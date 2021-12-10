require 'pry'

class CrabLiner
  def initialize(file_name)
    @crab_positions = read_file(file_name).sort
    @optimal_position = get_optimal_position
  end

  def read_file(file_name)
    File.read(file_name).split(",").map(&:to_i)
  end

  def get_optimal_position 
    #assumes sorted position array from initialize
    idx = (@crab_positions.size.to_f/2).floor - 1
    @crab_positions[idx]
  end

  def test_every_position
    min_position = @crab_positions.min
    max_position = @crab_positions.max

    current_optimal_position = 0
    current_optimal_fuel = 99999999999

    (min_position..max_position).each do |position|
      fuel = fuel_needed_to_align_crabs_at_position(position)

      if fuel < current_optimal_fuel
        current_optimal_fuel = fuel
        current_optimal_position = position
      end
    end

    puts "The optimal position is #{current_optimal_position} with #{current_optimal_fuel} fuel"
  end

  def fuel_needed_to_align_crabs_at_position(position)
    # can probs do this with reduce
    fuel = 0
    @crab_positions.each { |pos| fuel += (position - pos).abs }
    
    fuel
  end

  def fuel_needed_to_align_crabs
    # can probs do this with reduce
    fuel = 0
    @crab_positions.each { |pos| fuel += (@optimal_position - pos).abs }

    puts "Need #{fuel} fuel to align #{@crab_positions.size} crabs at position #{@optimal_position}"
  end
end

crab_liner = CrabLiner.new('input.txt')
#crab_liner.test_every_position
crab_liner.fuel_needed_to_align_crabs