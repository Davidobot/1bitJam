local state = {}

-- Global Classes
Particles = require "particles"
Obstacles = require "obstacle"

local Camera = require 'lib/Camera'
Boat = require "boat"

local screen = love.graphics.newCanvas(w/2, h)
local drumScreen = love.graphics.newCanvas(w/2, h)
local pauseScreen = love.graphics.newCanvas(w, h)
player_boat = Boat()
player_boat.isPlayer = true
local drumControls = require "drumControls"

level = require "level"
Enemies = require "enemies"

stormy = true
local time_til_next_light = 0

local paused = false

local pauseFont

function state:new()
	return lovelyMoon.new(self)
end

function state:load()
	camera = Camera(w/4, h/2, w/2, h, 0.8)
    camera:setFollowLerp(0.2)
    camera:setFollowLead(40)
    camera:setFollowStyle('TOPDOWN_TIGHT')

    drumControls.init(player_boat)

    pauseFont = love.graphics.newFont("PERTILI.TTF", 20, "mono")

    --for i=1, 100 do
    --    Obstacles.new(love.math.random(-w, w), love.math.random(-h, h), "rock")
    --end
end

function state:close()
	
end

function state:enable()
    level.init(Obstacles, player_boat, Enemies)
    Enemies.init(player_boat, Boat)
    level.loadLevel(cur_level)
end

function state:disable()
	level.endCurrentLevel()
end

function state:update(dt)
    if (paused == false) then
        camera:update(dt)
        drumControls.update(dt)

        Particles.update(dt)
        Obstacles.update(dt)
        Enemies.update(dt)

        if stormy then
            time_til_next_light = time_til_next_light - dt
            if time_til_next_light <= 0 then
                time_til_next_light = love.math.random(2, 10)
                camera:flash(0.05, {1, 1, 1, 1})
                -- TODO: Add thunder noise
            end
        end

        player_boat:update(dt)
        camera:follow(player_boat.pos.x, player_boat.pos.y)

        level.update(dt)
    end
end

local pauseYs = {-30, -30, -30}

function state:draw()
	love.graphics.setCanvas(screen)
        love.graphics.clear()
        
        sea_noise:send("vars", {camera.x, camera.y, (not stormy and 1 or 64) * love.timer.getTime()})
        love.graphics.setShader(sea_noise)
        love.graphics.rectangle("fill", 0, 0, w/2, h)
        love.graphics.setShader()

        camera:attach()
            -- Draw in any order
            Obstacles.draw()
            Enemies.draw()
            Particles.draw()
            player_boat:draw()

            -- Actually render
            sortedDraw()
        camera:detach()
        camera:draw()
        
        if stormy then
            rain_noise:send("vars", {camera.x, camera.y, 64 * love.timer.getTime()})
            love.graphics.setShader(rain_noise)
            love.graphics.rectangle("fill", 0, 0, w/2, h)
            love.graphics.setShader()
        end
    
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

    
    if (paused) then
        love.graphics.setCanvas(pauseScreen)
            love.graphics.clear(0, 0, 0, 1)
            love.graphics.setFont(pauseFont)
            love.graphics.setColor(1, 1, 1)
            local txt
            txt = "GAME PAUSED"
            love.graphics.print(txt, w/2, pauseYs[1], 0, 1, 1, love.graphics.getFont():getWidth(txt)/2, 0)
            txt = "[ESC] to continue."
            love.graphics.print(txt, w/2, pauseYs[2], 0, 1, 1, love.graphics.getFont():getWidth(txt)/2, 0)
            txt = "[M] to return to main menu."
            love.graphics.print(txt, w/2, pauseYs[3], 0, 1, 1, love.graphics.getFont():getWidth(txt)/2, 0)
        love.graphics.setCanvas()

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setBlendMode('alpha', 'premultiplied')
        love.graphics.draw(pauseScreen, 0, 0, 0, cur_w/w, cur_h/h)
        love.graphics.setBlendMode('alpha')
    end
end

function state:keypressed(key, unicode)
    if key == "escape" then
        paused = not paused
        love.mouse.setGrabbed(not paused)
        love.mouse.setVisible(paused)

        if paused then
            pauseYs = {-30, -30, -30}
            flux.to(pauseYs, 0.3, {h * 0.25, h * 0.35, h * 0.45})
        end
    end
    if paused and key == "m" then
        paused = false
        love.mouse.setGrabbed(not paused)
        love.mouse.setVisible(paused)
        lovelyMoon.switchState("game", "title")
    end
end

function state:keyreleased(key, unicode)
	
end

function state:mousepressed(x, y, button)
	
end

function state:mousereleased(x, y, button)
	
end

return state