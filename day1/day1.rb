require 'pry'

class GroupCounter
  def initialize(file_name)
    @input_array = File.read(file_name).split("\n").map {|line| line.to_i }
  end

  def get_increasing_numbers_by_grouping(grouping_size)
    times_to_run = get_times_to_run(grouping_size)

    readings_by_grouping_increasing = 0

    times_to_run.times do |index|
      readings_by_grouping_increasing += 1 if next_group_is_larger(index, grouping_size)
    end

    puts "# OF INCREASING READINGS, GROUPED BY #{grouping_size}: #{readings_by_grouping_increasing}"
  end

  def next_group_is_larger(index, grouping_size)
    overlapping_sum = get_overlapping_sum(index, grouping_size)
    this_sum_by_grouping = @input_array[index] + overlapping_sum
    next_sum_by_grouping = @input_array[index + grouping_size] + overlapping_sum

    next_sum_by_grouping > this_sum_by_grouping
  end

  def get_times_to_run(grouping_size)
    @input_array.length - grouping_size
  end

  def get_overlapping_sum(index, grouping_size)
    overlapping_sum = 0

    (grouping_size - 1).times do |group_index|
      overlapping_sum += @input_array[index + group_index + 1]
    end

    return overlapping_sum
  end
end

counter = GroupCounter.new('input.txt')
counter.get_increasing_numbers_by_grouping(1)
counter.get_increasing_numbers_by_grouping(3)
