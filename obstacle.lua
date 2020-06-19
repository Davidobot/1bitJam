local Obstacle = Object:extend()

local imgs = {
    rock = love.graphics.newImage("gfx/rocks.png"),
    tentacle = love.graphics.newImage("gfx/tentacle.png")
}

---@param type string
--- type corresponds to imgs
function Obstacle:new(x, y, type)
    self.x = x; self.y = y;
    self.w = imgs[type]:getWidth(); self.h = imgs[type]:getHeight()
    self.type = type
end

function Obstacle:draw()
    if not isVisible(self.x, self.y, self.w, self.h) then
        return
    end

    love.graphics.draw(imgs[self.type], self.x, self.y)
end

return Obstacle