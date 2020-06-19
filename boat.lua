local Boat = Object:extend()

Boat.img = love.graphics.newImage("gfx/boat.png")

local _forward_decel = 5
local _rot_decel = math.pi/4

local _instant_rot_speed = math.pi/8
local _instant_forward_speed = 10
local _max_speed = 30
local _max_rot = math.pi

function Boat:new()
    self.pos = {x = w/2, y = h, rot = -math.pi/2}
    self.mov = {
        forward_speed = 0,
        rot_speed = 0,
    }
end

function Boat:update(dt)
    self.pos.rot = self.pos.rot + self.mov.rot_speed * dt
    self.pos.x = self.pos.x + self.mov.forward_speed * math.cos(self.pos.rot) * dt
    self.pos.y = self.pos.y + self.mov.forward_speed * math.sin(self.pos.rot) * dt

    self.mov.forward_speed = math.max(0, self.mov.forward_speed - _forward_decel * dt)
    self.mov.rot_speed = self.mov.rot_speed < 0 and math.min(0, self.mov.rot_speed + _rot_decel * dt) or math.max(0, self.mov.rot_speed - _rot_decel * dt)
end

---@param left boolean
function Boat:paddle(left)
    self.mov.rot_speed = math.clamp(-_max_rot, self.mov.rot_speed + (left and -1 or 1) * _instant_rot_speed, _max_rot)
    self.mov.forward_speed = math.min(self.mov.forward_speed + _instant_forward_speed, _max_speed)
end

function Boat:draw()
    love.graphics.draw(Boat.img, self.pos.x, self.pos.y, self.pos.rot, 1, 1, Boat.img:getWidth()/2, Boat.img:getHeight()/2)
end

return Boat