function lerp(a,b,t) return a * (1-t) + b * t end
function math.clamp(low, n, high) return math.min(math.max(n, low), high) end

function isVisible(x, y, ww, hh)
	return x + ww >= 0 and y + hh >= 0 and x <= w and y <= h
end

-- load the noise glsl as a string
local perlin = love.filesystem.read("gfx/perlin2d.glsl")
 
-- prepend the noise function definition to the effect definition
sea_noise = love.graphics.newShader(perlin .. [[
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

local draw_pile = {}

function orderedDraw(z, drawable,x,y,r,sx,sy,ox,oy)
	local v = {z, drawable,x,y,r,sx,sy,ox,oy}
	table.insert(draw_pile, v)
end

function orderedAnimDraw(z, anim, drawable,x,y)
	local v = {z, anim, drawable,x,y}
	v.anim = true
	table.insert(draw_pile, v)
end

local function orderByZ(a, b)
	return a[1] < b[1]
end

function sortedDraw()
	table.sort(draw_pile, orderByZ)
	for i,v in ipairs(draw_pile) do
		if v.anim then
			v[2]:draw(v[3], v[4], v[5])
		else
			love.graphics.draw(v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9])
		end
	end
	draw_pile = {}
end

local _channels = { }
local _sounds = { }
_sounds.don = love.sound.newSoundData ( "sfx/don.wav" )
_sounds.ka = love.sound.newSoundData ( "sfx/ka.wav" )

function playSound ( sound )
	if not _channels[ sound ] then _channels[ sound ] = { } end
	local chan = _channels[ sound ]
	
	local free = 0
	for num, src in pairs ( chan ) do
		if not src:isPlaying ( ) then free = num; break end
	end
	if free == 0 then 
		free = #chan + 1
		chan[ free ] = love.audio.newSource ( _sounds[ sound ] )
	end
	chan[ free ]:play ( )
end