STDOUT.sync = true # DO NOT REMOVE
# Grab the pellets as fast as you can!

# width: size of the grid
# height: top left corner is (x=0, y=0)
width, height = gets.split(" ").collect {|x| x.to_i}
STDERR.puts "width: #{width}"
STDERR.puts "height: #{height}"
height.times do
    row = gets.chomp # one line of the grid: space " " is floor, pound "#" is wall
end

# game loop
loop do
    my_score, opponent_score = gets.split(" ").collect {|x| x.to_i}
    visible_pacman_count = gets.to_i # all your pacs and enemy pacs in sight

    directions = [] # pacmans directions to go
    my_pacmans = []

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
        next unless is_mine

        position_x = position_x.to_i
        position_y = position_y.to_i
        #speed_turns_left = speed_turns_left.to_i
        #ability_cooldown = ability_cooldown.to_i
        my_pacmans << pacman_id if is_mine
    end

    visible_pellet_count = gets.to_i # all pellets in sight

    value_best_pellet = 0
    visible_pellet_count.times do
        # value: amount of points this pellet is worth
        x, y, value = gets.split(" ").collect {|x| x.to_i}
        if value > value_best_pellet
          directions[my_pacmans.first] ||= {}
          directions[my_pacmans.first]['x'] = x
          directions[my_pacmans.first]['y'] = y
          value_best_pellet = value
        end
    end

    # Write an action using puts
    # To debug: STDERR.puts "Debug messages..."

    puts "MOVE #{my_pacmans.first} #{directions[my_pacmans.first]['x']} #{directions[my_pacmans.first]['y']}" # MOVE <pacId> <x> <y>
end
