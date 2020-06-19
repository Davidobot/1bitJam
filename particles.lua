local Particles = Object:extend()
local anim8 = require 'lib/anim8'

Particles.t = {}

local imgs = {}
imgs.splash = {}
imgs.splash.img = love.graphics.newImage("gfx/splash_spritesheet.png")
imgs.splash.w = 9; imgs.splash.h = 6
imgs.splash.g = anim8.newGrid(imgs.splash.w, imgs.splash.h, imgs.splash.img:getWidth(), imgs.splash.img:getHeight())
imgs.splash.t = 0.3

imgs.sound = {}
imgs.sound.img = love.graphics.newImage("gfx/sound_spritesheet.png")
imgs.sound.w = 16; imgs.sound.h = 12
imgs.sound.g = anim8.newGrid(imgs.sound.w, imgs.sound.h, imgs.sound.img:getWidth(), imgs.sound.img:getHeight())
imgs.sound.t = 0.05

--- getCoords for anchoring stuff
function Particles.new(x, y, type, above, getCoords)
    local v = {}
    v.x = x; v.y = y;
    v.type = type;
    v.dead = false;
    v.above = above or false
    v.getCoords = getCoords;
    v.anim = anim8.newAnimation(imgs[type].g('1-5', 1), imgs[type].t, function()
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

function Particles.draw(above)
    for i=#Particles.t,1,-1 do
        local v = Particles.t[i]
        if v.getCoords then
            v.x, v.y = v.getCoords()
        end
        --v.anim:draw(imgs[v.type].img, v.x - imgs[v.type].w/2, v.y - imgs[v.type].h/2)
        orderedAnimDraw(v.above and h or v.y, v.anim, imgs[v.type].img, v.x - imgs[v.type].w/2, v.y - imgs[v.type].h/2)
    end
end

return Particles