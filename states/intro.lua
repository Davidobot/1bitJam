local state = {}

local screen = love.graphics.newCanvas(w, h)
local flux = require "lib/flux"

function state:new()
	return lovelyMoon.new(self)
end

local font32, font24, font20
local pointer_img
local text
local buttons
function state:load()
    font32 = love.graphics.newFont("PERTILI.TTF", 32, "mono")
    font24 = love.graphics.newFont("PERTILI.TTF", 24, "mono")
    font20 = love.graphics.newFont("PERTILI.TTF", 20, "mono")

    pointer_img = love.graphics.newImage("gfx/pointer.png")

    text = {
        {s = "BACK", f = font20, y = 0, ty = h/2 + 80},
        {s = "YOU HAVE TO PROVE YOURSELF", f = font20, y = 0, ty = 40},
        {s = "RACE THE FORMER VILLAGE CHAMPION", f = font20, y = 0, ty = 70},
        {s = "THEN VENTURE OUT SEA-WARD", f = font20, y = 0, ty = 110},
        {s = "MAKE YOUR WAY TO THE EYE OF THE STORM", f = font20, y = 0, ty = 140},
        {s = "THERE, YOU WILL FACE YOUR DESTINY - FIGHT IT", f = font20, y = 0, ty = 180},      
    }

    buttons = {
        quit = {
            t = text[1],
            txt = text[1].s,
            hovered = false,
            onClick = function()
                lovelyMoon.switchState("intro", "title")
            end
        }
    }
end

function state:close()
	
end

function state:enable()
    for i,v in ipairs(text) do
        v.y = -v.f:getHeight(v.s)
    end

    flux.to(text[1], 1.2, {y = text[1].ty}):ease("backout"):delay(4.2)
    flux.to(text[2], 1.2, {y = text[2].ty}):ease("backout")
    flux.to(text[3], 1.2, {y = text[3].ty}):ease("backout"):delay(0.8)
    flux.to(text[4], 1.2, {y = text[4].ty}):ease("backout"):delay(1.6)
    flux.to(text[5], 1.2, {y = text[5].ty}):ease("backout"):delay(2.4)
    flux.to(text[6], 1.2, {y = text[6].ty}):ease("backout"):delay(3.2)
end

function state:disable()
	
end

function state:update(dt)
    local mouseX = love.mouse.getX() / love.graphics.getWidth() * w
    local mouseY = love.mouse.getY() / love.graphics.getHeight() * h
    for i,v in pairs(buttons) do
        local ww = v.t.f:getWidth(v.t.s)
        local hh = v.t.f:getHeight(v.t.s) * 0.65 -- 0.65 is magic number for font
        if mouseX >= (w - ww)/2 and mouseX <= (w + ww) / 2 and
           mouseY >= v.t.ty and mouseY <= v.t.ty + hh then
            if v.hovered == false then
                flux.to(v.t, 0.5, {y = v.t.ty + math.sign(v.t.ty + hh/2 - mouseY) * 5}):ease("backout")
                :after(0.5, {y = v.t.ty}):ease("backout")
                v.hovered = true
            end
            v.t.s = ">"..v.txt.."<"
        else
            v.hovered = false
            v.t.s = v.txt
        end
    end
end

local function centeredText(str, y)
    local ww = love.graphics.getFont():getWidth(str)
    love.graphics.print(str, (w - ww)/2, y)
end

function state:draw()
    local mouseX = love.mouse.getX() / love.graphics.getWidth() * w
    local mouseY = love.mouse.getY() / love.graphics.getHeight() * h

    love.graphics.setCanvas(screen)
    love.graphics.clear()

    for i,v in ipairs(text) do
        love.graphics.setFont(v.f)
        centeredText(v.s, v.y)
    end

    love.graphics.draw(pointer_img, mouseX, mouseY)
    love.graphics.setCanvas()

	local cur_w, cur_h, _ = love.window.getMode()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(screen, 0, 0, 0, cur_w/w, cur_h/h)
    love.graphics.setBlendMode('alpha')
end

function state:keypressed(key, unicode)
	
end

function state:keyreleased(key, unicode)
	
end

function state:mousepressed(x, y, button)
	
end

function state:mousereleased(x, y, button)
    local mouseX = love.mouse.getX() / love.graphics.getWidth() * w
    local mouseY = love.mouse.getY() / love.graphics.getHeight() * h
	for i,v in pairs(buttons) do
        local ww = v.t.f:getWidth(v.t.s)
        local hh = v.t.f:getHeight(v.t.s) * 0.65 -- 0.65 is magic number for font
        if mouseX >= (w - ww)/2 and mouseX <= (w + ww) / 2 and
           mouseY >= v.t.ty and mouseY <= v.t.ty + hh then
            if button == 1 then
                v.onClick()
            end
        end
    end
end

return state