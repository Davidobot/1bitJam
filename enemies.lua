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
t.pirate_seeDistance = w * 1.5
t.pirate_fireTimer = 3
t.pirate_paddleTimer = 0.2

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
        newEnemy.paddleT = t.pirate_paddleTimer
    elseif newEnemy.name == "tentacle" then
        newEnemy.g = {}
        newEnemy.g.img = t.tentacle_img
        newEnemy.g.w = 43; newEnemy.g.h = 37
        newEnemy.g.g = anim8.newGrid(newEnemy.g.w, newEnemy.g.h, newEnemy.g.img:getWidth(), newEnemy.g.img:getHeight())
        newEnemy.g.t = 0.3; newEnemy.g.n = 3
        newEnemy.g.anim = anim8.newAnimation(newEnemy.g.g('1-'..newEnemy.g.n, 1), newEnemy.g.t * love.math.random(0.8, 1.2))
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
            if v.paddleT > 0 then
                v.paddleT = v.paddleT - dt
            end

            -- Calculate angle difference between the directions of the boat and the players
            local v1 = {x=math.cos(v.boat.pos.rot), y=math.sin(v.boat.pos.rot)}
            local b = math.atan2(t.playerBoatRef.pos.y - v.boat.pos.y, t.playerBoatRef.pos.x - v.boat.pos.x)
            local v2 = {x=math.cos(b), y=math.sin(b)}
            local a = math.deg(math.acos((v1.x*v2.x + v1.y*v2.y) / (((v1.x^2 + v1.y^2)^0.5) * ((v2.x^2 + v2.y^2)^0.5))))
            if math.angleDifference(b, v.boat.pos.rot) < 0 then a = -a end
            
            local dist = math.dist(t.playerBoatRef.pos.x, t.playerBoatRef.pos.y, v.boat.pos.x, v.boat.pos.y)
            if (dist > t.pirate_seeDistance) then --pirate is too far to see the player so it's not interested in doing anything
                --do nothing lol
            elseif (dist > t.pirate_closeDistance) then --pirate is pretty far so it attempts to face the player and paddle towards them
                local left = a < 0
                if v.paddleT <= 0 then
                    v.paddleT = t.pirate_paddleTimer
                    v.boat:paddle(left)
                end
            elseif (dist <= t.pirate_closeDistance) then --pirate is pretty close so it tries to turn its side towards the player as an attempt to aim and fire with its cannons
                local left
                local thershold = 2
                if a >= 0 and a <= 90 - thershold then
                    left = true
                elseif a > 90 + thershold and a <= 180 then
                    left = false
                elseif a >= -180 and a <= -90 - thershold then
                    left = true
                elseif a > -90 + thershold and a <= 0 then
                    left = false
                end

                if v.paddleT <= 0 and left ~= nil then
                    v.paddleT = t.pirate_paddleTimer
                    v.boat:paddle(left)
                end           
            end
            v.boat:update(dt)
        elseif v.name == "tentacle" then
            v.g.anim:update(dt)
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
            v.boat:draw()

            --debug distances
            local dist = math.dist(t.playerBoatRef.pos.x, t.playerBoatRef.pos.y, v.pos.x, v.pos.y)
            local debugColor
            if (dist > t.pirate_seeDistance) then
                debugColor = {1, 0, 0}
            elseif (dist > t.pirate_closeDistance) then --pirate is pretty far so it attempts to face the player and paddle towards them
                debugColor = {1, 1, 0}
            else --pirate is pretty close so it tries to turn its side towards the player as an attempt to aim and fire with its cannons
                debugColor = {0, 1, 0}
            end
            love.graphics.setColor(debugColor)
            love.graphics.circle("line", v.boat.pos.x, v.boat.pos.y, 30)
            love.graphics.circle("line", v.boat.pos.x, v.boat.pos.y, 40)
            love.graphics.circle("line", v.boat.pos.x, v.boat.pos.y, 50)
            love.graphics.setColor(1,1,1)
        elseif v.name == "tentacle" then
            orderedAnimDraw(v.pos.y + v.g.h/2, v.g.anim, v.g.img, v.pos.x, v.pos.y, 0, 1, 1, v.g.w/2, v.g.h/2)
           --t.g.anim:draw(t.g.img, v.pos.x, v.pos.y, 0, 1, 1, t.g.w * 0.5, t.g.h * 0.75)
        elseif v.name == "seagull" then

        elseif v.name == "boss" then
    
        end  
    end
end

return t