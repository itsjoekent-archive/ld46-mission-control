maze_offset = 64
maze_length = 32

maze_scale = 2
half_maze_scale = maze_scale / 2

walls = {}
wall_color = 7

enemies = {}
objective = {}

player_position = {0, 0}
player_speed = 0.5
player_color = 11

function get_wall(x, y)
  index = (y * maze_length) + x
  return walls[index]
end

function load_maze(index)
  walls = {}
  enemies = {}

  for y=0, maze_length - 1 do
    for x=0, maze_length - 1 do
      index = (y * maze_length) + x

      true_x = base_map_offset_x + x
      true_y = maze_offset + y

      value = sget(x, true_y)
      coords = { x, y }

      if (value == 9) then
        player_position = coords
      elseif (value == 3) then
        objective = coords
      elseif (value == 8) then
        add(enemies, { type = 1, position = coords })
      elseif (value == 1) then
        walls[index] = true
      end
    end
  end
end

function update_maze()
  if (btn(0) and get_wall(flr(player_position[1] - player_speed), player_position[2]) != true) then
    player_position[1] = flr(player_position[1] - player_speed)
  end

  if (btn(1) and get_wall(ceil(player_position[1] + player_speed), player_position[2]) != true) then
    player_position[1] = ceil(player_position[1] + player_speed)
  end

  if (btn(2) and get_wall(player_position[1], flr(player_position[2] - player_speed)) != true) then
    player_position[2] = flr(player_position[2] - player_speed)
  end

  if (btn(3) and get_wall(player_position[1], ceil(player_position[2] + player_speed)) != true) then
    player_position[2] = ceil(player_position[2] + player_speed)
  end
end

function draw_maze(origin_x, origin_y, origin_w, origin_h)
  rectfill(origin_x, origin_y, origin_x + origin_w, origin_y + origin_h, 0)
  clip(origin_x, origin_y, origin_w + 1, origin_h + 1)

  half_origin_w = origin_w / 2
  half_origin_h = (origin_h / 2)

  for unit_y=0, maze_length - 1 do
    for unit_x=0, maze_length -1 do
      is_wall = get_wall(unit_x, unit_y)

      if (is_wall == true) then
        offset_x = unit_x - player_position[1]
        offset_y = unit_y - player_position[2]

        draw_x = ((origin_x + half_origin_w) + (offset_x * maze_scale))
        draw_y = ((origin_y + half_origin_h) + (offset_y * maze_scale))

        rectfill(
          draw_x,
          draw_y,
          draw_x + half_maze_scale,
          draw_y + half_maze_scale,
          wall_color
        )
      end
    end
  end

  player_draw_x = origin_x + half_origin_w
  player_draw_y = origin_y + half_origin_h

  rectfill(
    player_draw_x,
    player_draw_y,
    player_draw_x + half_maze_scale,
    player_draw_y + half_maze_scale,
    player_color
  )

  clip()
end
