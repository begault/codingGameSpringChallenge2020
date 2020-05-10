STDOUT.sync = true # DO NOT REMOVE
# Grab the pellets as fast as you can!

class String
  def blank?
    self.strip.empty?
  end
end

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

# width: size of the grid
# height: top left corner is (x=0, y=0)
width, height = gets.split(" ").collect {|x| x.to_i}
STDERR.puts "width: #{width}"
STDERR.puts "height: #{height}"

map = Map.new

height.times do |height_id|
  row = gets.chomp # one line of the grid: space " " is floor, pound "#" is wall
  width.times do |width_id|
    map.add_case(height_id, width_id, row[width_id])
  end
end

STDERR.puts "Map: #{map.grid}"

class Pellet
  attr_accessor :value, :position_x, :position_y

  def initialize(value, x, y)
    @value = value
    @position_x = x
    @position_y = y
  end
end

class Enemy
  def initialize(id, x, y)
    @id = id
    @position_x = x
    @position_y = y
  end
end

class Pacman
  attr_accessor :id, :position_x, :position_y

  def initialize(id, x, y)
    @id = id
    @position_x = x
    @position_y = y
  end
end

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

# game loop
loop do
    my_score, opponent_score = gets.split(" ").collect {|x| x.to_i}
    visible_pacman_count = gets.to_i # all your pacs and enemy pacs in sight

    turn = Turn.new
    directions = []

    visible_pacman_count.times do
        # pacman_id: pac number (unique within a team)
        # is_mine: true if this pac is yours
        # position_x: position in the grid
        # position_y: position in the grid
        # type_id: unused in wood leagues
        # speed_turns_left: unused in wood leagues
        # ability_cooldown: unused in wood leagues
        pacman_id,
        is_mine,
        position_x,
        position_y,
        _type_id,
        _speed_turns_left,
        _ability_cooldown = gets.split(" ")

        pacman_id = pacman_id.to_i
        is_mine = is_mine.to_i == 1

        position_x = position_x.to_i
        position_y = position_y.to_i
        speed_turns_left = speed_turns_left.to_i
        ability_cooldown = ability_cooldown.to_i

        if is_mine
          pacman = Pacman.new(pacman_id, position_x, position_y)
          turn.add_pacman(pacman)
        else
          enemy = Enemy.new(pacman_id, position_x, position_y)
          turn.add_enemy(enemy)
        end
    end

    visible_pellet_count = gets.to_i # all pellets in sight

    value_best_pellet = 0
    visible_pellet_count.times do
      # value: amount of points this pellet is worth
      x, y, value = gets.split(" ").collect {|x| x.to_i}

      pellet = Pellet.new(value, x, y)
      turn.add_pellet(pellet)

      if pellet.value == 10
        turn.add_big_pellet(pellet)
      end
    end

    movements = turn.get_movements

    # Write an action using puts
    # To debug: STDERR.puts "Debug messages..."
    puts turn.get_movements_string
end
