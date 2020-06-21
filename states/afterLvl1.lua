local state = {}

local screen = love.graphics.newCanvas(w, h)

function state:new()
	return lovelyMoon.new(self)
end

local font20
local pointer_img
local text
local buttons

local img = nil

function state:load()
    font20 = love.graphics.newFont("PERTILI.TTF", 20, "mono")

    pointer_img = love.graphics.newImage("gfx/pointer.png")

    text = {
        {s = "ONWARDS", f = font20, y = 0, ty = h/2 + 140},
        {s = "You CLEARED THE FIRST TRIAL", f = font20, y = 0, ty = 20},
    }

    buttons = {
        quit = {
            t = text[1],
            txt = text[1].s,
            hovered = false,
            onClick = function()
                cur_level = 2
                lovelyMoon.switchState("afterLvl1", "map")
            end
        },
    }

    img = love.graphics.newImage("gfx/after1.png")
end

function state:close()
	
end

function state:enable()
    for i,v in ipairs(text) do
        v.y = -v.f:getHeight(v.s)
    end

    flux.to(text[1], 1.2, {y = text[1].ty}):ease("backout"):delay(1.4)
    flux.to(text[2], 1.2, {y = text[2].ty}):ease("backout")
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

    love.graphics.draw(img, (w - img:getWidth() - 1)/2, (h - img:getHeight() - 1)/2)

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