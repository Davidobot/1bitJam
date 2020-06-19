local Boat = Object:extend()

function Boat:new()
    self.pos = {x = w/2, y = h/2, rot = math.pi/3}
end

function Boat:draw()
    love.graphics.push()
    --love.graphics.rotate(self.pos.rot)
    --love.graphics.translate(self.pos.x, self.pos.y)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, 20, 120)
    love.graphics.pop()
end

return Boat