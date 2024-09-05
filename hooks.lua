local hooks = {}

function hooks.regen ()
    pos = entity.get_player():get_pos()
    dvds = {}
end

function hooks.do_special ()
  if entity.get_player():get_special() == DVD_SPECIAL then
    local vel = Vec2.new(SPEED, SPEED)
    if os.rand_bool() then
      vel.x = -SPEED
    end
    if os.rand_bool() then
      vel.y = -SPEED
    end

    table.insert(dvds, {
      pos = entity.get_player():get_pos(),
      size = Vec2.new(3.0, 1.8),
      vel = vel, 
      col = Color.new(255, 0, 0, 255),
      bounces_left = 100
    })
  end
end

function hooks.draw_entities ()
  for _, e in ipairs(dvds) do
    local bounds = Rect.new(e.pos.x, e.pos.y, e.size.x, e.size.y) 

    texture:draw(
        Rect.new(0.0, 0.0, 1.0, 1.0),
        bounds:to_screenspace(),
        e.col
    )
  end
end

function hooks.update (dt)
  for _, e in ipairs(dvds) do
    local rect = Rect.new(e.pos.x, e.pos.y, e.size.x, e.size.y)
    local last_vel = Vec2.new(e.vel.x, e.vel.y)
    local change = false

    e.vel = rect:collide(collision.entity, e.vel, dt)
    e.pos = e.pos:add(e.vel:mul(dt))

    if e.vel.x < SPEED and last_vel.x == SPEED then
      e.vel.x = -SPEED
      change = true
    end
    if e.vel.x > -SPEED and last_vel.x == -SPEED then
      e.vel.x = SPEED
      change = true
    end
    if e.vel.y < SPEED and last_vel.y == SPEED then
      e.vel.y = -SPEED
      change = true
    end
    if e.vel.y > -SPEED and last_vel.y == -SPEED then
      e.vel.y = SPEED
      change = true
    end

    if change then
      if e.bounces_left == 0 then
        boom_sound:play()
      else
        bounce_sound:play()
      end

      e.bounces_left = e.bounces_left - 1
      e.col = Color.new(0, 0, 0, 255)

      if os.rand_bool() then
        e.col.r = 255
      end
      if os.rand_bool() then
        e.col.g = 255
      end
      if os.rand_bool() then
        e.col.b = 255
      end

      if e.col.r == e.col.g and e.col.g == e.col.b then
        e.col.r = 255
        e.col.b = 0
      end
    end

    for _, enemy in ipairs(entity.get_enemies()) do
      local boxes = enemy:get_hitboxes()
      for _, box in ipairs(boxes) do
        if rect:contains(box:center()) then
          enemy:damage(5.0)
        end
      end
    end
  end

  for i, e in ipairs(dvds) do
    if e.bounces_left < 0 then
      table.remove(dvds, i)
      break
    end
  end
end

return hooks