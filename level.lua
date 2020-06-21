local t = Object:extend()

t.obstacleRef = nil
t.playerBoatRef = nil
t.enemyRef = nil

t.currentLevel = 0
t.data = {
    -- level 1: the race
    {
        startPos = {x = w * 0.25, y = 0},
        goalPosY = -99999,
        obstacles = {
            --{name = "rock", pos = {x = 0,         y = 0}},
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
            {name = "tentacle", pos = {x = w*0, y = -h*0.5}},
            --{name = "racer", pos = {x = w*0.3, y = -h*0.3}},
            {name = "pirate", pos = {x = w*0.1, y = -h*0.3}},
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
    player_boat = Boat()
    player_boat.isPlayer = true
    player_boat.pos.x = t.data[t.currentLevel].startPos.x
    player_boat.pos.y = t.data[t.currentLevel].startPos.y

    for i,v in ipairs(t.data[t.currentLevel].obstacles) do
        t.obstacleRef.new(v.pos.x, v.pos.y, v.name)
    end
    for i,v in ipairs(t.data[t.currentLevel].enemies) do
        t.enemyRef.spawnEnemy(v.name, v.pos.x, v.pos.y)
    end

    t.data[t.currentLevel].startFunc()
end

return t