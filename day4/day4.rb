require 'pry'

class Bingo
  def initialize(file_name)
    @numbers = []
    @boards = []
    @winning_board = nil
    @current_number = nil
    
    @winning_boards = []
    @last_board_wins = true

    create_boards_and_numbers(file_name)
  end

  def create_boards_and_numbers(file_name)
    board_and_numbers ||= File.read(file_name).split("\n\n")
    @numbers = board_and_numbers[0].split(",")
    board_and_numbers[1..-1].each_with_index do |board_string, index| 
      @boards << Board.new(board_string, index)
    end
  end

  def run_bingo
    mark_number_at_index
    print_last_winning_board if @last_board_wins
  end

  def mark_number_at_index(idx=0)
    @current_number = @numbers[idx]
    puts "running through #{@boards.size} boards"

    @boards.each do |board|
      if @winning_board.nil? 
        board.mark_number_on_board(@current_number) 
        process_winning_board(board) if board.is_winning_board?
      end
    end

    mark_number_at_index(idx + 1) if @winning_board.nil? && (idx + 1) < @numbers.length && @boards.any?
  end

  def process_winning_board(board)
    board.winning_number = @current_number
          
    if @last_board_wins
      @winning_boards << board
      remove_board_with_id(board.id)
    else
      @winning_board = board
      print_winning_data
    end
  end

  def print_last_winning_board
      @winning_board = @winning_boards.last
      puts "------"
      puts "All the boards have been completed"
      puts "Let's take a look at the last winning board"
      puts "------"
      print_winning_data
    end
  end

  def print_winning_data
    puts "==============="
    puts "WINNER WINNER WINNER WHOOOO!!!!!!"
    puts "Got a winning board with the number #{@winning_board.winning_number}"
    puts "The winning score is #{@winning_board.winning_score}"
    puts "==============="
  end

  def remove_board_with_id(id_to_remove)
    puts "removing board #{id_to_remove}"
    @boards = @boards.reject do |board|
      id_to_remove == board.id
    end
  end
end

class Board
  def initialize(board_string, board_id)
    @board = {}
    @id = board_id
    @winning_number = nil

    make_board_from_string(board_string)
  end

  attr_reader :board, :id
  attr_accessor :winning_number

  def make_board_from_string(board_string)
    board_string.split("\n").each_with_index { |row, idx| @board[idx] = row.split(" ")}
  end

  def mark_number_on_board(number)
    @board.keys.each do |row|
      board[row].each_with_index do |element, idx|
        board[row][idx] = "X" if element == number
      end
    end
  end

  def is_winning_board?
    board_has_winning_rows || board_has_winning_columns
  end

  def board_has_winning_rows
    has_winning_row = false
    
    @board.keys.each do |row|
      has_winning_row = true if board[row].join() == "XXXXX"
    end

    has_winning_row
  end

  def board_has_winning_columns
    has_winning_column = false

    @board.keys.size.times do |idx|
      has_winning_column = true if (board[0][idx] == "X" &&
          board[1][idx] == "X" &&
          board[2][idx] == "X" &&
          board[3][idx] == "X" &&
          board[4][idx] == "X")
    end

    has_winning_column
  end

  def winning_score
    if !self.is_winning_board?
      raise "can't calculate winning score without a winning board"
    end

    sum_of_all_unmaked_numbers = 0

    board.keys.each do |row|
      board[row].each do |element|
        if element != "X"
          sum_of_all_unmaked_numbers += element.to_i
        end
      end
    end

    sum_of_all_unmaked_numbers * winning_number.to_i
  end
end


bingo = Bingo.new('input.txt')
bingo.run_bingo