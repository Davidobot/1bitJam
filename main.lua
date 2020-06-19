w, h = 640, 360
love.graphics.setDefaultFilter("nearest", "nearest", 0)

-- Overall Libraries
Object = require "lib/classic"
local Camera = require 'lib/Camera'
require "lib/utils"

-- Global Classes
Particles = require "particles"

local Boat = require "boat"

local screen = love.graphics.newCanvas(w/2, h)
local drumScreen = love.graphics.newCanvas(w/2, h)

local boat = Boat()

local drumControls = require "drumControls"

function love.load()
    camera = Camera(w/4, h/2, w/2, h, 0.8)
    camera:setFollowLerp(0.2)
    camera:setFollowLead(40)
    camera:setFollowStyle('TOPDOWN_TIGHT')

    -- load the noise glsl as a string
    local perlin = love.filesystem.read("gfx/perlin2d.glsl")
 
    -- prepend the noise function definition to the effect definition
    perlin_noise = love.graphics.newShader(perlin .. [[
        uniform vec3 vars;
        vec4 effect(vec4 colour, Image image, vec2 local, vec2 screen)
        {
            // scale the screen coordinates to scale the noise
            number noise = perlin2d((vars.xy+screen + vec2(0, -vars.z)) / 32);
 
            // the noise is between -1 and 1, so scale it between 0 and 1
            noise = noise * 0.5 + 0.5;
            if (noise > 0.85) {
                noise = mod(floor(screen.y), 8);
                if (noise >= 7 && mod(floor(screen.x), 8) >= 2) {
                    noise = 1.0;
                } else {
                    noise = 0.0;
                }
            } else {
                noise = 0.0;
            }
 
            return vec4(noise, noise, noise, 1.0);
        }
    ]])
end

function love.update(dt)
    camera:update(dt)
    drumControls.update(dt)

    Particles.update(dt)

    boat:update(dt)
    camera:follow(boat.pos.x, boat.pos.y)
end

function love.draw()
    love.graphics.setCanvas(screen)
        love.graphics.clear()
        
        perlin_noise:send("vars", {camera.x, camera.y, love.timer.getTime()})
        love.graphics.setShader(perlin_noise)
        love.graphics.rectangle("fill", 0, 0, w/2, h)
        love.graphics.setShader()

        camera:attach()
            Particles.draw()
            boat:draw()
        camera:detach()
        camera:draw()
    
    love.graphics.setCanvas(drumScreen)
        love.graphics.clear()
        drumControls.draw()
    love.graphics.setCanvas()

    local cur_w, cur_h, _ = love.window.getMode()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(screen, 0, 0, 0, cur_w/w, cur_h/h)
    love.graphics.draw(drumScreen, cur_w/2, 0, 0, cur_w/w, cur_h/h)
    love.graphics.setBlendMode('alpha')
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "z" then
        boat:paddle(true)
    elseif key == "c" then
        boat:paddle(false)
    end
end