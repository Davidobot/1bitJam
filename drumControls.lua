local DrumControls = Object:extend()

love.mouse.setVisible(false)

DrumControls.drumstick_pos = {x = w * 0.75, y = h * 0.5}
DrumControls.drumstick_targetPos = {x = DrumControls.drumstick_pos.x, y = DrumControls.drumstick_pos.y}
DrumControls.drumstick_lerp = 16
DrumControls.drumstick_minPos = {x = w / 2 + 5, y = 0 + 5}
DrumControls.drumstick_maxPos = {x = w - 5, y = h - 5}
DrumControls.drumstick_idlePos = {}
--DrumControls.drumstick_img = love.graphics.newImage("gfx/boat.png")

function DrumControls.update(dt)
    local mouseX = love.mouse.getX() / love.graphics.getWidth() * w
    local mouseY = love.mouse.getY() / love.graphics.getHeight() * h
    
    --if (mouseX >= DrumControls.drumstick_minPos.x and mouseX <= DrumControls.drumstick_maxPos.x and
    --    mouseY >= DrumControls.drumstick_minPos.y and mouseY <= DrumControls.drumstick_maxPos.y) then

        DrumControls.drumstick_targetPos.x = math.max(math.min(mouseX, DrumControls.drumstick_maxPos.x), DrumControls.drumstick_minPos.x)
        DrumControls.drumstick_targetPos.y = math.max(math.min(mouseY, DrumControls.drumstick_maxPos.y), DrumControls.drumstick_minPos.y)
    --end

    DrumControls.drumstick_pos.x = lerp(DrumControls.drumstick_pos.x, DrumControls.drumstick_targetPos.x, DrumControls.drumstick_lerp * dt)
    DrumControls.drumstick_pos.y = lerp(DrumControls.drumstick_pos.y, DrumControls.drumstick_targetPos.y, DrumControls.drumstick_lerp * dt)
end

function DrumControls.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", DrumControls.drumstick_pos.x, DrumControls.drumstick_pos.y, 10, 6)
end

return DrumControls