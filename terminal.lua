maze_offset = 64
maze_length = 32

maze_scale = 2
half_maze_scale = maze_scale / 2

walls = {}
wall_color = {7, 6, 5}

enemies = {}
enemy_color = 3

objective = {100, 100}
objective_color = 11

player_position = {0, 0}
player_speed = 0.25
player_color = 11

active_maze = 0

stop_terminal_update = false

started_loading_at = 0
load_time = 3

started_playing_at = 0
play_timer = 30

function get_wall(x, y)
  if (x < 0 or x > maze_length or y < 0 or y > maze_length) then
    return nil
  end

  index = (y * maze_length) + x
  return walls[index]
end

function is_enemy(x, y)
  if (x < 0 or x > maze_length or y < 0 or y > maze_length) then
    return nil
  end

  index = (y * maze_length) + x
  return enemies[index]
end

function load_maze(index)
  active_maze = index
  started_loading_at = t()
  started_playing_at = 0
  stop_terminal_update = false

  walls = {}
  enemies = {}

  for y=0, maze_length - 1 do
    for x=0, maze_length - 1 do
      index = (y * maze_length) + x

      true_x = (active_maze * maze_length) + x
      true_y = maze_offset + y

      value = sget(true_x, true_y)
      coords = { x, y }

      if (value == 9) then
        player_position = coords
      elseif (value == 3) then
        objective = coords
      elseif (value == 8) then
        enemies[index] = { type = 1, position = coords, spawned_at = 0 }
      elseif (value == 1) then
        walls[index] = true
      end
    end
  end
end

function update_maze()
  if (stop_terminal_update == true) then return end

  if (started_loading_at > 0) then
    if (t() - (started_loading_at + load_time) >=0 and btnp(4)) then
      started_loading_at = 0
      started_playing_at = t()
    end

    return
  end

  if ((started_playing_at + play_timer) <= t()) then
    stop_terminal_update = true
    lose_game()
  end

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

  goal_distance = vector_magnitude(vector_subtract(objective, player_position))

  astro_target = active_maze + 1
  set_astro_animation(astro_target, 2)

  if (goal_distance > 8) then set_astro_animation(astro_target, 3) end
  if (goal_distance > 16) then set_astro_animation(astro_target, 4) end
  if (goal_distance > 24) then set_astro_animation(astro_target, 5) end

  if (goal_distance < 2) then
    if (active_maze == 2) then
      stop_terminal_update = true
      win_game()
    else
      load_maze(active_maze + 1)
    end
  end
end

function draw_maze(origin_x, origin_y, origin_w, origin_h)
  rectfill(origin_x, origin_y, origin_x + origin_w, origin_y + origin_h, 0)
  clip(origin_x, origin_y, origin_w + 1, origin_h + 1)

  if (started_loading_at > 0) then
    print("connecting", origin_x + 1, origin_y + 2, 7)
    filled = min(1 - (((started_loading_at + load_time) - t()) / load_time), 1)
    loading_bar_w = (origin_w - 2) * filled

    rectfill(origin_x + 1, origin_y + (origin_h / 2), origin_x + 1 + loading_bar_w, origin_y + (origin_h / 2) + 2, 7)

    if (filled >= 1) then
      print("press z", origin_x + 1, origin_y + (origin_h / 2) + 4, 11)
    end
    return
  end

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

        distance = vector_magnitude({ offset_x, offset_y })
        color = wall_color[1]

        if (distance > 4) then color = wall_color[2] end
        if (distance > 8) then color = wall_color[3] end

        rectfill(
          draw_x,
          draw_y,
          draw_x + half_maze_scale,
          draw_y + half_maze_scale,
          color
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

  goal_distance = vector_magnitude(vector_subtract(objective, player_position))
  if (goal_distance < 5) then
    offset_x = objective[1] - player_position[1]
    offset_y = objective[2] - player_position[2]

    draw_x = ((origin_x + half_origin_w) + (offset_x * maze_scale))
    draw_y = ((origin_y + half_origin_h) + (offset_y * maze_scale))

    rectfill(
      draw_x,
      draw_y,
      draw_x + half_maze_scale,
      draw_y + half_maze_scale,
      objective_color
    )
  end

  clip()
end
