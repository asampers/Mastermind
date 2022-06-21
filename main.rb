module Display

  COLORS = "1. Red 2. Yellow 3. Blue 4. Green 5. Pink 6. White"
  COLOR_CODES = ["R", "Y", "B", "G", "P", "W"]

  def start_game
    puts "Welcome to Mastermind!"
  end

  def rules_for_human_guesser
    puts "There are 6 available colors.
The computer will randomly select a combination of the colors (duplicates are allowed).
You have 12 turns to guess the combination in the correct order.\n"
    puts "The available colors are:\n #{COLORS}"
  end

  def rules_for_computer_guesser
    puts "There are 6 available colors."
    puts "#{COLORS}"
    puts "You will select a combination of these colors (duplicates are allowed)
to place in 4 secret slots. The computer will have 12 turns to guess the combination in the correct order."
  end

  def legal_move(input)
    if input.length != 4 
      puts "Please select 4 letters."
    end
    if input !~ /\A[#{COLOR_CODES}]+\z/  
      puts "Please choose only letters listed in the Options."
    end  
  end

  def lost
    puts "The code stands the test of time. It cannot be broken!"
  end

  def won 
    puts "The code has been broken!"
  end
end 

module GameLogic
  def get_feedback(answer, current_guess)
    temp_answer = answer.clone
    temp_guess = current_guess.clone
    @exact_num = exact_matches(temp_answer, temp_guess)
    @same_num = include_colors(temp_answer, temp_guess)  
    return @exact_num, @same_num
  end
 
  def exact_matches(answer, current_guess)
    exact = 0
    answer.each_with_index.map do |item, i| 
      if current_guess[i] == answer[i]
        current_guess[i] = "X"
        answer[i] = "#{item}+"
        exact += 1 
      end
    end
    exact
  end

  def include_colors(answer, current_guess)
    same = 0
    current_guess.each_with_index.map do |item, i|
      if answer.include?(current_guess[i]) 
        same += 1
        remove = answer.find_index(current_guess[i])
        answer[remove] = "?"
        current_guess[i] = "-"
      end 
    end 
    same 
  end

end

class Game 
  include Display
  include GameLogic

  def initialize(players)
    if players.players[0] == HumanGuesser
      rules_for_human_guesser
    elsif 
      rules_for_computer_guesser
    end    
    @answer = players.players[1].new.pick_answer
    @guesser = players.players[0].new
    @current_guess = ''
  end

  def play
    loop do
      get_guess(@guesser)
      display_feedback(@answer, @current_guess) 

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

  def display_feedback(answer, current_guess)
    get_feedback(answer, current_guess)
    if @exact_num <= 3 && @exact_num > 0
        puts "#{@exact_num}: Correct"
      end 
    if @same_num > 0
      puts "#{@same_num}: Right color, wrong spot"
    end 
    if @guesser.to_s == "ComputerGuesser" 
        @guesser.all_guesses << [current_guess, @exact_num, @same_num]
      end 
    return @exact_num, @same_num 
  end

  def get_guess(guesser)
    if guesser.to_s == "ComputerGuesser" && guesser.total_guesses > 1
      guesser.compare_previous_guesses
    end
    @current_guess = guesser.make_guess
  end

  def clear_guess()
    @current_guess = ""
  end

  def player_has_won?(current_guess)
    @answer.join == current_guess.join
  end

end

class Player 
include Display

  attr_reader :players

  def initialize
    start_game
    choose_role()
  end

  def choose_role
    loop do
      puts "Would you like to be the Code MAKER or BREAKER ?"
      answer = gets.chomp.downcase
        if answer == "breaker" 
          @players = [HumanGuesser, ComputerSelector]
          return @players
        elsif answer == "maker"
          @players = [ComputerGuesser, HumanSelector]
          return @players
        elsif  
          puts "Please type MAKER or BREAKER."
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
    loop do
      puts "Options: #{COLOR_CODES.join(", ")}"
      puts "Enter guess ##{@total_guesses}."
      @guess = gets.chomp.upcase
        if @guess.length == 4 && @guess =~ /\A[#{COLOR_CODES}]+\z/
          break
        elsif  
          legal_move(@guess)
        end  
    end  
    @total_guesses += 1
    return Array(@guess.split(''))
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
  include GameLogic
  attr_reader :exact_num, :same_num, :total_num
  attr_accessor :total_guesses, :all_combinations, :all_guesses

  def initialize
    @total_guesses = 1
    @all_combinations = COLOR_CODES.repeated_permutation(4).to_a
    @all_guesses = []
    @last_guess = []
  end

  def make_guess
    puts "Options: #{COLOR_CODES.join(", ")}"
    puts "Enter guess ##{@total_guesses}."
    @guess = @all_combinations.sample
    @last_guess = @guess.clone.join
    puts @guess.join
    @total_guesses += 1
    return @guess
  end

  def compare_previous_guesses
    @all_guesses.each {|code| run_through(code)}
  end  

  def run_through(code)
    compare_guesses(code[0], code[1], code[2])
  end

  def compare_guesses(code, exact, same)
    @all_combinations.each do |option|
      get_feedback(option, code)
      reduce_options(option) unless @exact_num == exact && @same_num == same
    end  
  end

  def reduce_options(guess)
    @all_combinations.reject! do |option|
      option == guess
    end  
  end

  def to_s
    "ComputerGuesser"
  end

end

class HumanSelector 
  include Display

  def pick_answer
    loop do
      puts "Options: #{COLOR_CODES.join(", ")}"
      puts "Enter the secret code."
      @answer = gets.chomp.upcase
        if @answer.length == 4 && @answer =~ /\A[#{COLOR_CODES}]+\z/
          break
        elsif  
          legal_move(@answer)
        end 
    end   
    @answer = Array(@answer.split(''))
  end

end

Game.new(Player.new).play
