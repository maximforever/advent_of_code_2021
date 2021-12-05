require 'pry'

class Farm
  def initialize(farm_name)
    @animals = []
    @farm_name = farm_name
    spawn_animals
  end

  def spawn_animals
    cow = Animal.new("cow")
    sheep = Animal.new("sheep")

    @animals << cow 
    @animals << sheep
  end

  def say_animal_names
    puts "Welcome to #{@farm_name}! Come meet our animals:"
    @animals.each { |animal| animal.say_name}
  end
end

class Animal
  def initialize(name)
    @name = name
  end

  attr_accessor :name  #this lets us rename the animal

  def say_name
    puts "Hello, I am #{@name}"
  end

  # def rename(name)
  #   @name = name
  # end
end

farm = Farm.new("Max's Frolick-y Farm")
farm.say_animal_names