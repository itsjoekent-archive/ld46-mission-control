noise_sprite_offset = 120

terrain_1 = {} -- spike mountains
terrain_2 = {} -- level mountains

terrain_1_start = 64
terrain_2_start = 86

terrain_height = 64
terrain_unit = terrain_height / 15

base_map_offset_x = 120
base_map_offset_y = 16
base = {}
base_parts = { 45, 46, 61, 62, 63 }

spaceship_parts = { 13, 11, 43 } -- top, middle, bottom
spaceship_x = 86
spaceship_y = 70

spaceship_animation_ticks = 0
explosion_colors = {8, 9, 10}
smoke_colors = {7,6,5}

function generate_planet_terrain()
  for y=0,7 do
    for x=0,7 do
      index = (y * 8) + x
      true_x = noise_sprite_offset + x

      terrain_1[index] = sget(true_x, y)
    end
  end

  for y=0,7 do
    for x=0,7 do
      index = (y * 8) + x
      true_x = noise_sprite_offset + x

      terrain_2[index] = sget(true_x, y + 8)
    end
  end

  for y=0,7 do
    for x=0,7 do
      index = (y * 8) + x
      true_x = base_map_offset_x + x
      true_y = base_map_offset_y + y

      base[index] = { x, y, sget(true_x, true_y) }
    end
  end
end

function update_planet(stage_ticks)
  if (stage == 4) then
    if (stage_ticks == 30) then
      sfx(2, 1)

      for p=0,3 do
        for ring=1,3 do
          for a=0,360, 8 do
            r = a * 3.14159 / 180
            velocity = vector_scale({sin(r), cos(r)}, ring * (rnd(0.9) + 0.1))

            position = {spaceship_x + 8, spaceship_y + 8 + (p * 16)}

            color = explosion_colors[ring]

            add_particle(position, velocity, color, 2 + rnd(1))
          end
        end
      end
    end

    if (stage_ticks == 120) then
      return_to_menu()
    end
  end

  if (stage == 5) then
    if (stage_ticks >= 30 and stage_ticks < 60) then
      sfx(2, 1)
      
      offset = min(((127 / 30) * (stage_ticks - 30)), 128)
      thruster_y = (spaceship_y + 48) - offset

      for loop = 0, 1 do
        for x=0,13 do
          position = {spaceship_x + x, thruster_y - rnd(0.5)}
          velocity = {0, 0.5 + rnd(0.5)}
          color = smoke_colors[ceil(rnd(#smoke_colors))]
          add_particle(position, velocity, color, 0.2 + rnd(0.6))
        end
      end
    end

    if (stage_ticks == 90) then
      return_to_menu()
    end
  end
end

function draw_planet(stage_ticks)
  rectfill(0, 0, 127, 127, 8)
  rectfill(0, terrain_2_start, 127, 127, 4)

  for x = 0,63 do
    height = terrain_unit * terrain_1[x]
    rectfill(x * 2, terrain_1_start, (x * 2) + 1, terrain_1_start - height, 9)
  end

  rectfill(0, terrain_1_start, 127, terrain_2_start, 9)

  for x = 0,63 do
    height = terrain_unit * terrain_2[x]
    rectfill(x * 2, terrain_2_start, (x * 2) + 1, terrain_2_start - height, 10)
  end

  for i = 0,63 do
    x = base[i][1]
    y = base[i][2]
    part = base[i][3]

    if (part != 0) then
      spr(base_parts[part], x * 8, (y * 8) + (terrain_2_start - 4))
    end
  end

  if (stage == 5) then
    draw_particles()
    offset = 0

    if (stage_ticks > 30) then
      offset = min(((127 / 30) * (stage_ticks - 30)), 128)
    end

    spr(spaceship_parts[1], spaceship_x, spaceship_y - offset, 2, 2)
    spr(spaceship_parts[2], spaceship_x, (spaceship_y + 16) - offset, 2, 2)
    spr(spaceship_parts[3], spaceship_x, (spaceship_y + 32) - offset, 2, 2)
  end

  if (stage == 4) then
    if (stage_ticks <= 40) then
      spr(spaceship_parts[1], spaceship_x, spaceship_y, 2, 2)
      spr(spaceship_parts[2], spaceship_x, spaceship_y + 16, 2, 2)
      spr(spaceship_parts[3], spaceship_x, spaceship_y + 32, 2, 2)
    end

    draw_particles()
  end

  if (stage == 2) then
    spr(spaceship_parts[1], spaceship_x, spaceship_y, 2, 2)
    spr(spaceship_parts[2], spaceship_x, spaceship_y + 16, 2, 2)
    spr(spaceship_parts[3], spaceship_x, spaceship_y + 32, 2, 2)
  end

  if (stage == 2 and stage_ticks > 60) then
    offset = max((127 - (127 / 30) * (stage_ticks - 60)), 64)
    draw_astro(1, 16, offset, 64, 64)
  end
end
