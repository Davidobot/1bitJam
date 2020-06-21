--todo prevent double hits (velocity, directions? or a big drum collider that checks for the drumstick leaving the area before allowing another hit, like with the gong?)

local t = Object:extend()

love.mouse.setVisible(false)
--love.mouse.setGrabbed(true)

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

t.gong_img = love.graphics.newImage("gfx/gong.png")
t.gong_img_pos = {x = w / 2, y = 30}
t.gong_collisionPos = {x = w / 2 + 39, y = 100}
t.gong_collisionRad = 30
t.gong_colliding = false

t.drum_collisionLines = {
    --left rim
    {
        point1 = {x = t.drum_leftRimX - 10, y = t.drum_height + 60},
        point2 = {x = t.drum_leftRimX, y = t.drum_height},
        onHitFunc = function()
            t.drumHit(false)
        end
    },
    {
        point1 = {x = t.drum_leftRimX, y = t.drum_height},
        point2 = {x = t.drum_leftCenterX, y = t.drum_height},
        onHitFunc = function()
            t.drumHit(false)
        end
    },
    --center
    {
        point1 = {x = t.drum_leftCenterX, y = t.drum_height},
        point2 = {x = t.drum_rightCenterX, y = t.drum_height},
        onHitFunc = function()
            t.drumHit(true)
        end
    },
    --right rim
    {
        point1 =  {x = t.drum_rightCenterX, y = t.drum_height},
        point2 = {x = t.drum_rightRimX, y = t.drum_height},
        onHitFunc = function()
            t.drumHit(false)
        end
    },
    {
        point1 = {x = t.drum_rightRimX, y = t.drum_height},
        point2 = {x = t.drum_rightRimX + 10, y = t.drum_height + 60},
        onHitFunc = function()
            t.drumHit(false)
        end
    },
}

function t.init(playerBoat)
    --player_boat = playerBoat
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
    for i,v in ipairs(t.drum_collisionLines) do
        if (checkIntersect(prevDrumstickPos, t.drumstick_pos, v.point1, v.point2)) then
            v.onHitFunc()
        end
    end

    local insideGong = math.dist(t.drumstick_pos.x, t.drumstick_pos.y, t.gong_collisionPos.x, t.gong_collisionPos.y) <= t.gong_collisionRad
    if (t.gong_colliding == false) then
        if (insideGong) then
            t.gong_colliding = true
            t.gongHit()
        end
    elseif (insideGong == false) then
        t.gong_colliding = false
    end
end

function t.draw()
    love.graphics.clear(0, 0, 0)

    love.graphics.setColor(1, 1, 1)
    love.graphics.push()
    love.graphics.translate(-w/2, 0)
       
        love.graphics.setColor(1,1,1)
        --gong graphics
        love.graphics.draw(t.gong_img, t.gong_img_pos.x, t.gong_img_pos.y)
        --drum graphics
        love.graphics.draw(t.drum_img, t.drum_img_pos.x, t.drum_img_pos.y)
        --drumstick graphics
        love.graphics.draw(t.drumstick_img, t.drumstick_pos.x, t.drumstick_pos.y, 0, 1, 1, 0, 0)

        --debug colliders
        --[[
        love.graphics.setColor(1,0,1)
        
        love.graphics.circle("line", t.gong_collisionPos.x, t.gong_collisionPos.y, t.gong_collisionRad)
        
        for i,v in ipairs(t.drum_collisionLines) do
            love.graphics.line(v.point1.x, v.point1.y, v.point2.x, v.point2.y)
        end
        ]]
    love.graphics.pop()
end

function t.drumHit(left)
    player_boat:paddle(left)
    if not left then
        playSound("ka")
    else
        playSound("don")
    end
    local dx = 12 * math.cos(player_boat.pos.rot)
    local dy = 12* math.sin(player_boat.pos.rot)
    Particles.new(0, 0, "sound", true, function()
        return player_boat.pos.x + dx, player_boat.pos.y + dy
    end)
end

function t.gongHit()
    playSound("gong")
    player_boat:fire()
end

--todo move inside utils
-- Checks if two line segments intersect. Line segments are given in form of ({x,y},{x,y}, {x,y},{x,y}).
function checkIntersect(l1p1, l1p2, l2p1, l2p2)
	local function checkDir(pt1, pt2, pt3) return math.sign(((pt2.x-pt1.x)*(pt3.y-pt1.y)) - ((pt3.x-pt1.x)*(pt2.y-pt1.y))) end
	return (checkDir(l1p1,l1p2,l2p1) ~= checkDir(l1p1,l1p2,l2p2)) and (checkDir(l2p1,l2p2,l1p1) ~= checkDir(l2p1,l2p2,l1p2))
end

return t