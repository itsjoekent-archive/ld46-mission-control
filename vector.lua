function vector_magnitude(v)
  return sqrt(v[1] * v[1] + v[2] * v[2])
end

function vector_normalize(v)
  m = vector_magnitude(v)

  if (m == 0) then return v end

  return { v[1] / m, v[2] / m }
end

function vector_scale(v, s)
  return { v[1] * s, v[2] * s }
end

function vector_add(v1, v2)
  return { v1[1] + v2[1], v1[2] + v2[2] }
end

function vector_subtract(v1, v2)
  return { v1[1] - v2[1], v1[2] - v2[2] }
end
