STDOUT.sync = true # DO NOT REMOVE
# Grab the pellets as fast as you can!

require_relative 'core_ext/string'
require_relative 'map'
require_relative 'pacman'
require_relative 'enemy'
require_relative 'pellet'
require_relative 'turn'

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
