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

--player_boat = nil
t.boatClassRef = nil

function t.init(playerBoat, BoatClass)
    --player_boat = playerBoat
    t.boatClassRef = BoatClass
end

function t.spawnEnemy(name, x, y)
    local newEnemy = t.enemies[name]()
    newEnemy.name = name
    newEnemy.pos = {x = x, y = y}
    newEnemy.w = 40
    newEnemy.attackCoolDown = 0

    newEnemy:onStart(t)
    
    table.insert(t.data, newEnemy)
end

function t.clearEnemies()
    for i, v in ipairs(t.data) do
        t.data[i]:onDestroy(t)
        v.pos = nil
        t.data[i] = nil
    end
end

function t.update(dt)
    for i,v in ipairs(t.data) do
        v:onUpdate(t, dt)

        v.attackCoolDown = math.max(0, v.attackCoolDown - dt)

        -- Physical collision
        if math.dist(v.pos.x, v.pos.y, player_boat.pos.x, player_boat.pos.y) <  v.w and v.attackCoolDown <= 0 then
            camera:shake(10, 1, 60)
            player_boat.mov.current.speed = 50
            player_boat.mov.forward_speed = 0
            player_boat.mov.current.rot = math.atan2(player_boat.pos.y - v.pos.y , player_boat.pos.x - v.pos.x)
            flux.to(player_boat.mov.current, 4, {speed = 0, rot = 0}):ease("quadout")
            player_boat:killSomeone()
            v.attackCoolDown = 1
            
            if v.boat then
                v.boat:killSomeone()
            end
        end
    end

    --destroy all enemies that are marked "dead"
    local i = 1
    while i <= #t.data do
        if (t.data[i].dead == true) then
            t.data[i].pos = nil
            t.data[i]:onDestroy(t)
            table.remove(t, i)
        else
            i = i + 1
        end
    end
end

function t.draw()
    love.graphics.setColor(1, 1, 1)
    for i,v in ipairs(t.data) do
        v:onDraw(t)
    end
end

t.enemies = {}

------------------------------------------------
--! Racer
------------------------------------------------
t.enemies.racer = Object:extend()

function t.enemies.racer:onStart(enemies)
    self.boat = enemies.boatClassRef()
    self.boat.pos.x = self.pos.x
    self.boat.pos.y = self.pos.y
    self.moving = false
    self.t = 0
    self.paddleIndex = 1
end

function t.enemies.racer:onUpdate(enemies, dt)
    if (self.moving == false) then
        if (self.playerBoatRef.pos.y < self.boat.pos.y) then
            self.moving = true
        end
    else
        if (self.paddleIndex <= #enemies.racer_paddles) then
            self.t = v.t + dt
            if (self.t >= enemies.racer_paddles[self.paddleIndex].t) then
                self.boat:paddle(enemies.racer_paddles[self.paddleIndex].left)
                self.t = self.t - enemies.racer_paddles[self.paddleIndex].t
                self.paddleIndex = self.paddleIndex + 1
            end
        end
    end
    self.boat:update(dt)

    self.pos.x = self.boat.pos.x
    self.pos.y = self.boat.pos.y
end

function t.enemies.racer:onDraw(enemies)
    self.boat:draw()
end

function t.enemies.racer:takeDamage(enemies)
    --racer never engaged the player in combat, so it can just ignore damage
end

function t.enemies.racer:onDestroy(enemies)
    self.boat.pos = nil
    self.boat = nil
end

------------------------------------------------
--! Pirate
------------------------------------------------
t.enemies.pirate = Object:extend()
t.enemies.pirate.burning_particleRate = 30
t.enemies.pirate.burning_particleRect = {w = 40, h = 20}
t.enemies.pirate.burning_deathTimer = 5

function t.enemies.pirate:onStart(enemies)
    self.boat = enemies.boatClassRef("pirate")
    self.boat.pos.x = self.pos.x
    self.boat.pos.y = self.pos.y
    self.fireT = enemies.pirate_fireTimer
    self.paddleT = enemies.pirate_paddleTimer
    self.state = "alive"
    self.burning_particleTimer = 0
    self.burning_deathTimer = enemies.enemies.pirate.burning_deathTimer
end

function t.enemies.pirate:onUpdate(enemies, dt)
    if self.state == "alive" then
        if self.paddleT > 0 then
            self.paddleT = self.paddleT - dt
        end

        -- Calculate angle difference between the directions of the boat and the players
        local v1 = {x=math.cos(self.boat.pos.rot), y=math.sin(self.boat.pos.rot)}
        local b = math.atan2(player_boat.pos.y - self.boat.pos.y, player_boat.pos.x - self.boat.pos.x)
        local v2 = {x=math.cos(b), y=math.sin(b)}
        local a = math.deg(math.acos((v1.x*v2.x + v1.y*v2.y) / (((v1.x^2 + v1.y^2)^0.5) * ((v2.x^2 + v2.y^2)^0.5))))
        if math.angleDifference(b, self.boat.pos.rot) < 0 then a = -a end
        
        local dist = math.dist(player_boat.pos.x, player_boat.pos.y, self.boat.pos.x, self.boat.pos.y)
        if (dist > enemies.pirate_seeDistance) then --pirate is too far to see the player so it's not interested in doing anything
            --do nothing lol
        elseif (dist > enemies.pirate_closeDistance) then --pirate is pretty far so it attempts to face the player and paddle towards them
            local left = a < 0
            if self.paddleT <= 0 then
                self.paddleT = enemies.pirate_paddleTimer
                self.boat:paddle(left)
            end
        elseif (dist <= enemies.pirate_closeDistance) then --pirate is pretty close so it tries to turn its side towards the player as an attempt to aim and fire with its cannons
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

            if self.paddleT <= 0 and left ~= nil then
                self.paddleT = enemies.pirate_paddleTimer
                self.boat:paddle(left)
            end           
        end
    elseif self.state == "burning" then
        self.burning_particleTimer = self.burning_particleTimer - dt
        if (self.burning_particleTimer <= 0) then
            self.burning_particleTimer = self.burning_particleTimer + (1 / enemies.enemies.pirate.burning_particleRate)
            for i = 1, 10 do 
                local dx = enemies.enemies.pirate.burning_particleRect.w * (love.math.random() - 0.5)*2
                local dy = enemies.enemies.pirate.burning_particleRect.h * (love.math.random() - 0.5)*2
                local x = dx * math.cos(self.boat.pos.rot) - dy * math.sin(self.boat.pos.rot)
                local y = dx * math.sin(self.boat.pos.rot) + dy * math.cos(self.boat.pos.rot)

                --todo assuming the particle pos is right, spawn a particle there!
                Particles.new(0, 0, "fire", true, function()
                    return self.boat.pos.x + x, self.boat.pos.y + y
                end)
            end
        end
        self.burning_deathTimer = self.burning_deathTimer - dt
        if (self.burning_deathTimer <= 0) then
            self.dead = true
        end
    end

    self.boat:update(dt)

    self.pos.x = self.boat.pos.x
    self.pos.y = self.boat.pos.y
end

function t.enemies.pirate:onDraw(enemies)
    self.boat:draw()
end

function t.enemies.pirate:takeDamage(enemies)
    self.state = "burning"
end

function t.enemies.pirate:onDestroy(enemies)
    self.boat.pos = nil
    self.boat = nil
end

------------------------------------------------
--! Tentacle
------------------------------------------------
t.enemies.tentacle = Object:extend()

function t.enemies.tentacle:onStart(enemies)
    self.g = {}
    self.g.img = enemies.tentacle_img
    self.g.w = 43; self.g.h = 37
    self.g.g = anim8.newGrid(self.g.w, self.g.h, self.g.img:getWidth(), self.g.img:getHeight())
    self.g.t = 0.3; self.g.n = 3
    self.g.anim = anim8.newAnimation(self.g.g('1-'..self.g.n, 1), self.g.t * love.math.random(0.8, 1.2))
    self.w = 20
end

function t.enemies.tentacle:onUpdate(enemies, dt)
    self.g.anim:update(dt)
    local dir = {x = player_boat.pos.x - self.pos.x, y = player_boat.pos.y - self.pos.y}
    local magnitude = math.abs(dir.x) + math.abs(dir.y)
    dir.x = dir.x / magnitude
    dir.y = dir.y / magnitude

    self.pos.x = self.pos.x + dir.x * enemies.tentacle_speed * dt
    self.pos.y = self.pos.y + dir.y * enemies.tentacle_speed * dt
end

function t.enemies.tentacle:onDraw(enemies)
    orderedAnimDraw(self.pos.y + self.g.h/2, self.g.anim, self.g.img, self.pos.x, self.pos.y, 0, 1, 1, self.g.w/2, self.g.h/2)
    --enemies.g.anim:draw(enemies.g.img, v.pos.x, v.pos.y, 0, 1, 1, enemies.g.w * 0.5, enemies.g.h * 0.75)
end

function t.enemies.tentacle:takeDamage(enemies)

end

function t.enemies.tentacle:onDestroy(enemies)

end

return t