class Board
  attr_accessor :cups

  def initialize(name1, name2)
	  @player1 = name1
    @player2 = name2
	  @cups = []
    place_stones
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
    2.times do 
      6.times { @cups << Array.new(4, :stone) }
      @cups << []
    end
  end

  def valid_move?(start_pos)
    raise "Invalid starting cup" if start_pos < 1 || start_pos > @cups.size-1 || @cups[start_pos].size < 1
  end

  def make_move(start_pos, current_player_name)
    player_hand, @cups[start_pos] = @cups[start_pos], []
    while player_hand.size > 0
      start_pos = (start_pos + 1) % @cups.size
      next if current_player_name == @player1 && start_pos == 13
      next if current_player_name == @player2 && start_pos == 6
      @cups[start_pos] << player_hand.shift
    end

    render
    next_turn(start_pos)
  end

  def next_turn(ending_cup_idx)
    # helper method to determine what #make_move returns
    if ending_cup_idx == 6 || ending_cup_idx == 13
      :prompt
    elsif @cups[ending_cup_idx].length == 1
      :switch
    else
      ending_cup_idx
    end
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def cups_empty?
    return true if @cups[0..5].all? { |cup| cup.empty? } || @cups[7..12].all? { |cup| cup.empty? }
    false
  end

  def winner
    return :draw if @cups[6] == @cups[13]
    return @player1 if @cups[6].size > @cups[13].size
    return @player2 if @cups[13].size > @cups[6].size
  end
end
