module Display

  COLORS = "1. Red\n 2. Yellow\n 3. Blue\n 4. Green\n 5. Pink\n 6. White"
  COLOR_CODES = ["R", "Y", "B", "G", "P", "W"]

  def start_game
    puts "Welcome to Mastermind!"
  end

  def rules_for_human_guesser
    puts "There are 6 available colors.\n 
    The computer will randomly select a combination of the colors (duplicates are allowed).\n
    You have 12 turns to guess the combination in the correct order.\n
    'O' = means you've guessed the correct color in the correct spot.\n
    '?' = means you've guessed the correct color but wrong spot.\n
    'X' = means that color is not part of the answer."
    puts "The available colors are:\n #{COLORS}"
  end

  def rules_for_computer_guesser
    puts "There are 6 available colors."
    puts "#{COLORS}"
    puts "You will select a combination of these colors (duplicates are allowed)\n
    to place in 4 secret slots. The computer will have 12 turns to guess the 
    combination in the correct order.\n
    'O' = means it guessed the correct color in the correct spot.\n
    '?' = means it guessed the correct color but wrong spot.\n
    'X' = means that color is not part of the answer."
  end

  def correct
    "O"
  end

  def half_correct
    "?"
  end

  def incorrect
    'X'
  end

  def lost
    puts "Sorry, no more guesses. You lost."
  end

  def won 
    puts "Congrats! You won!"
  end
end 

class Game 
  include Display


  def initialize(players)
    @answer = players.players[1].new.comp_pick_answer.join
    p @answer
    @guesser =  players.players[0].new
    @current_guess = ''
  end



  def play
    loop do
      puts get_guess(@guesser)
      #display_feedback

      if player_has_won?(@current_guess)
        won()
        return
      elsif @guesser.total_guesses == 0
        lost()
        return 
      end

      clear_guess()
    end 
  end

  def get_guess(guesser)
    @current_guess = guesser.make_guess
  end

  def clear_guess()
    @current_guess = ""
  end

  def player_has_won?(current_guess)
    @answer == current_guess
  end

end

class Player 

  attr_reader :players

  def initialize
    choose_role()
  end

  def choose_role
    loop do
      puts "Which would you like to do: GUESS or SELECT ?"
      answer = gets.chomp.downcase
        if answer == "guess" 
          @players = [HumanGuesser, ComputerSelector]
          puts "The players are #{players}."
          return HumanGuesser, ComputerSelector
        elsif answer == "select"
          return
        elsif  
          puts "Please type GUESS or SELECT."
        end
    end
  end

  def to_s
    @players
  end

end

class HumanGuesser 
  attr_accessor :total_guesses

  def initialize
    @total_guesses = 12
  end

  def make_guess
    puts "Enter your guess."
    @guess = gets.chomp.upcase
    @total_guesses -= 1
    return @guess
  end

end

class ComputerSelector 
  include Display

  def comp_pick_answer
    @answer = [nil, nil, nil, nil]
    @answer[0] = COLOR_CODES.sample
    @answer[1] = COLOR_CODES.sample
    @answer[2] = COLOR_CODES.sample
    @answer[3] = COLOR_CODES.sample
    @answer
  end


end

Game.new(Player.new).play
