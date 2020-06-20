local t = Object:extend()
t.data = {
    --{name = "racer", pos = {x = 0, y = 0}}
    --{name = "pirate", pos = {x = 0, y = 0}}
    --{name = "tentacle", pos = {x = 0, y = 0}}
    --{name = "boss", pos = {x = 0, y = 0}}
}

t.tentacle_img = love.graphics.newImage("gfx/tentacle.png")
t.tentacle_speed = 10

t.playerBoatRef = nil

function t.init(playerBoat)
    t.playerBoatRef = playerBoat
end

function t.spawnEnemy(name, x, y)
    local newEnemy = {name = name, pos = {x = x, y = y}}
    
    if newEnemy == "racer" then

    elseif newEnemy == "pirate" then

    elseif newEnemy == "tentacle" then

    elseif newEnemy == "boss" then

    end
    
    table.insert(t.data, newEnemy)
end

function t.clearEnemies()
    for i, v in ipairs(t.data) do
        v.pos = nil
        t.data[i] = nil
    end
end

function t.update(dt)
    for i,v in ipairs(t.data) do
        if v.name == "racer" then

        elseif v.name == "pirate" then
    
        elseif v.name == "tentacle" then
            local dir = {x = t.playerBoatRef.pos.x - v.pos.x, y = t.playerBoatRef.pos.y - v.pos.y}
            local magnitude = math.abs(dir.x) + math.abs(dir.y)
            dir.x = dir.x / magnitude
            dir.y = dir.y / magnitude

            v.pos.x = v.pos.x + dir.x * t.tentacle_speed * dt
            v.pos.y = v.pos.y + dir.y * t.tentacle_speed * dt
        elseif v.name == "boss" then
    
        end
    end
end

function t.draw()
    love.graphics.setColor(1, 1, 1)
    for i,v in ipairs(t.data) do
        if v.name == "racer" then
            
        elseif v.name == "pirate" then
    
        elseif v.name == "tentacle" then
           love.graphics.draw(t.tentacle_img, v.pos.x, v.pos.y, 0, 1, 1, t.tentacle_img:getWidth() * 0.5, t.tentacle_img:getHeight() * 0.75) 
        elseif v.name == "boss" then
    
        end  
    end
end

return t