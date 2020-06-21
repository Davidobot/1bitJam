local Obstacles = Object:extend()

Obstacles.t = {}

local imgs = {
    rock = love.graphics.newImage("gfx/rocks.png"),
    tentacle = love.graphics.newImage("gfx/tentacle.png")
}

---@param type string
--- type corresponds to imgs
function Obstacles.new(x, y, type)
    local v = {}
    v.x = x; v.y = y;
    v.w = imgs[type]:getWidth(); v.h = imgs[type]:getHeight()
    v.type = type

    table.insert(Obstacles.t, v)
end

function Obstacles.update(dt)
end

function Obstacles.draw()
    for i=#Obstacles.t,1,-1 do
        local v = Obstacles.t[i]
        local cx, cy = camera:toCameraCoords(v.x - v.w/2, v.y - v.h/2)
        if isVisible(cx, cy, v.w, v.h) then
            --love.graphics.draw(imgs[v.type], v.x - v.w/2, v.y - v.h/2)
            orderedDraw(v.y + v.h/2, imgs[v.type], v.x - v.w/2, v.y - v.h/2)
        end
    end
end

function Obstacles.clearObstacles()
    Obstacles.t = {}
end

return Obstacles