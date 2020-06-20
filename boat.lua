local Boat = Object:extend()

Boat.img = love.graphics.newImage("gfx/boat.png")

local _forward_decel = 5
local _rot_decel = math.pi/4

local _instant_rot_speed = math.pi/10
local _instant_forward_speed = 20
local _max_speed = 50
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

    for i,v in ipairs(Obstacles.t) do
        if math.dist(v.x, v.y, self.pos.x, self.pos.y) < 10 then
            camera:shake(8, 1, 60)
            camera:flash(0.05, {0, 0, 0, 1})
        end
    end
end

---@param left boolean
function Boat:paddle(left)
    self.mov.rot_speed = math.clamp(-_max_rot, self.mov.rot_speed + (left and -1 or 1) * _instant_rot_speed, _max_rot)
    self.mov.forward_speed = math.min(self.mov.forward_speed + _instant_forward_speed, _max_speed)

    for i=0,3 do
        local dx = -Boat.img:getHeight()/2*1.2 * math.sin(self.pos.rot) - 9 * i * math.cos(self.pos.rot)
        local dx2 = Boat.img:getHeight()/2*1.2 * math.sin(self.pos.rot) - 9 * i * math.cos(self.pos.rot)
        local dy = Boat.img:getHeight()/2*1.2 * math.cos(self.pos.rot) - 9 * i * math.sin(self.pos.rot)
        local dy2 = -Boat.img:getHeight()/2*1.2 * math.cos(self.pos.rot) - 9 * i * math.sin(self.pos.rot)
        if left then
            Particles.new(self.pos.x + dx, self.pos.y + dy, "splash")
        else
            Particles.new(self.pos.x + dx2, self.pos.y + dy2, "splash")
        end
    end
end

function Boat:draw()
    --love.graphics.draw(Boat.img, self.pos.x, self.pos.y, self.pos.rot, 1, 1, Boat.img:getWidth()/2, Boat.img:getHeight()/2)
    orderedDraw(self.pos.y, Boat.img, self.pos.x, self.pos.y, self.pos.rot, 1, 1, Boat.img:getWidth()/2, Boat.img:getHeight()/2)
end

return Boat