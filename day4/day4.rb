require 'pry'

class Bingo
  def initialize(file_name)
    @numbers = []
    @boards = []
    @winning_board = nil
    @current_number = nil

    create_boards_and_numbers(file_name)
  end

  def create_boards_and_numbers(file_name)
    board_and_numbers ||= File.read(file_name).split("\n\n")
    @numbers = board_and_numbers[0].split(",")
    board_and_numbers[1..-1].each do |board_string| 
      @boards << Board.new(board_string)
    end
  end

  def run_bingo
    mark_number_at_index
  end

  def mark_number_at_index(idx=0)
    @current_number = @numbers[idx]

    @boards.each do |board|
      if @winning_board.nil? 
        board.mark_number_on_board(@current_number) 

        if board.is_winning_board?
          @winning_board = board

          puts "WINNER WINNER WINNER WHOOOO!!!!!!"
          puts "got a winning board with the number #{@current_number}"
          puts "the winning score is #{board.winning_score(@current_number)}"
          puts board
          puts "==============="
        end
      end
    end

    mark_number_at_index(idx + 1) if @winning_board.nil? && (idx + 1) < @numbers.length
  end

end

class Board
  def initialize(board_string)
    @board = {}

    make_board_from_string(board_string)
  end

  attr_accessor :board

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

  def winning_score(last_number_called)
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

    sum_of_all_unmaked_numbers * last_number_called.to_i
  end
end


bingo = Bingo.new('input.txt')
bingo.run_bingo