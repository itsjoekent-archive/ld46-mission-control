helmet_sprite_x = 0
helmet_sprite_y = 0
helmet_sprite_w = 16
helmet_sprite_h = 16

helmet_interior_sprite_x = 0
helmet_interior_sprite_y = 16
helmet_interior_sprite_w = 16
helmet_interior_sprite_h = 16

active_astro = 0

eye_sprites = {
  [1] = {8, 0},
  [2] = {8, 3},
  [3] = {12, 0},
  [4] = {12, 3},
  [5] = {12, 6}
}

mouth_sprites = {
  [1] = {0, 14},
  [2] = {4, 14},
  [3] = {4, 12},
  [4] = {0, 12}
}

astros = {
  [1] = {
    sprite_x = 16,
    sprite_y = 0,
    sprite_w = 7,
    sprite_h = 9,

    eye_level = 1,
    eye_x = 1,
    eye_y = 1,

    mouth_level = 1,
    mouth_x = 2,
    mouth_y = 7,

    animation = 0,
    frame = 1
  },
  [2] = {
    sprite_x = 32,
    sprite_y = 0,
    sprite_w = 7,
    sprite_h = 9,

    eye_level = 1,
    eye_x = 1,
    eye_y = 2,

    mouth_level = 1,
    mouth_x = 2,
    mouth_y = 6,

    animation = 0,
    frame = 1
  },
  [3] = {
    sprite_x = 48,
    sprite_y = 0,
    sprite_w = 7,
    sprite_h = 9,

    eye_level = 1,
    eye_x = 1,
    eye_y = 1,

    mouth_level = 1,
    mouth_x = 2,
    mouth_y = 6,

    animation = 0,
    frame = 1
  }
}

-- animations
-- 0 = none
-- 1 = talking
-- 2 = slow idle
-- 3 = alarmed
-- 4 = grimmacing
-- 5 = scared af

animation_ticks = 0
animation_frames = {
  [1] = {{1, 1}, {2, 1}},
  [2] = {{1, 1}, {1, 1}, {1, 1}, {1, 1}, {1, 1}, {2, 1}},
  [3] = {{1, 1}, {1, 1}, {1, 3}, {1, 3}},
  [4] = {{1, 1}, {1, 3}, {2, 4}, {2, 4}, {1, 3}},
  [5] = {{1, 4}, {4, 5}, {4, 5}}
}

function set_astro_animation(id, animation)
  astros[id].animation = animation
end

function update_astros()
  animation_ticks += 1

  if (animation_ticks > 15) then
    animation_ticks = 0

    for astro in all(astros) do
      if (astro.animation > 0) then
        frames = animation_frames[astro.animation]
        if (astro.frame > #frames) then astro.frame = 1 end

        active_frame = frames[astro.frame]

        astro.mouth_level = active_frame[1]
        astro.eye_level = active_frame[2]

        astro.frame += 1

        if (astro.frame > #frames) then
          astro.frame = 1
        end
      elseif (astro.eye_level != 1 or astro.mouth_level != 1) then
        astro.eye_level = 1
        astro.mouth_level = 1
      end
    end
  end
end

function draw_astro(id, x, y, w, h)
  sspr(
    helmet_interior_sprite_x,
    helmet_interior_sprite_y,
    helmet_interior_sprite_w,
    helmet_interior_sprite_h,
    x,
    y,
    w,
    h
  )

  scale_x = w / 16
  scale_y = h / 16

  astro = astros[id]

  face_local_x = 8 - ((astro.sprite_w - 1) / 2)
  face_local_y = 2 + (9 - astro.sprite_h)

  face_x = x + (face_local_x * scale_x)
  face_y = y + (face_local_y * scale_y)

  sspr(
    astro.sprite_x,
    astro.sprite_y,
    astro.sprite_w,
    astro.sprite_h,
    face_x,
    face_y,
    astro.sprite_w * scale_x,
    astro.sprite_h * scale_y
  )

  eye_sprite = eye_sprites[astro.eye_level]
  eye_sprite_x = astro.sprite_x + eye_sprite[1]
  eye_sprite_y = astro.sprite_y + eye_sprite[2]

  left_eye_local_x = face_local_x + astro.eye_x
  left_eye_local_y = face_local_y + astro.eye_y

  left_eye_x = x + (left_eye_local_x * scale_x)
  left_eye_y = y + (left_eye_local_y * scale_y)

  right_eye_x = x + ((left_eye_local_x + 3) * scale_x)

  sspr(
    eye_sprite_x,
    eye_sprite_y,
    2,
    3,
    left_eye_x,
    left_eye_y,
    2 * scale_x,
    3 * scale_y
  )

  sspr(
    eye_sprite_x +  2,
    eye_sprite_y,
    2,
    3,
    right_eye_x,
    left_eye_y,
    2 * scale_x,
    3 * scale_y
  )

  mouth_sprite = mouth_sprites[astro.mouth_level]
  mouth_sprite_x = astro.sprite_x + mouth_sprite[1]
  mouth_sprite_y = astro.sprite_y + mouth_sprite[2]

  mouth_local_x = face_local_x + astro.mouth_x
  mouth_local_y = face_local_y + astro.mouth_y

  mouth_x = x + (mouth_local_x * scale_x)
  mouth_y = y + (mouth_local_y * scale_y)

  sspr(
    mouth_sprite_x,
    mouth_sprite_y,
    3,
    2,
    mouth_x,
    mouth_y,
    3 * scale_x,
    2 * scale_y
  )

  sspr(
    helmet_sprite_x,
    helmet_sprite_y,
    helmet_sprite_w,
    helmet_sprite_h,
    x,
    y,
    w,
    h
  )
end
