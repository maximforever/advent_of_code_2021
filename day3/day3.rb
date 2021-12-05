require 'pry'

class BinaryDiagnosticReader
  def initialize(file_name)
    @gamma_rate = 0
    @epsilon_rate = 0

    create_input_array(file_name)
    generate_binary_hash_from_array(@input_array)
    #go through each number and add that bit to a 2D array or map (probs map?)\
  end

  def create_input_array(file_name)
    @input_array ||= File.read(file_name).split("\n")
  end


  def generate_binary_hash_from_array(array)
    binary_hash = {}
    longest_element_length = 0
    array.each {|line| longest_element_length = line.length if line.length > longest_element_length}

    longest_element_length.times do |idx|
      binary_hash[idx] = []
    end

    array.each do |line|
      line.split("").each_with_index do |letter, idx|
        binary_hash[idx] << letter
      end
    end

    binary_hash
  end

  def get_most_or_least_common_hash(binary_hash, sort_by_most_common)
    str = ""

    binary_hash.size.times do |idx|
      if sort_by_most_common
        str += binary_hash[idx].max_by{|letter| binary_hash[idx].count(letter)} 
      else
        str += binary_hash[idx].min_by{|letter| binary_hash[idx].count(letter)} 
      end
    end
  
    str
  end

  def convert_binary_to_decimal(binary_string)
    binary_string.to_i(2)
  end

  def get_power_consumption
    binary_hash = generate_binary_hash_from_array(@input_array)

    gamma_rate = get_most_or_least_common_hash(binary_hash, true)
    epsilon_rate = get_most_or_least_common_hash(binary_hash, false)
    power_output =  convert_binary_to_decimal(epsilon_rate) * convert_binary_to_decimal(gamma_rate)

    puts "most common string is #{gamma_rate}"
    puts "least common string is #{epsilon_rate}"
    puts "power output is #{power_output}"
  end

  def get_life_support_rating
    oxygen_generator_rating = convert_binary_to_decimal(get_oxygen_generator_rating)
    co2_scrubber_rating = convert_binary_to_decimal(get_co2_scrubber_rating)

    puts "oxygen_generator_rating #{oxygen_generator_rating}"
    puts "co2_scrubber_rating #{co2_scrubber_rating}"

    life_support_rating = oxygen_generator_rating * co2_scrubber_rating
    puts "life support rating is #{life_support_rating}"
  end

  def get_oxygen_generator_rating(current_array=@input_array.clone)
    filter_array_by_index(@input_array, 0, true)
  end

  def get_co2_scrubber_rating(current_array=@input_array.clone)
    filter_array_by_index(@input_array, 0, false)
  end

  def filter_array_by_index(array, idx, sort_by_most_common)
    binary_hash = generate_binary_hash_from_array(array)
    
    element_count = binary_hash[idx].size
    most_or_least_common_bit = nil

    if sort_by_most_common
      most_or_least_common_bit = binary_hash[idx].max_by{|letter| binary_hash[idx].count(letter)} 
    else
      most_or_least_common_bit = binary_hash[idx].min_by{|letter| binary_hash[idx].count(letter)} 
    end

    most_or_least_common_bit_count = binary_hash[idx].count(most_or_least_common_bit)

    if most_or_least_common_bit_count == element_count/2
      most_or_least_common_bit = sort_by_most_common ? "1" : "0" 
    end
    
    filtered_array = array.select { |line| line.split("")[idx] == most_or_least_common_bit }

    if filtered_array.size > 1 && idx < binary_hash.size
      filter_array_by_index(filtered_array, idx + 1, sort_by_most_common)
    else
      return filtered_array[0]
    end
  end
end

binary_diagnostic = BinaryDiagnosticReader.new('input.txt')
#binary_diagnostic.get_power_consumption
binary_diagnostic.get_life_support_rating



