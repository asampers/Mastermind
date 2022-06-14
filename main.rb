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

  @@answer = [nil, nil, nil, nil]
  @@total_guesses = 12

  def initialize(human, computer)
    
  end



  def play
    loop do
      get_guess
      compare_guess

      if player_has_won?(current_guess)
        Display.won
        return
      elsif @total_guesses == 0
        Display.lost
         return 
      end
    end 
  end

  def player_has_won(current_guess)
    @@answer == current_guess
  end

  def comp_pick_answer
    @@answer[0] = COLOR_CODES.sample
    @@answer[1] = COLOR_CODES.sample
    @@answer[2] = COLOR_CODES.sample
    @@answer[3] = COLOR_CODES.sample
    p @@answer
  end
end

class Player 
  def choose_role
    loop do
        puts "Which would you like to do: GUESS or SELECT ?"
        answer = gets.chomp.downcase
        if answer == "guess"
          return "human"
        elsif answer == "select"
          return "computer"
        elsif  
          puts "Please type GUESS or SELECT."
        end
      end
  end

end





