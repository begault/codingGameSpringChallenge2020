class Turn
  def initialize()
    @pellets ||= []
    @big_pellets ||= []
    @pacmans ||= []
    @enemies ||= []
    @movements ||= {}
    @taken_pellets ||= []
  end

  def add_pellet(pellet)
    @pellets << pellet
  end

  def add_big_pellet(pellet)
    @big_pellets << pellet
  end

  def add_enemy(enemy)
    @enemies << enemy
  end

  def add_pacman(pacman)
    @pacmans << pacman
  end

  def get_movements
    each_pacman do |pacman|
      STDERR.puts "pacman: #{pacman.id}"
      big_count = @big_pellets.size
      choose_movement(pacman)
    end

    @movements
  end

  def choose_movement(pacman)
    @movements[pacman.id] ||= {}
    pellet = nil

    if [0, 1].include?(pacman.id)
      pellet = closest_big_pellet(pacman)
      STDERR.puts "Big pellet: #{pellet}"
      add_movement(pacman, pellet) if pellet
    end

    unless pellet
      pellet = closest_small_pellet(pacman)
      STDERR.puts "Small pellet: #{pellet}"
      add_movement(pacman, pellet)
    end
  end

  def add_movement(pacman, pellet)
    @movements[pacman.id]['x'] = pellet.position_x
    @movements[pacman.id]['y'] = pellet.position_y
    STDERR.puts "Movement: #{@movements[pacman.id]}"
    @taken_pellets << pellet
  end

  def get_movements_string
    get_movements.map do |movement|
      ['MOVE', movement[0], movement[1]['x'], movement[1]['y']].join(' ')
    end.join(' | ')
  end

  private

  def closest_small_pellet(pacman)
    (@pellets - @taken_pellets)
      .sort_by { |pellet| distance(pacman, pellet) }
      .first
  end

  def closest_big_pellet(pacman)
    (@big_pellets - @taken_pellets)
      .sort_by { |pellet| distance(pacman, pellet) }
      .first
  end

  def number_of_pellets
    @pellets.size
  end

  def distance(pacman, pellet)
    x_distance = (pacman.position_x - pellet.position_x).abs
    y_distance = (pacman.position_y - pellet.position_y).abs
    Math.sqrt(x_distance.abs2 + y_distance.abs2)
  end

  def each_pellet
    @pellets.each do |pellet|
      yield pellet
    end
  end

  def each_pacman
    STDERR.puts "Pacman count: #{@pacmans.size}"
    @pacmans.each do |pacman|
      yield pacman
    end
  end
end
