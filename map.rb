class Map
  attr_accessor :grid

  def initialize()
    @grid = []
  end

  def add_case(height_id, width_id, data)
    @grid[height_id] ||= []
    @grid[height_id][width_id] = add_symbol(data)
  end

  def add_symbol(data)
    data.blank? ? 'p' : data
  end
end
