w, h = 640, 360
love.graphics.setDefaultFilter("nearest", "nearest", 0)

-- Overall Libraries
require "lib.autobatch"
lovelyMoon = require "lib/lovelyMoon"
states = {}
Object = require "lib/classic"
require "lib/utils"
flux = require "lib/flux"
anim8 = require 'lib/anim8'

cur_level = 2

function love.load()
	states.title = lovelyMoon.addState("states.title", "title")
	states.intro = lovelyMoon.addState("states.intro", "intro")
	states.controls = lovelyMoon.addState("states.controls", "controls")
    states.credits = lovelyMoon.addState("states.credits", "credits")
	states.game = lovelyMoon.addState("states.game", "game")
	states.map = lovelyMoon.addState("states.map", "map")
	states.gameover = lovelyMoon.addState("states.gameover", "gameover")
	
	states.afterLvl1 = lovelyMoon.addState("states.afterLvl1", "afterLvl1")
	states.afterLvl1 = lovelyMoon.addState("states.afterLvl2", "afterLvl2")

	lovelyMoon.enableState("title")
end

function love.update(dt)
	flux.update(dt)
	lovelyMoon.event.update(dt)
end

function love.draw()
	lovelyMoon.event.draw()
end

function love.keypressed(key, unicode)
    if key == "escape" then
        love.event.quit()
    end
	lovelyMoon.event.keypressed(key, unicode)
end

function love.keyreleased(key, unicode)
	lovelyMoon.event.keyreleased(key, unicode)
end

function love.mousepressed(x, y, button)
	lovelyMoon.event.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	lovelyMoon.event.mousereleased(x, y, button)
end