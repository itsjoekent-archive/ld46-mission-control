-- TODO

-- nice to have
-- [ ] people walking around mission control, people typing
-- [ ] spaceship/visualization on the mission control tv
-- [ ] smoke particles under ship for intro sequence

-- stages
-- 1 = menu
-- 2 = intro
-- 3 = game
-- 4 = explosion
-- 5 = liftoff
stage = 1
stage_ticks = 0

started_fading_at = 0
fade_target = 0

has_intro_text_started = false

function tostring(any)
    if type(any)=="function" then
        return "function"
    end
    if any==nil then
        return "nil"
    end
    if type(any)=="string" then
        return any
    end
    if type(any)=="boolean" then
        if any then return "true" end
        return "false"
    end
    if type(any)=="table" then
        local str = "{ "
        for k,v in pairs(any) do
            str=str..tostring(k).."->"..tostring(v).." "
        end
        return str.."}"
    end
    if type(any)=="number" then
        return ""..any
    end
    return "unkown" -- should never show
end

function _init()
  generate_planet_terrain()
end

function start_narration()
  fade_target = 2
  started_fading_at = t()
end

function start_game()
  fade_target = 3
  started_fading_at = t()
  load_maze(0)
  init_mission_control()
  music(0)
end

function win_game()
  spaceship_animation_ticks = 0
  fade_target = 5
  started_fading_at = t()
  music(-1)
end

function lose_game()
  spaceship_animation_ticks = 0
  fade_target = 4
  started_fading_at = t()
  music(-1)
end

function return_to_menu()
  fade_target = 1
  started_fading_at = t()
end

function _update()
  stage_ticks += 1
  animation_ticks += 1

  if (animation_ticks > 30) then
    animation_ticks = 0
  end

  if (stage == 1) then
    update_menu(stage_ticks)
  end

  if (stage == 2 and has_intro_text_started == false and stage_ticks > 120) then
    has_intro_text_started = true
    set_astro_animation(1, 1)
    intro_dialogue_1()
  end

  if (stage == 2 or stage == 4 or stage == 5) then
    update_planet(stage_ticks)
    update_particles()
  end

  if (stage == 2) then
    update_speech_bubble()
  end

  if (stage == 3) then
    update_mission_control()
    update_maze()
  end

  if (stage == 2 or stage == 3) then
    update_astros()
  end

  if (started_fading_at > 0 and t() - started_fading_at >= 1) then
    clear_particles()
    started_fading_at = 0
    stage_ticks = 0
    stage = fade_target
    fade_target = 0
  end
end

function _draw()
  cls()

  if (stage == 1) then
    draw_menu(stage_ticks)
  end

  if (stage == 2 or stage == 4 or stage == 5) then
    draw_planet(stage_ticks)
  end

  if (stage == 2) then
    draw_speech_bubble()
  end

  if (stage == 3) then
    draw_mission_control()
  end

  if (started_fading_at > 0) then
    height = (t() - started_fading_at) * 127
    rectfill(0, 0, 127, height, 0)
  end
end
