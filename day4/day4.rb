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
    board_and_numbers[1..-1].each { |board_string| @boards << make_board_from_string(board_string) }
  end

  def make_board_from_string(board_string)
    board = {}
    board_string.split("\n").each_with_index { |row, idx| board[idx] = row.split(" ")}
    board
  end

  def run_bingo
    mark_number_at_index
  end

  def mark_number_at_index(idx=0)
    @current_number = @numbers[idx]

    @boards.each do |board|
      mark_number_on_board(board) if @winning_board.nil? 
    end

    mark_number_at_index(idx + 1) if @winning_board.nil? && (idx + 1) < @numbers.length
  end

  def mark_number_on_board(board)
    board.keys.each do |row|
      board[row].each_with_index do |element, idx|
        board[row][idx] = "X" if element == @current_number
      end
    end

    check_if_winning_board(board)
  end

  def check_if_winning_board(board)
    winning = false

    if board_has_winning_rows(board) || board_has_winning_columns(board) 
      @winning_board = board

      puts "WINNER WINNER WINNER WHOOOO!!!!!!"
      puts "got a winning board with the number #{@current_number}"
      puts "the winning score is #{calculate_winning_board_score}"
      puts board
      puts "==============="
    end
  end

  def board_has_winning_rows(board)
    winning = false
    board.keys.each do |row|
      winning = true if board[row].join() == "XXXXX"
    end

    winning
  end

  def board_has_winning_columns(board)
    winning = false

    board.keys.size.times do |idx|
      winning = true if (board[0][idx] == "X" &&
          board[1][idx] == "X" &&
          board[2][idx] == "X" &&
          board[3][idx] == "X" &&
          board[4][idx] == "X")
    end

    winning
  end

  def calculate_winning_board_score
    if @winning_board.nil?
      raise "can't generate board data without a winning board"
    end

    sum_of_all_unmaked_numbers = 0

    @winning_board.keys.each do |row|
      @winning_board[row].each do |element|
        if element != "X"
          sum_of_all_unmaked_numbers += element.to_i
        end
      end
    end

    sum_of_all_unmaked_numbers * @current_number.to_i
  end
end

class Board
  def initiatilze
  end
end


bingo = Bingo.new('input.txt')
bingo.run_bingo