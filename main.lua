w, h = 640, 360
screen = love.graphics.newCanvas(w, h)
love.graphics.setDefaultFilter("nearest", "nearest", 0)

function love.load()
    love.graphics.setCanvas(screen)
    love.graphics.print("Heyy", 10, 10)
    love.graphics.setCanvas()
end

function love.update(dt)

end

function love.draw()
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