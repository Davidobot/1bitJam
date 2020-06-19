local state = {}

-- Global Classes
Particles = require "particles"
Obstacles = require "obstacle"

local Camera = require 'lib/Camera'
local Boat = require "boat"

local screen = love.graphics.newCanvas(w/2, h)
local drumScreen = love.graphics.newCanvas(w/2, h)
local boat = Boat()
local drumControls = require "drumControls"

function state:new()
	return lovelyMoon.new(self)
end

function state:load()
	camera = Camera(w/4, h/2, w/2, h, 0.8)
    camera:setFollowLerp(0.2)
    camera:setFollowLead(40)
    camera:setFollowStyle('TOPDOWN_TIGHT')

    drumControls.init(boat)

    for i=1, 100 do
        Obstacles.new(love.math.random(-w, w), love.math.random(-h, h), "rock")
    end
end

function state:close()
	
end

function state:enable()
	
end

function state:disable()
	
end

function state:update(dt)
	camera:update(dt)
    drumControls.update(dt)

    Particles.update(dt)
    Obstacles.update(dt)

    boat:update(dt)
    camera:follow(boat.pos.x, boat.pos.y)
end

function state:draw()
	love.graphics.setCanvas(screen)
        love.graphics.clear()
        
        sea_noise:send("vars", {camera.x, camera.y, love.timer.getTime()})
        love.graphics.setShader(sea_noise)
        love.graphics.rectangle("fill", 0, 0, w/2, h)
        love.graphics.setShader()

        camera:attach()
            -- Draw in any order
            Obstacles.draw()
            Particles.draw()
            boat:draw()

            -- Actually render
            sortedDraw()
        camera:detach()
        camera:draw()
    
    love.graphics.setCanvas(drumScreen)
        love.graphics.clear()
        drumControls.draw()
    love.graphics.setCanvas()
    local cur_w, cur_h, _ = love.window.getMode()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(screen, 0, 0, 0, cur_w/w, cur_h/h)
    love.graphics.draw(drumScreen, cur_w/2, 0, 0, cur_w/w, cur_h/h)
    love.graphics.setBlendMode('alpha')
end

function state:keypressed(key, unicode)
	
end

function state:keyreleased(key, unicode)
	
end

function state:mousepressed(x, y, button)
	
end

function state:mousereleased(x, y, button)
	
end

return state