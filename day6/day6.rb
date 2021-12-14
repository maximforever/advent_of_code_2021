require 'pry'

class FishDaddy
  def initialize(file_name)
    @fish = []
    @total_days_to_observe = 18

    read_file(file_name)
    create_initial_fish
  end

  def read_file(file_name)
    @input_array ||= File.read(file_name).split(",").map(&:to_i)
  end

  def create_initial_fish
    @input_array.each do |days_left|
      @fish << Fish.new(days_left)
    end
  end

  def count_of_fish_after(days)
    print_intro

    days.times do |day|
      print_current_state(day)
      go_to_town
    end

    puts "The total number of fish at the end of day #{days} is #{@fish.size}"
  end

  def go_to_town
    new_fish_to_add = 0

    @fish.each do |fish|
      if fish.days_left == 0
        fish.days_left = 6
        new_fish_to_add += 1
      else
        fish.days_left -= 1
      end
    end

    new_fish_to_add.times do |num|
      make_new_fish
    end
  end

  def make_new_fish
    @fish << Fish.new(8)
  end

  def print_current_state(day)
    fish_array = @fish.map { |fish| "#{fish.days_left},"}
    fish_array = fish_array.join("").slice(0..-2)
    puts "After #{day} days: #{fish_array}"
  end

  def print_intro
    puts "-------"
    puts "When two lanternfish love each other very much..."
    puts "they come together in an intricate, violent, and mildly off-putting mating ritual"
    puts "that involves eggs, gusts of sand, a Norah Jones CD, and baggage-laden poor decisions"
    puts "-------"
  end
end

class Fish
  def initialize(days_left)
    @days_left = days_left
  end

  attr_accessor :days_left
end


fish_daddy = FishDaddy.new('test_input.txt')
fish_daddy.count_of_fish_after(80)