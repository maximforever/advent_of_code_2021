input_array = []
readings_increasing = 0
previous_reading = nil

readings_by_three_increasing = 0
previous_sum_by_three = nil

GROUPING_SIZE = 3

# read the text file into an array
File.readlines('input.txt').each do |line|
  input_array << line.strip.to_i
end


# PART 1
input_array.each do |reading|
  readings_increasing += 1  if (!previous_reading.nil? && reading > previous_reading)
  previous_reading = reading
end

# PART 2
# there is a way to generalize it to X numbers but I'm not sure what it is...
(input_array.length - 3).times do |index|
  overlapping_sum = input_array[index + 1] + input_array[index + 2]
  this_sum_by_three = input_array[index] + overlapping_sum
  next_sum_by_three = input_array[index+ 3] + overlapping_sum

  readings_by_three_increasing += 1 if (!previous_sum_by_three.nil? && next_sum_by_three > this_sum_by_three)

  previous_sum_by_three = this_sum_by_three
end

puts "READINGS INCREASING: #{readings_increasing}"
puts "READINGS BY THREE INCREASING: #{readings_by_three_increasing}"
