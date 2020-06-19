w, h = 640, 360
love.graphics.setDefaultFilter("nearest", "nearest", 0)

Object = require "lib/classic"
local Camera = require 'lib/Camera'
require "lib/utils"

local Boat = require "boat"

local screen = love.graphics.newCanvas(w/2, h)

local boat = Boat()

local drumControls = require "drumControls"

function love.load()
    camera = Camera(w/4, h/2, w/2, h)
    camera:setFollowLerp(0.2)
    camera:setFollowLead(20)
    camera:setFollowStyle('TOPDOWN_TIGHT')
end

function love.update(dt)
    camera:update(dt)
    drumControls.update(dt)
    boat:update(dt)
    camera:follow(boat.pos.x, boat.pos.y)
end

function love.draw()
    love.graphics.setCanvas(screen)
        love.graphics.clear()

        camera:attach()
            boat:draw()
        camera:detach()
        camera:draw()

        drumControls.draw()

    love.graphics.setCanvas()

    local cur_w, cur_h, _ = love.window.getMode()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(screen, 0, 0, 0, cur_w/w, cur_h/h)
    love.graphics.setBlendMode('alpha')
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