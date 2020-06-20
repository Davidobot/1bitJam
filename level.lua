local t = Object:extend()

t.obstacleRef = nil
t.playerBoatRef = nil
t.enemyRef = nil

t.currentLevel = 0
t.data = {
    -- level 1
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
    -- level 2
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
    -- level 3
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

function t.init(obstacle, playerBoat)
    t.obstacleRef = obstacle
    t.playerBoatRef = playerBoat
end

function t.update(dt)
    if (index < 0 or index > #t.data) then return end

    t.data[currentLevel].updateFunc(dt)
end

function t.loadLevel(index)
    if (index < 0 or index > #t.data) then return end

    t.endCurrentLevel()
    t.currentLevel = index
    t.startCurrentLevel()
end

function t.endCurrentLevel()
    if (t.currentLevel < 0 or t.currentLevel > #t.data) then return end
    --todo destroy all obstacles
    --todo destroy all enemies
    t.data[currentLevel].endFunc()
end

function t:startCurrentLevel()
    t.playerBoatRef.pos.x = t.data[currentLevel].startPos.x
    t.playerBoatRef.pos.y = t.data[currentLevel].startPos.y

    for i,v in ipairs(t.data[currentLevel].obstacles) do
        t.obstacleRef.new(v.pos.x, v.pos.y, v.name)
    end

    t.data[currentLevel].startFunc()
end

return t