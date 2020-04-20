particles = {}

function add_particle(position, velocity, color, life)
  add(particles, {
    position = position,
    velocity = velocity,
    color = color,
    life = t() + life,
    update = function(self)
      self.position = vector_add(self.position, self.velocity)

      if (self.life < t()) then
        del(particles, self)
      end
    end,
    draw = function(self)
      rectfill(
        self.position[1],
        self.position[2],
        self.position[1] + 1,
        self.position[2] + 1,
        self.color
      )
    end
  })
end

function clear_particles()
  particles = {}
end

function update_particles()
  for particle in all(particles) do
    particle:update()
  end
end

function draw_particles()
  for particle in all(particles) do
    particle:draw()
  end
end
