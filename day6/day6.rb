require 'pry'

class FishDaddy
  def initialize(file_name)
    @fish = []
    @current_day = 0
  end

  def read_file(file_name)
    @input_array ||= File.read(file_name).split("\n")
  end

  def do_thing
    puts "I'm making fish!"
  end
end

class Fish
  def initialize(days)
    @days = days
  end

  attr_reader :days
end


fish_daddy = FishDaddy.new('input.txt')
fish_daddy.do_thing