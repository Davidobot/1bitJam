local t = Object:extend()

t.obstacleRef = nil
t.playerBoatRef = nil
t.enemyRef = nil

t.ambient = love.audio.newSource("sfx/ambient.ogg", "stream")
t.ambient:setLooping(true)
t.rain = love.audio.newSource("sfx/rain.ogg", "stream")
t.rain:setLooping(true)

t.currentLevel = 0
t.data = {
    --! level 1: the race
    {
        stormy = false,
        startPos = {x = w * 0.25, y = h * -0.15},
        --startPos = {x = w * 0.9, y = h * -1},
        goalPosY = -99999,
        obstacles = {
            {row = false, randOffset = false, name = "tape", pos = {x = w * 0.9,         y = h * - 1.3}},
            {row = false, randOffset = false, name = "tape", pos = {x = w * 1,         y = h * - 5.5}},
            {row = false, randOffset = false, name = "tape", pos = {x = w * 1.3,         y = h * - 5.5}},

            {row = true, randOffset = true, name = "rock", pos = {x = w * 0.1,         y = h * 0.1},   pos2 = {x = w * 0.4,             y = h * 0.1}},
            {row = true, randOffset = true, name = "rock", pos = {x = w * 0.1,           y = h * 0},   pos2 = {x = w * -0.1,           y = h * -0.5}},
            {row = true, randOffset = true, name = "rock", pos = {x = w * 0.4,           y = h * 0},   pos2 = {x = w * 0.75,            y = h * -0.5}},
            {row = true, randOffset = true, name = "rock", pos = {x = w * -0.1,            y = h * -0.6},     pos2 = {x = w * -0.1,   y = h * -1}},
            {row = true, randOffset = true, name = "rock", pos = {x = w * -0.05,          y = h * -1},   pos2 = {x = w * 0.75,         y = h * -1.2}},
            {row = true, randOffset = true, name = "rock", pos = {x = w * 0.8,          y = h * -0.6},   pos2 = {x = w * 1.3,         y = h * -1.25}},
            {row = true, randOffset = true, name = "rock", pos = {x = w * 1.35,          y = h * -1.3},   pos2 = {x = w * 1.75,         y = h * -1.6}},
            {row = false, randOffset = false, name = "rock", pos = {x = w * 1,          y = h * -1.05}},
            {row = false, randOffset = true, name = "rock", pos = {x = w * 0.75,          y = h * -1.4}},
            {row = false, randOffset = true, name = "rock", pos = {x = w * 1,          y = h * -1.6}},
            {row = false, randOffset = true, name = "rock", pos = {x = w * 1.25,          y = h * -1.8}},
            {row = false, randOffset = true, name = "rock", pos = {x = w * 1.1,          y = h * -2}},
            {row = false, randOffset = true, name = "rock", pos = {x = w * 1.5,          y = h * -2.2}},
            {row = false, randOffset = true, name = "rock", pos = {x = w * 0.9,          y = h * -2.4}},
            {row = false, randOffset = true, name = "rock", pos = {x = w * 1,          y = h * -2.6}},
            {row = false, randOffset = true, name = "rock", pos = {x = w * 0.8,          y = h * -2.8}},
            {row = false, randOffset = true, name = "rock", pos = {x = w * 0.8,          y = h * -3}},
            {row = false, randOffset = true, name = "rock", pos = {x = w * 1.0,          y = h * -4}},
            {row = false, randOffset = true, name = "rock", pos = {x = w * 0.9,          y = h * -4.2}},
            {row = false, randOffset = true, name = "rock", pos = {x = w * 0.74,          y = h * -4.4}},
            {row = false, randOffset = true, name = "rock", pos = {x = w * 0.6,          y = h * -4.6}},
            {row = false, randOffset = true, name = "rock", pos = {x = w * 0.9,          y = h * -4.8}},
            {row = false, randOffset = true, name = "rock", pos = {x = w * 1.24,          y = h * -5}},
        },
        enemies = {
            {name = "racer", pos = {x = w*1.1, y = -h*1.25}},
        },
        startFunc = function()

        end,
        updateFunc = function(dt)
            if (player_boat.pos.y < h * -5.4) then
                lovelyMoon.switchState("game", "afterLvl1")
            end
        end,
        endFunc = function()

        end
    },
    --! level 2: pirates
    {
        stormy = false,
        startPos = {x = w * 0.25, y = 0},
        goalPosY = -99999,
        obstacles = {
            {row = true, randOffset = true, name = "rock", pos = {x = w * -0.5,         y = h * 0.5},   pos2 = {x = w * 0.5,             y = h * 0.5}},
            {row = true, randOffset = true, name = "rock", pos = {x = w * -0.5,         y = h * 0.5},   pos2 = {x = w * -0.5,             y = h * -5}},
            {row = true, randOffset = true, name = "rock", pos = {x = w * 0.5,         y = h * 0.5},   pos2 = {x = w * 0.5,             y = h * -5}},
        },
        enemies = {
            {name = "pirate", pos = {x = w*0.25, y = h*-1}},
            {name = "pirate", pos = {x = w*0.25, y = h*-2}},
            {name = "pirate", pos = {x = w*0.25, y = h*-3}},
            {name = "pirate", pos = {x = w*0.15, y = h*-4}},
            {name = "pirate", pos = {x = w*0.4, y = h*-5}},
            {name = "tentacle", pos = {x = w*-0.5, y = h*-3}},
            {name = "tentacle", pos = {x = w*0.5, y = h*-4}},
            {name = "tentacle", pos = {x = w*0, y = h*-5}},
        },
        startFunc = function()

        end,
        updateFunc = function(dt)
            if (player_boat.pos.y < h * -5) then
                lovelyMoon.switchState("game", "afterLvl2")
            end
        end,
        endFunc = function()

        end
    },
    --! level 3: storm
    {
        stormy = true,
        startPos = {x = w * 0.25, y = 0},
        goalPosY = -99999,
        obstacles = {
            {row = false, randOffset = false, name = "tape", pos = {x = w * 0,         y = h * -8.2}},
            {row = true, randOffset = true, name = "rock", pos = {x = w * -5,         y = h * 0},   pos2 = {x = w * -0.15,             y = h * -8}},
            {row = true, randOffset = true, name = "rock", pos = {x = w * 5,         y = h * 0},   pos2 = {x = w * 0.15,             y = h * -8}},
        },
        enemies = {
            {name = "tentacle", pos = {x = w*-0.1, y = h*0.15}},
            {name = "tentacle", pos = {x = w*0, y =   h*0.2}},
            {name = "tentacle", pos = {x = w*0.1, y = h*0.25}},
            {name = "tentacle", pos = {x = w*0.2, y = h*0.25}},
            {name = "tentacle", pos = {x = w*0.3, y = h*0.25}},
            {name = "tentacle", pos = {x = w*0.4, y = h*0.2}},
            {name = "tentacle", pos = {x = w*0.5, y = h*0.15}},

            {name = "pirate", pos = {x = w*0, y = h*-2}},
           --{name = "pirate", pos = {x = w*0.5, y = h*-2}},

            {name = "pirate", pos = {x = w*0, y = h*-5}},
            --{name = "pirate", pos = {x = w*0.5, y = h*-4}},
        },
        startFunc = function()
            t.tentacleSpawnTimer = 2
            t.tentacleSurprise = true
            t.tentacleSurprise2 = true
        end,
        updateFunc = function(dt)
            t.tentacleSpawnTimer = t.tentacleSpawnTimer - dt
            if (t.tentacleSpawnTimer <= 0) then
                t.tentacleSpawnTimer = t.tentacleSpawnTimer + 2
                local randomRot = (math.pi * 2) * love.math.random()
                local posX = player_boat.pos.x + math.cos(randomRot) * w / 3
                local posY = player_boat.pos.y + math.sin(randomRot) * w / 3

                t.enemyRef.spawnEnemy("tentacle", posX, posY)
            end
            if (t.tentacleSurprise == true and player_boat.pos.y < h*-3) then
                t.tentacleSurprise = false

                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*-0.5, player_boat.pos.y + h*-0)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*-0.45, player_boat.pos.y + h*-0.1)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*-0.4, player_boat.pos.y + h*-0.2)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*-0.35, player_boat.pos.y + h*-0.3)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*-0.3, player_boat.pos.y + h*-0.4)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*-0.25, player_boat.pos.y + h*-0.5)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*-0.2, player_boat.pos.y + h*-0.6)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*-0.15, player_boat.pos.y + h*-0.7)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*-0.1, player_boat.pos.y + h*-0.8)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*-0.05, player_boat.pos.y + h*-0.9)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*0, player_boat.pos.y + h*-1)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*0.05, player_boat.pos.y + h*-1.1)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*0.1, player_boat.pos.y + h*-1.2)
            end

            if (t.tentacleSurprise2 == true and player_boat.pos.y < h*-5) then
                t.tentacleSurprise2 = false

                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*0.5, player_boat.pos.y + h*-0)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*0.45, player_boat.pos.y + h*-0.1)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*0.4, player_boat.pos.y + h*-0.2)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*0.35, player_boat.pos.y + h*-0.3)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*0.3, player_boat.pos.y + h*-0.4)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*0.25, player_boat.pos.y + h*-0.5)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*0.2, player_boat.pos.y + h*-0.6)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*0.15, player_boat.pos.y + h*-0.7)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*0.1, player_boat.pos.y + h*-0.8)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*0.05, player_boat.pos.y + h*-0.9)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*0, player_boat.pos.y + h*-1)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*0.05, player_boat.pos.y + h*-1.1)
                t.enemyRef.spawnEnemy("tentacle", player_boat.pos.x + w*0.1, player_boat.pos.y + h*-1.2)
            end

            if (player_boat.pos.y < h * -8.1) then
                lovelyMoon.switchState("game", "afterLvl3")
            end
        end,
        endFunc = function()

        end
    }
}

function t.init(obstacle, playerBoat, enemies)
    t.obstacleRef = obstacle
    --t.playerBoatRef = playerBoat
    t.enemyRef = enemies
end

function t.update(dt)
    if (t.currentLevel < 1 or t.currentLevel > #t.data) then return end

    t.data[t.currentLevel].updateFunc(dt)

    --[[
    if love.keyboard.isDown("1") then
        t.loadLevel(1)
    elseif love.keyboard.isDown("2") then
        t.loadLevel(2)
    elseif love.keyboard.isDown("3") then
        t.loadLevel(3)
    end
    ]]
end

function t.loadLevel(index)
    if (index < 1 or index > #t.data) then return end

    t.endCurrentLevel()
    t.currentLevel = index
    t.startCurrentLevel()

    --love.mouse.setPosition(0.75 * love.graphics:getWidth(), 0.5 * love.graphics:getHeight())
end

function t.endCurrentLevel()
    if (t.currentLevel < 1 or t.currentLevel > #t.data) then return end
    Obstacles.clearObstacles()
    t.enemyRef.clearEnemies()

    t.data[t.currentLevel].endFunc()

    love.audio.pause(t.ambient)
    love.audio.pause(t.rain)
end

function t.startCurrentLevel()
    --t.ambient:start()
    love.audio.play(t.ambient)
    stormy = t.data[t.currentLevel].stormy
    if stormy then
        love.audio.play(t.rain)
    end

    player_boat = Boat()
    player_boat.isPlayer = true
    player_boat.pos.x = t.data[t.currentLevel].startPos.x
    player_boat.pos.y = t.data[t.currentLevel].startPos.y

    for i,v in ipairs(t.data[t.currentLevel].obstacles) do
        if (v.row) then
            local distBetween = 50
            local vec = {x = v.pos2.x - v.pos.x, y = v.pos2.y - v.pos.y}
            local steps = math.floor(math.dist(v.pos.x, v.pos.y, v.pos2.x, v.pos2.y) / distBetween)

            for i = 1,steps do
                local posX = v.pos.x + vec.x * ((i-1) / (steps-1))
                local posY = v.pos.y + vec.y * ((i-1) / (steps-1))
                if (v.randOffset) then
                    posX = posX + randomOffset(10)
                    posY = posY + randomOffset(10)
                end
                
                local name = v.name
                if name == "rock" and love.math.random() < 0.5 then
                    name = "rock2"
                end
                t.obstacleRef.new(posX, posY, name)
            end
        else
            local posX = v.pos.x
            local posY = v.pos.y

            if (v.randOffset) then
                posX = randomOffset(10)
                posY = randomOffset(10)
            end

            local name = v.name
            if name == "rock" and love.math.random() < 0.5 then
                name = "rock2"
            end
            t.obstacleRef.new(v.pos.x, v.pos.y, name)
        end
        
    end
    for i,v in ipairs(t.data[t.currentLevel].enemies) do
        t.enemyRef.spawnEnemy(v.name, v.pos.x, v.pos.y)
    end

    t.data[t.currentLevel].startFunc()
end

function randomOffset(strength)
    return (love.math.random() - 0.5) * strength
end

return t