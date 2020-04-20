speech_bubble_text = {}

arrow_sprite = 36

speech_bubble_background_color = 7
speech_bubble_outline_color = 12
speech_bubble_text_color = 1
speech_bubble_x_offset = 2
speech_bubble_y_offset = 2

speech_bubble_y = 64

speech_bubble_callback = nil

function reset_speech_bubble()
  speech_bubble_ticks = 0
  speech_bubble_text = {}
  speech_bubble_callback = nil
end

function set_speech_bubble(text, y, callback)
  speech_bubble_ticks = 0
  speech_bubble_text = text
  speech_bubble_y = y
  speech_bubble_callback = callback
end

function update_speech_bubble()
  if (btnp(4) and speech_bubble_callback != nil) then
    speech_bubble_callback()
  end
end

function draw_speech_bubble()
  if (#speech_bubble_text == 0) then
    return
  end

  height = (#speech_bubble_text * 6) + (#speech_bubble_text * 2)

  rectfill(0, speech_bubble_y, 127, speech_bubble_y + height, speech_bubble_background_color)
  rect(0, speech_bubble_y, 127, speech_bubble_y + height, speech_bubble_outline_color)
  spr(arrow_sprite, 24, speech_bubble_y + height + 1)

  for index=1, #speech_bubble_text do
    line_y = (((index - 1) * 6) + 2) + speech_bubble_y + speech_bubble_y_offset

    print(speech_bubble_text[index], speech_bubble_x_offset, line_y, speech_bubble_text_color)
  end
end

function intro_dialogue_1()
  set_speech_bubble({"Mission Control,", "we have a problem with launch", "(press z to continue)"}, 32, intro_dialogue_2)
end

function intro_dialogue_2()
  set_speech_bubble({"Martians installed a virus", "on the rocket"}, 32, intro_dialogue_3)
end

function intro_dialogue_3()
  set_speech_bubble({"We need you to repair our", "terminals before the rocket", "explodes..."}, 32, intro_dialogue_4)
end

function intro_dialogue_4()
  set_speech_bubble({"We can help until our comms - ", "...",  "..."}, 32, intro_dialogue_end)
end

function intro_dialogue_end()
  reset_speech_bubble()
  start_game()
end
