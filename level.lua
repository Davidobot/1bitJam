local t = Object:extend()

t.obstacleRef = nil
t.playerBoatRef = nil
t.enemyRef = nil

t.currentLevel = 0
t.data = {
    -- level 1: the race
    {
        stormy = false,
        startPos = {x = w * 0.25, y = 0},
        goalPosY = -99999,
        obstacles = {
            {row = true, randOffset = true, name = "rock", pos = {x = w * 0.1,         y = h * 0.1},   pos2 = {x = w * 0.4,             y = h * 0.1}},
            {row = true, randOffset = true, name = "rock", pos = {x = w * 0.1,           y = h * 0},   pos2 = {x = w * -0.1,           y = h * -0.5}},
            {row = true, randOffset = true, name = "rock", pos = {x = w * 0.4,           y = h * 0},   pos2 = {x = w * 0.75,            y = h * -0.5}},
            {row = true, randOffset = true, name = "rock", pos = {x = w * -0.1,            y = h * -0.6},     pos2 = {x = w * -0.1,   y = h * -1.5}},
            {row = true, randOffset = true, name = "rock", pos = {x = w * 0.75,          y = h * -0.6},   pos2 = {x = w * 0.75,         y = h * -1.5}},
            --{name = "rock", pos = {x = w*0.5,     y = 0}},
            --{name = "rock", pos = {x = w*0.3,     y = -h*0.25}},
            --{name = "rock", pos = {x = w*0.1,     y = -h*0.5}},
            --{name = "rock", pos = {x = w*0.4,     y = -h*0.6}},
            --{name = "rock", pos = {x = w*0.1,     y = -h*0.65}},
            --{name = "rock", pos = {x = w*0.3,     y = -h*1.2}},
        },
        enemies = {
            --{name = "tentacle", pos = {x = w*0.4, y = 0}},
            --{name = "tentacle", pos = {x = w*0, y = -h*1}},
            --{name = "tentacle", pos = {x = w*0.2, y = -h*1-2}},
            --{name = "tentacle", pos = {x = w*0.8, y = -h*1.3}},
            --{name = "tentacle", pos = {x = w*0.5, y = -h*0.5}},
            --{name = "tentacle", pos = {x = w*0, y = -h*0.5}},
            --{name = "racer", pos = {x = w*0.3, y = -h*0.3}},
            --{name = "pirate", pos = {x = w*0.1, y = -h*0.3}},
            {name = "racer", pos = {x = w*1, y = -h*2}},
        },
        startFunc = function()

        end,
        updateFunc = function(dt)
            
        end,
        endFunc = function()

        end
    },
    -- level 2: pirates
    {
        stormy = false,
        startPos = {x = w * 0.25, y = 0},
        goalPosY = -99999,
        obstacles = {
            {name = "rock", pos = {x = 0,         y = 0}},
            {name = "rock", pos = {x = w*0.5,     y = 0}},
            {name = "rock", pos = {x = w*0.3,     y = -h*0.25}},
            {name = "rock", pos = {x = w*0.1,     y = -h*0.5}},
            {name = "rock", pos = {x = w*0.4,     y = -h*0.6}},
            {name = "rock", pos = {x = w*0.1,     y = -h*0.65}},
            {name = "rock", pos = {x = w*0.3,     y = -h*1.2}},
        },
        enemies = {
            {name = "racer", pos = {x = 0, y = 0}},
        },
        startFunc = function()

        end,
        updateFunc = function(dt)
            
        end,
        endFunc = function()

        end
    },
    -- level 3: storm
    {
        stormy = true,
        startPos = {x = w * 0.25, y = 0},
        goalPosY = -99999,
        obstacles = {
            {name = "rock", pos = {x = 0,         y = 0}},
            {name = "rock", pos = {x = w*0.5,     y = 0}},
            {name = "rock", pos = {x = w*0.3,     y = -h*0.25}},
            {name = "rock", pos = {x = w*0.1,     y = -h*0.5}},
            {name = "rock", pos = {x = w*0.4,     y = -h*0.6}},
            {name = "rock", pos = {x = w*0.1,     y = -h*0.65}},
            {name = "rock", pos = {x = w*0.3,     y = -h*1.2}},
        },
        enemies = {
            {name = "racer", pos = {x = 0, y = 0}},
        },
        startFunc = function()

        end,
        updateFunc = function(dt)
            
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
end

function t.loadLevel(index)
    if (index < 1 or index > #t.data) then return end

    t.endCurrentLevel()
    t.currentLevel = index
    t.startCurrentLevel()
end

function t.endCurrentLevel()
    if (t.currentLevel < 1 or t.currentLevel > #t.data) then return end
    Obstacles.clearObstacles()
    t.enemyRef.clearEnemies()

    t.data[t.currentLevel].endFunc()
end

function t.startCurrentLevel()
    stormy = t.data[t.currentLevel].stormy

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
                    posX = posX + love.math.random(-10, 10)
                    posY = posY + love.math.random(-10, 10)
                end

                t.obstacleRef.new(posX, posY, v.name)
            end
        else
            local posX = v.pos.x
            local posY = v.pos.y

            if (v.randOffset) then
                posX = love.math.random(-10, 10)
                posY = love.math.random(-10, 10)
            end

            t.obstacleRef.new(v.pos.x, v.pos.y, v.name)
        end
        
    end
    for i,v in ipairs(t.data[t.currentLevel].enemies) do
        t.enemyRef.spawnEnemy(v.name, v.pos.x, v.pos.y)
    end

    t.data[t.currentLevel].startFunc()
end

return t