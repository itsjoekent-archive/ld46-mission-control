title_sprite_x = 72
title_sprite_y = 32
title_sprite_w = 56
title_sprite_h = 18

title_width = title_sprite_w * 2
title_height = title_sprite_h * 2

function update_menu(stage_ticks)
  if (btnp(4)) then
    if (has_intro_text_started == true) then
      start_game()
    else
      start_narration()
    end
  end
end

function draw_menu(stage_ticks)
  rectfill(0, 0, 127, 127, 0)
  rect(0, 0, 127, 127, 14)

  sspr(
    title_sprite_x,
    title_sprite_y,
    title_sprite_w,
    title_sprite_h,
    (127 / 2) - (title_width / 2) + 1,
    (127 / 2) - (title_height / 2),
    title_width,
    title_height
  )

  instruction = "press z to start"
  credit = "made for ld46 by @itsjoekent"

  print(instruction, ((127 / 2) - (#instruction * 4) / 2), (127 / 2) + title_height + 8, 7)
  print(credit, ((127 / 2) - (#credit * 4) / 2), (127 / 2) + title_height + 16, 7)
end
