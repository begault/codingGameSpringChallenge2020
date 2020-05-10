class Pellet
  attr_accessor :value, :position_x, :position_y

  def initialize(value, x, y)
    @value = value
    @position_x = x
    @position_y = y
  end
end
