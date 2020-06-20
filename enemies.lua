local t = Object:extend()
t.data = {
    --{name = "racer", pos = {x = 0, y = 0}}
    --{name = "pirate", pos = {x = 0, y = 0}}
    --{name = "tentacle", pos = {x = 0, y = 0}}
    --{name = "boss", pos = {x = 0, y = 0}}
}

t.racer_paddles = {
    {t = 1, left = false},
    {t = 1, left = true},
    {t = 2, left = false},
    {t = 2, left = true},
    {t = 1, left = false},

    {t = 1, left = false},
    {t = 1, left = true},
    {t = 3, left = true},
    {t = 2, left = false},
}

t.tentacle_img = love.graphics.newImage("gfx/tentacle.png")
t.tentacle_speed = 10

t.pirate_closeDistance = w / 4
t.pirate_seeDistance = w * 0.75
t.pirate_fireTimer = 3
t.pirate_paddleTimer = 2

t.playerBoatRef = nil
t.boatClassRef = nil

function t.init(playerBoat, BoatClass)
    t.playerBoatRef = playerBoat
    t.boatClassRef = BoatClass
end

function t.spawnEnemy(name, x, y)
    local newEnemy = {name = name, pos = {x = x, y = y}}
    
    if newEnemy.name == "racer" then
        newEnemy.boat = t.boatClassRef()
        newEnemy.boat.pos.x = x
        newEnemy.boat.pos.y = y
        newEnemy.moving = false
        newEnemy.t = 0
        newEnemy.paddleIndex = 1
    elseif newEnemy.name == "pirate" then
        newEnemy.boat = t.boatClassRef()
        newEnemy.boat.pos.x = x
        newEnemy.boat.pos.y = y
        newEnemy.fireT = t.pirate_fireTimer
        newEnemy.pirate_paddleTimer = t.pirate_paddleTimer
    elseif newEnemy.name == "tentacle" then

    elseif newEnemy.name == "seagull" then

    elseif newEnemy.name == "boss" then

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
            if (v.moving == false) then
                if (t.playerBoatRef.pos.y < v.pos.y) then
                    v.moving = true
                end
            else
                if (v.paddleIndex <= #t.racer_paddles) then
                    v.t = v.t + dt
                    if (v.t >= t.racer_paddles[v.paddleIndex].t) then
                        v.boat:paddle(t.racer_paddles[v.paddleIndex].left)
                        v.t = v.t - t.racer_paddles[v.paddleIndex].t
                        v.paddleIndex = v.paddleIndex + 1
                    end
                end
            end
            v.boat:update(dt)
        elseif v.name == "pirate" then
            local dist = math.dist(t.playerBoatRef.pos.x, t.playerBoatRef.pos.y, v.pos.x, v.pos.y)
            if (dist > t.pirate_seeDistance) then --pirate is too far to see the player so it's not interested in doing anything
                --do nothing lol
            elseif (dist > t.pirate_closeDistance) then --pirate is pretty far so it attempts to face the player and paddle towards them
                
            else --pirate is pretty close so it tries to turn its side towards the player as an attempt to aim and fire with its cannons
                
            end
        elseif v.name == "tentacle" then
            local dir = {x = t.playerBoatRef.pos.x - v.pos.x, y = t.playerBoatRef.pos.y - v.pos.y}
            local magnitude = math.abs(dir.x) + math.abs(dir.y)
            dir.x = dir.x / magnitude
            dir.y = dir.y / magnitude

            v.pos.x = v.pos.x + dir.x * t.tentacle_speed * dt
            v.pos.y = v.pos.y + dir.y * t.tentacle_speed * dt
        elseif v.name == "seagull" then

        elseif v.name == "boss" then
    
        end
    end
end

function t.draw()
    love.graphics.setColor(1, 1, 1)
    for i,v in ipairs(t.data) do
        if v.name == "racer" then
            v.boat:draw()
        elseif v.name == "pirate" then
    
        elseif v.name == "tentacle" then
           love.graphics.draw(t.tentacle_img, v.pos.x, v.pos.y, 0, 1, 1, t.tentacle_img:getWidth() * 0.5, t.tentacle_img:getHeight() * 0.75)
        elseif v.name == "seagull" then

        elseif v.name == "boss" then
    
        end  
    end
end

return t