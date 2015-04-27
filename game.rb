require 'gosu'
require 'tic_tac_doh'

class TicTacToe < Gosu::Window
  def initialize
    super 500, 400, false
    self.caption = "Tic Tac Toe [a.k.a. Gato]"
    @board_image = Gosu::Image.new(self, "tic_bck_400x400.png", true)
    tic_tac_toe
    set_players
    cursors
    @xs = []
    @os = []
  end

  def tic_tac_toe
    @tic_tac_doh = TicTacDoh::Game.new()
    @tic_tac_doh.set_board_size(3)
  end

  def set_players
    @tic_tac_doh.add_player(nickname: 'Player 1', mark: 'x')
    @tic_tac_doh.add_player(nickname: 'Player 2', mark: 'o')
  end

  # def draw_grip
  #   cell_number = 0
  #   @tic_tac_doh.grip.each do |row|
  #     row.each do |cell|
  #       unless cell is_a? Numeric
  #         draw_cell cell_number cell
  #       end
  #       cell_number += 1
  #     end
  #   end
  # end

  # def draw_cell(cell_number, mark)
  #   row = 0
  #     for n in 0..cell_number
  #       row += 1 if (n % grid.size) == 0 unless n == 0
  #     end
  #     column = cell_number - (row * grid.size)
  #     if mark == 'x'

  #     {row: row, column: column}
  # end

  # def print_grid
  #   max_digits = (@game.grid.size * @game.grid.size - 1).to_s.size
  #   @game.grid.each do |row|
  #     line = []
  #     row.each do |cell|
  #       if cell.is_a? Numeric
  #         line << cell.to_s.rjust(max_digits, '0')
  #       else
  #         line << cell.to_s.center(max_digits)
  #       end
  #     end
  #     puts line.join('|')
  #   end
  # end

  # def play
  #   match
  #   puts "#{@game.winner[:nickname]} won"
  #   puts "Another match? no to quit"
  #   @game.reset
  # end

  # def match
  #   until @game.game_over?
  #     puts "#{@game.who_is_next[:nickname]}'s turn"
  #     next_turn
  #   end
  # end

  # def next_turn
  #   @game.next_turn(0)
  # end

  def cursors
    @x = Gosu::Image.new(self, "x.png", true)
    @x_x = 10
    @x_y = 15
  end

  def move_current_cursor direction
    @x_x -= 145 if direction == :left if @x_x > 10
    @x_x += 145 if direction == :right if @x_x < 300
    @x_y -= 145 if direction == :up if @x_y > 15
    @x_y += 145 if direction == :down if @x_y < 305
  end

  def insert_mark
    if @tic_tac_doh.next_turn(position)
      @xs << { image: Gosu::Image.new(self, "x.png", true), x: @x_x, y: @x_y } unless @tic_tac_doh.who_is_next[:mark] == 'x'
      @os << { image: Gosu::Image.new(self, "o.png", true), x: @x_x, y: @x_y } unless @tic_tac_doh.who_is_next[:mark] == 'o'
    end
  end

  def position
    # 10  155 300
    # 15  160 305
    col = case @x_x
          when 10
            0
          when 155
            1
          when 300
            2
          end
    row = case @x_y
          when 15
            0
          when 160
            1
          when 305
            2
          end
    (row * 3) + col
  end

  def game_over_message
    message = @tic_tac_doh.winner ? "#{@tic_tac_doh.winner[:nickname]} won" : "Draw"
    @image = Gosu::Image.from_text(self, message, Gosu.default_font_name, 100)
  end

  def button_down id
    close if id == Gosu::KbEscape
    move_current_cursor :left   if id == Gosu::KbLeft
    move_current_cursor :right  if id == Gosu::KbRight
    move_current_cursor :up     if id == Gosu::KbUp
    move_current_cursor :down   if id == Gosu::KbDown
    insert_mark                 if id == Gosu::KbSpace
  end

  def update
    if @tic_tac_doh.game_over?
      game_over_message
    end
  end

  def draw
    if @tic_tac_doh.game_over?
      @image.draw 0, 0, 0 
    else
      @board_image.draw 0, 0, 0
      @x.draw @x_x, @x_y, 0
      @xs.each { |x| x[:image].draw x[:x], x[:y], 0 }
      @os.each { |o| o[:image].draw o[:x], o[:y], 0 }
    end
  end
end

window = TicTacToe.new
window.show
