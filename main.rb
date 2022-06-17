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
    @answer = players.players[1].new.pick_answer
    p @answer.join
    #p @answer.uniq
    @guesser = players.players[0].new
    @current_guess = ''
  end

  def play
    loop do
      get_guess(@guesser)
      display_feedback(@current_guess, @answer)

      if player_has_won?(@current_guess)
        puts "#{@answer.join}: Code"
        won()
        return
      elsif @guesser.total_guesses == 12
        puts "#{@answer.join}: Code"
        lost()
        return 
      end

      clear_guess()
    end 
  end

  def get_guess(guesser)
    @current_guess = guesser.make_guess
  end


  def display_feedback(current_guess, answer)
    @feedback = Array(current_guess.split(''))
    @correct_colors = 0
    @half_correct_colors = 0
    get_feedback(@feedback, answer, @correct_colors, @half_correct_colors)
    return current_guess
  end

  def get_feedback(feedback, answer, correct_colors, half_correct_colors)
    answer.each_with_index.map do |item, i| 
      if feedback[i] == answer[i]
        feedback[i] = "X"
        answer[i] = "#{item}+"
        correct_colors += 1 
      end
    end

  feedback.each_with_index.map do |item, i|
    if feedback.include?(answer[i]) 
      half_correct_colors += 1
    end 
  end

    answer.map do |item|
      item.gsub!("+", "")
    end  

    if correct_colors <= 3 && correct_colors > 0
      puts "#{correct_colors}: Correct"
    end 
    if half_correct_colors > 0
      puts "#{half_correct_colors}: Right color, wrong spot"
    end  
    return feedback
  end

  def clear_guess()
    @current_guess = ""
  end

  def player_has_won?(current_guess)
    @answer.join == current_guess
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
          @players = [ComputerGuesser, HumanSelector]
          puts "The players are #{players}."
          return [ComputerGuesser, HumanSelector]
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
  include Display
  attr_accessor :total_guesses

  def initialize
    @total_guesses = 1
  end

  def make_guess
    puts "Options: #{COLOR_CODES.join(", ")}"
    puts "Enter guess ##{@total_guesses}."
    @guess = gets.chomp.upcase
    @total_guesses += 1
    return @guess
  end

end

class ComputerSelector 
  include Display

  def pick_answer
    @answer = [nil, nil, nil, nil]
    @answer[0] = COLOR_CODES.sample
    @answer[1] = COLOR_CODES.sample
    @answer[2] = COLOR_CODES.sample
    @answer[3] = COLOR_CODES.sample
    @answer
  end


end

class ComputerGuesser 
  include Display
  attr_accessor :total_guesses

  def initialize
    @total_guesses = 1
  end

  def make_guess
    puts "Options: #{COLOR_CODES.join(", ")}"
    puts "Enter guess ##{@total_guesses}."
    @guess = COLOR_CODES.sample + COLOR_CODES.sample + COLOR_CODES.sample + COLOR_CODES.sample
    puts @guess
    @total_guesses += 1
    return @guess
  end

end

class HumanSelector 
  include Display

  def pick_answer
    puts "Options: #{COLOR_CODES.join(", ")}"
    puts "Enter the secret code."
    @answer = gets.chomp.upcase
    @answer = Array(@answer.split(''))
  end


end

Game.new(Player.new).play
