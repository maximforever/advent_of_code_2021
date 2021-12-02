require 'pry'

class GroupCounter
  def initialize(file_name)
    @input_array = File.read(file_name).split("\n").map {|line| line.to_i }
  end

  def get_increasing_numbers_by_grouping(grouping_size)
    readings_by_grouping_increasing = 0
    previous_sum_by_grouping = 0

    # note: the first index is 0 while the first run is 1
    times_to_run = @input_array.length - grouping_size
    last_index_to_run_on = @input_array.length - 1 - grouping_size

    puts "last_index_to_run_on #{last_index_to_run_on}"

    times_to_run.times do |index|
      overlapping_sum = 0
      
      (grouping_size - 1).times do |group_index|
        overlapping_sum += @input_array[index + group_index + 1]
      end

      this_sum_by_grouping = @input_array[index] + overlapping_sum
      next_sum_by_grouping = @input_array[index + grouping_size] + overlapping_sum

      readings_by_grouping_increasing += 1 if next_sum_by_grouping > this_sum_by_grouping
      previous_sum_by_grouping = this_sum_by_grouping
    end

    puts "# OF INCREASING READINGS, GROUPED BY #{grouping_size}: #{readings_by_grouping_increasing}"
  end
end

counter = GroupCounter.new('input.txt')
counter.get_increasing_numbers_by_grouping(1)
counter.get_increasing_numbers_by_grouping(3)
