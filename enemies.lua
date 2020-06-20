local t = Object:extend()
t.data = {
    --{name = "racer", pos = {x = 0, y = 0}}
    --{name = "pirate", pos = {x = 0, y = 0}}
    --{name = "tentacle", pos = {x = 0, y = 0}}
    --{name = "boss", pos = {x = 0, y = 0}}
}

function t.init()

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
    
        elseif v.name == "boss" then
    
        end
    end
end

function t.draw()
    for i,v in ipairs(t.data) do
        if v.name == "racer" then

        elseif v.name == "pirate" then
    
        elseif v.name == "tentacle" then
    
        elseif v.name == "boss" then
    
        end  
    end
end

return t