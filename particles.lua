local Particles = Object:extend()
local anim8 = require 'lib/anim8'

Particles.t = {}

local imgs = {}
imgs.splash = {}
imgs.splash.img = love.graphics.newImage("gfx/splash_spritesheet.png")
imgs.splash.g = anim8.newGrid(9, 6, imgs.splash.img:getWidth(), imgs.splash.img:getHeight())

function Particles.new(x, y, type)
    local v = {}
    v.x = x; v.y = y;
    v.type = type;
    v.dead = false;
    v.anim = anim8.newAnimation(imgs[type].g('1-5', 1), 0.5, function()
        v.dead = true;
    end)

    table.insert(Particles.t, v)
end

function Particles.update(dt)
    for i=#Particles.t,1,-1 do
        local v = Particles.t[i]
        v.anim:update(dt)
        if v.dead then
            table.remove(Particles.t, i)
        end
    end
end

function Particles.draw()
    for i=#Particles.t,1,-1 do
        local v = Particles.t[i]
        v.anim:draw(imgs[v.type].img, v.x, v.y)
    end
end

return Particles