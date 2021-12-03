require 'pry'

class BinaryDiagnosticReader
  def initialize(file_name)
    @gamma_rate = 0
    @epsilon_rate = 0
    @longest_element_length = 0

    create_input_array(file_name)
    #go through each number and add that bit to a 2D array or map (probs map?)\
  end

  def create_input_array(file_name)
    @input_array ||= File.read(file_name).split("\n").map do |line| 
      @longest_element_length = line.length if line.length > @longest_element_length
      line
    end
  end

  def generate_binary_hash
    binary_hash = {}

    @longest_element_length.times do |idx|
      binary_hash[idx] = []
    end

    @input_array.each do |line|
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
    binary_hash = generate_binary_hash
    gamma_rate = get_most_or_least_common_hash(binary_hash, true)
    epsilon_rate = get_most_or_least_common_hash(binary_hash, false)
    power_output =  convert_binary_to_decimal(epsilon_rate) * convert_binary_to_decimal(gamma_rate)

    puts "most common string is #{gamma_rate}"
    puts "least common string is #{epsilon_rate}"
    puts "power output is #{power_output}"
  end
end

binary_diagnostic = BinaryDiagnosticReader.new('input.txt')
binary_diagnostic.get_power_consumption
  