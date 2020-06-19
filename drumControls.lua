local t = Object:extend()

love.mouse.setVisible(false)

t.drumstick_pos = {x = w * 0.75, y = h * 0.5}
t.drumstick_targetPos = {x = t.drumstick_pos.x, y = t.drumstick_pos.y}
t.drumstick_lerp = 16
t.drumstick_minPos = {x = w / 2 + 5, y = 0 + 5}
t.drumstick_maxPos = {x = w - 5, y = h - 5}
t.drumstick_idlePos = {}
t.drumstick_img = love.graphics.newImage("gfx/hand.png")

function t.update(dt)
    local mouseX = love.mouse.getX() / love.graphics.getWidth() * w
    local mouseY = love.mouse.getY() / love.graphics.getHeight() * h
    
    --if (mouseX >= t.drumstick_minPos.x and mouseX <= t.drumstick_maxPos.x and
    --    mouseY >= t.drumstick_minPos.y and mouseY <= t.drumstick_maxPos.y) then

        t.drumstick_targetPos.x = math.max(math.min(mouseX, t.drumstick_maxPos.x), t.drumstick_minPos.x)
        t.drumstick_targetPos.y = math.max(math.min(mouseY, t.drumstick_maxPos.y), t.drumstick_minPos.y)
    --end

    t.drumstick_pos.x = lerp(t.drumstick_pos.x, t.drumstick_targetPos.x, t.drumstick_lerp * dt)
    t.drumstick_pos.y = lerp(t.drumstick_pos.y, t.drumstick_targetPos.y, t.drumstick_lerp * dt)
end

function t.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.push()
    love.graphics.translate(-w/2, 0)
    --love.graphics.circle("fill", t.drumstick_pos.x, t.drumstick_pos.y, 10, 6)
    love.graphics.draw(t.drumstick_img, t.drumstick_pos.x, t.drumstick_pos.y, 0, 1, 1, 0, 0)
    love.graphics.pop()
end

return t