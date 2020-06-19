w, h = 640, 360
love.graphics.setDefaultFilter("nearest", "nearest", 0)

Object = require "lib/classic"
local Camera = require 'lib/Camera'

local Boat = require "boat"

local screen = love.graphics.newCanvas(w, h)

local boat = Boat()

function love.load()
    camera = Camera(w/2, h/2, w, h)
    camera:setFollowLerp(0.2)
    camera:setFollowLead(10)
end

function love.update(dt)
    camera:update(dt)
    boat:update(dt)
    --camera:follow(boat.pos.x, boat.pos.y)
end

function love.draw()
    love.graphics.setCanvas(screen)
        love.graphics.clear()

        camera:attach()
            
            boat:draw()
        
        camera:detach()
        camera:draw()

    love.graphics.setCanvas()

    local cur_w, cur_h, _ = love.window.getMode()

    love.graphics.push()
    love.graphics.scale(cur_w/w, cur_h/h)
    love.graphics.draw(screen)
    love.graphics.pop()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "z" then
        boat:paddle(true)
    elseif key == "c" then
        boat:paddle(false)
    end
end