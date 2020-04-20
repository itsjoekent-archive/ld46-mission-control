central_display_width = 121
central_display_height = 32
central_display_x = (128 - central_display_width) / 2
central_display_outline_color = 1

central_display_title_width = title_sprite_w
central_display_title_height = title_sprite_h

central_display_astro_size = central_display_height / 2
central_display_timer_color = 8

floor_y = central_display_height + 24

side_terminal_sprites = {{0, 32}, {0, 48}}
side_terminal_frame = {1, 2}
side_terminal_y = floor_y - 8
side_terminal_gutter = 8
side_terminal_animation_ticks = 0

main_terminal_sprites = {{16, 32}, {32, 32}}
main_terminal_sprite_width = 48
main_terminal_width = main_terminal_sprite_width * 3
main_terminal_x = (128 / 2) - (main_terminal_width / 2)
main_terminal_y = 128 - main_terminal_sprite_width

main_terminal_decor = {{16, 48}, {32, 48}}

function init_mission_control()
  set_astro_animation(1, 2)
  set_astro_animation(2, 2)
  set_astro_animation(3, 2)
end

function update_mission_control()
  side_terminal_animation_ticks += 1

  if (side_terminal_animation_ticks > 10) then
    side_terminal_animation_ticks = 0

    side_terminal_frame[1] += 1
    side_terminal_frame[2] += 1

    if (side_terminal_frame[1] > 2) then side_terminal_frame[1] = 1 end
    if (side_terminal_frame[2] > 2) then side_terminal_frame[2] = 1 end
  end
end

function draw_mission_control()
  -- wall
  rectfill(0, 0, 127, 127, 13)

  -- floor divider
  rectfill(0, floor_y, 127, floor_y, 0)

  -- floor
  rectfill(0, floor_y + 1, 127, 127, 5)

  -- central display
  rectfill(central_display_x, 0, central_display_x + central_display_width, central_display_height, 0)
  rect(central_display_x, -1, central_display_x + central_display_width, central_display_height, central_display_outline_color)
  rect(central_display_x - 1, -1, central_display_x + central_display_width + 1, central_display_height + 1, central_display_outline_color)

  sspr(
    title_sprite_x,
    title_sprite_y,
    title_sprite_w,
    title_sprite_h,
    (127 / 2) - (central_display_title_width / 2) + 1,
    central_display_height + 4,
    central_display_title_width,
    central_display_title_height
  )

  time_left = tostring(max(flr((started_playing_at + play_timer) - t()), 0))
  time_left_half_width = ((#time_left * 4) / 2) - 1
  time_left_offset = (central_display_astro_size / 2) - time_left_half_width

  astro_1_x = central_display_x + 8

  draw_astro(
    1,
    astro_1_x,
    16,
    central_display_astro_size,
    central_display_astro_size
  )

  if (started_playing_at > 0 and active_maze == 0) then
    print(time_left, astro_1_x + time_left_offset, 8, central_display_timer_color)
  end

  astro_2_x = astro_1_x + central_display_astro_size + 8

  draw_astro(
    2,
    astro_2_x,
    16,
    central_display_astro_size,
    central_display_astro_size
  )

  if (started_playing_at > 0 and active_maze == 1) then
    print(time_left, astro_2_x + time_left_offset, 8, central_display_timer_color)
  end

  astro_3_x = astro_2_x + central_display_astro_size + 8

  draw_astro(
    3,
    astro_3_x,
    16,
    central_display_astro_size,
    central_display_astro_size
  )

  if (started_playing_at > 0 and active_maze == 2) then
    print(time_left, astro_3_x + time_left_offset, 8, central_display_timer_color)
  end

  sspr(
    side_terminal_sprites[side_terminal_frame[1]][1],
    side_terminal_sprites[side_terminal_frame[1]][2],
    16,
    16,
    0,
    side_terminal_y,
    32,
    32
  )

  sspr(
    side_terminal_sprites[side_terminal_frame[2]][1],
    side_terminal_sprites[side_terminal_frame[2]][2],
    16,
    16,
    128 - 32,
    side_terminal_y,
    32,
    32,
    true
  )

  sign = 'flight director'
  rectfill(
    main_terminal_x + 20,
    main_terminal_y + 2,
    main_terminal_x + 20 + (#sign * 4) + 2,
    main_terminal_y - 4,
    7
  )

  print(sign, main_terminal_x + 22, main_terminal_y - 3, 1)

  sspr(
    main_terminal_sprites[1][1],
    main_terminal_sprites[1][2],
    16,
    16,
    main_terminal_x,
    main_terminal_y,
    main_terminal_sprite_width,
    main_terminal_sprite_width
  )

  sspr(
    main_terminal_sprites[2][1],
    main_terminal_sprites[2][2],
    16,
    16,
    main_terminal_x + main_terminal_sprite_width,
    main_terminal_y,
    main_terminal_sprite_width,
    main_terminal_sprite_width
  )

  sspr(
    main_terminal_sprites[1][1],
    main_terminal_sprites[1][2],
    16,
    16,
    main_terminal_x + (main_terminal_sprite_width * 2),
    main_terminal_y,
    main_terminal_sprite_width,
    main_terminal_sprite_width,
    true
  )

  sspr(
    main_terminal_decor[2][1],
    main_terminal_decor[2][2],
    16,
    16,
    main_terminal_x,
    main_terminal_y,
    main_terminal_sprite_width,
    main_terminal_sprite_width
  )

  sspr(
    main_terminal_decor[1][1],
    main_terminal_decor[1][2],
    16,
    16,
    main_terminal_x + (main_terminal_sprite_width * 2),
    main_terminal_y,
    main_terminal_sprite_width,
    main_terminal_sprite_width,
    true
  )

  draw_maze(
    main_terminal_x + main_terminal_sprite_width + 3,
    main_terminal_y + 3,
    main_terminal_sprite_width - 7,
    23
  )
end
