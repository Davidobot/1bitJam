local t = Object:extend()

love.mouse.setVisible(false)
love.mouse.setGrabbed(true)

t.drumstick_pos = {x = w * 0.75, y = h * 0.5}
t.drumstick_targetPos = {x = t.drumstick_pos.x, y = t.drumstick_pos.y}
t.drumstick_lerp = 16
t.drumstick_minPos = {x = w / 2 + 5, y = 0 + 5}
t.drumstick_maxPos = {x = w - 5, y = h - 5}
t.drumstick_idlePos = {}
t.drumstick_img = love.graphics.newImage("gfx/hand.png")

t.drum_img = love.graphics.newImage("gfx/drum.png")
t.drum_img_pos = {x = w / 2 + 50, y = h / 2 + 50}
t.drum_height = h * 0.68

t.drum_leftRimX     = w / 2 + 60
t.drum_leftCenterX  = w / 2 + 90
t.drum_rightCenterX = w / 2 + 237
t.drum_rightRimX    = w / 2 + 267

t.playerBoatRef = nil

function t.init(playerBoat)
    t.playerBoatRef = playerBoat
end

function t.update(dt)
    local mouseX = love.mouse.getX() / love.graphics.getWidth() * w
    local mouseY = love.mouse.getY() / love.graphics.getHeight() * h
    
    --todo: Limit cursor position

    if ((mouseX >= t.drumstick_minPos.x and mouseX <= t.drumstick_maxPos.x and
        mouseY >= t.drumstick_minPos.y and mouseY <= t.drumstick_maxPos.y) == false) then
        
        mouseX = math.max(math.min(mouseX, t.drumstick_maxPos.x), t.drumstick_minPos.x)
        mouseY = math.max(math.min(mouseY, t.drumstick_maxPos.y), t.drumstick_minPos.y)
        
        love.mouse.setPosition(mouseX / w * love.graphics.getWidth(), mouseY / h * love.graphics.getHeight())
    end

    --if (mouseX >= t.drumstick_minPos.x and mouseX <= t.drumstick_maxPos.x and
    --    mouseY >= t.drumstick_minPos.y and mouseY <= t.drumstick_maxPos.y) then

        t.drumstick_targetPos.x = mouseX
        t.drumstick_targetPos.y = mouseY
    --end

    local prevDrumstickPos = {x = t.drumstick_pos.x, y = t.drumstick_pos.y}
    t.drumstick_pos.x = lerp(t.drumstick_pos.x, t.drumstick_targetPos.x, t.drumstick_lerp * dt)
    t.drumstick_pos.y = lerp(t.drumstick_pos.y, t.drumstick_targetPos.y, t.drumstick_lerp * dt)

    -- drumstick to drum collision
    if (prevDrumstickPos.y < t.drum_height and t.drumstick_pos.y >= t.drum_height) then
        local left
        local hit = false

        if (t.drumstick_pos.x > t.drum_rightRimX) then
            hit = false
        elseif (t.drumstick_pos.x > t.drum_rightCenterX) then
            hit = true
            left = false
        elseif (t.drumstick_pos.x > t.drum_leftCenterX) then
            hit = true
            left = true
        elseif (t.drumstick_pos.x > t.drum_leftRimX) then
            hit = true
            left = false
        else
            hit = false
        end

        if (hit) then
            t.playerBoatRef:paddle(left)
            if not left then
                playSound("ka")
            else
                playSound("don")
            end
            local dx = 12 * math.cos(t.playerBoatRef.pos.rot)
            local dy = 12* math.sin(t.playerBoatRef.pos.rot)
            Particles.new(0, 0, "sound", true, function()
                return t.playerBoatRef.pos.x + dx, t.playerBoatRef.pos.y + dy
            end)
        end
    end
end

function t.draw()
    love.graphics.clear(0, 0, 0)

    love.graphics.setColor(1, 1, 1)
    love.graphics.push()
    love.graphics.translate(-w/2, 0)
       
        --debug collision lines
        love.graphics.setColor(1,0,1)
        love.graphics.line(t.drum_leftRimX, t.drum_height, t.drum_leftCenterX, t.drum_height)
        --love.graphics.line(t.drum_leftCenterX, t.drum_height, t.drum_rightCenterX, t.drum_height)
        love.graphics.line(t.drum_rightCenterX, t.drum_height, t.drum_rightRimX, t.drum_height)
        
        --drum and drumstick graphics
        love.graphics.setColor(1,1,1)
        love.graphics.draw(t.drum_img, t.drum_img_pos.x, t.drum_img_pos.y)
        love.graphics.draw(t.drumstick_img, t.drumstick_pos.x, t.drumstick_pos.y, 0, 1, 1, 0, 0)
    love.graphics.pop()
end

return t