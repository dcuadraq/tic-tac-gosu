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

  def cursors
    image = "#{@tic_tac_doh.who_is_next[:mark]}.png"
    @x = Gosu::Image.new(self, image, true)
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
      cursors
    end
  end

  def position
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
    message = @tic_tac_doh.winner ? "#{@tic_tac_doh.winner[:nickname]} won" : "Losers!"
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
