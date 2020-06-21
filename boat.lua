local Boat = Object:extend()

Boat.img = {
    img = love.graphics.newImage("gfx/boat.png"),
    pirate = love.graphics.newImage("gfx/boat.png")
}
Boat.deadman = love.graphics.newImage("gfx/deadman.png")

local _forward_decel = 5
local _rot_decel = math.pi/4

local _instant_rot_speed = math.pi/10
local _instant_forward_speed = 20
local _max_speed = 50
local _max_rot = math.pi

function Boat:new(type)
    self.pos = {x = w/2, y = h, rot = -math.pi/2}
    self.mov = {
        forward_speed = 0,
        rot_speed = 0,
        current = {
            speed = 0,
            rot = 0,
        },
    }
    self.img = type and Boat .img[type] or Boat.img.img

    -- 0,3 on left, 4 to 7 on right
    self.dead = {}
    self.isPlayer = false
end

function Boat:kill(n)
    table.insert(self.dead, n)

    if #self.dead == 8 and self.isPlayer then
        playSound("gong")
        --camera:fade(1, {0, 0, 0, 1})
        local t = {t = 0}
        flux.to(t, 1.1, {t= 1}):oncomplete(function()
            lovelyMoon.switchState("game", "gameover")
        end)
    end
end

function Boat:killSomeone()
    if #self.dead == 8 then
        return
    end

    while true do 
        local t = love.math.random(0, 7)
        if not contains(self.dead, t) then
            self:kill(t)
            return
        end
    end
end

function Boat:fire()
    local len = 15
    for i=1, len do
        local dx = (i*6 + 36) * math.cos(player_boat.pos.rot)
        local dy = (i*6 + 36) * math.sin(player_boat.pos.rot)
        Particles.new(0, 0, "fire", true, function()
            return player_boat.pos.x + dx, player_boat.pos.y + dy
        end, love.math.random(0, math.pi/2), math.random(0.8 + (i/len), 1 + 2*(i/len)))

        for i,v in ipairs(Enemies.data) do
            if math.dist(player_boat.pos.x + dx, player_boat.pos.y + dy, v.pos.x, v.pos.y) < v.w then
                print("HI")
            end
        end
    end
end

function Boat:update(dt)
    self.pos.rot = self.pos.rot + self.mov.rot_speed * dt
    self.pos.x = self.pos.x + (self.mov.forward_speed * math.cos(self.pos.rot)
                            +  self.mov.current.speed * math.cos(self.mov.current.rot)) * dt
    self.pos.y = self.pos.y + (self.mov.forward_speed * math.sin(self.pos.rot)
                            +  self.mov.current.speed * math.sin(self.mov.current.rot))* dt

    self.mov.forward_speed = math.max(0, self.mov.forward_speed - _forward_decel * dt)
    self.mov.rot_speed = self.mov.rot_speed < 0 and math.min(0, self.mov.rot_speed + _rot_decel * dt) or math.max(0, self.mov.rot_speed - _rot_decel * dt)

    for i,v in ipairs(Obstacles.t) do
        if math.pow((v.x - self.pos.x), 2) + math.pow(v.y - self.pos.y, 2) < 300 then
            camera:shake(8 * (self.mov.forward_speed / _max_speed), 1, 60)
            self.mov.current.speed = self.mov.forward_speed
            self.mov.forward_speed = 0
            self.mov.current.rot = math.atan2(self.pos.y - v.y , self.pos.x - v.x)
            flux.to(self.mov.current, 4, {speed = 0, rot = 0}):ease("quadout")
        end
    end
end

---@param left boolean
function Boat:paddle(left)
    local alive = 4
    for i=(left and 4 or 0), (left and 7 or 3) do
        if contains(self.dead, i) then
            alive = alive - 1
        end
    end
    local pow = alive/4
    self.mov.rot_speed = math.clamp(-_max_rot, self.mov.rot_speed + (left and -1 or 1) * _instant_rot_speed, _max_rot)
    self.mov.forward_speed = math.min(self.mov.forward_speed + _instant_forward_speed * pow, _max_speed)

    for i=0,3 do
        local dx = -self.img:getHeight()/2*1.2 * math.sin(self.pos.rot) - 9 * i * math.cos(self.pos.rot)
        local dx2 = self.img:getHeight()/2*1.2 * math.sin(self.pos.rot) - 9 * i * math.cos(self.pos.rot)
        local dy = self.img:getHeight()/2*1.2 * math.cos(self.pos.rot) - 9 * i * math.sin(self.pos.rot)
        local dy2 = -self.img:getHeight()/2*1.2 * math.cos(self.pos.rot) - 9 * i * math.sin(self.pos.rot)
        if left and not contains(self.dead, (3- i) + 4) then
            Particles.new(self.pos.x + dx, self.pos.y + dy, "splash")
        elseif not left and not contains(self.dead, (3-i)) then
            Particles.new(self.pos.x + dx2, self.pos.y + dy2, "splash")
        end
    end
end

function Boat:draw()
    --love.graphics.draw(Boat.img, self.pos.x, self.pos.y, self.pos.rot, 1, 1, Boat.img:getWidth()/2, Boat.img:getHeight()/2)
    orderedDraw(self.pos.y, self.img, self.pos.x, self.pos.y, self.pos.rot, 1, 1, self.img:getWidth()/2, self.img:getHeight()/2)

    for i,v in ipairs(self.dead) do
        local dx = -20 + (v % 4) * 10 - 9
        local dy = -10 + math.floor(v / 4) * 10 + 5
        local x = dx * math.cos(self.pos.rot) - dy * math.sin(self.pos.rot)
        local y = dx * math.sin(self.pos.rot) + dy * math.cos(self.pos.rot)
        orderedDraw(self.pos.y + 1, Boat.deadman, self.pos.x + x, self.pos.y + y, self.pos.rot, 1, 1, 5, 5)
    end
end

return Boat