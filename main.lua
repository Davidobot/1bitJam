w, h = 640, 360
love.graphics.setDefaultFilter("nearest", "nearest", 0)

Object = require "lib/classic"

local Boat = require "boat"

local screen = love.graphics.newCanvas(w, h)

local boat = Boat()

function love.load()
    
end

function love.update(dt)

end

function love.draw()
    love.graphics.setCanvas(screen)
    love.graphics.clear()
    boat:draw()
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
end