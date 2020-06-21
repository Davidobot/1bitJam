-- Averages an arbitrary number of angles (in radians).
function math.averageAngles(...)
	local x,y = 0,0
	for i=1,select('#',...) do local a= select(i,...) x, y = x+math.cos(a), y+math.sin(a) end
	return math.atan2(y, x)
end
 
-- Returns the distance between two points.
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end
-- Distance between two 3D points:
function math.dist3d(x1,y1,z1, x2,y2,z2) return ((x2-x1)^2+(y2-y1)^2+(z2-z1)^2)^0.5 end
 
-- Returns the angle between two points.
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end
 
-- Returns the closest multiple of 'size' (defaulting to 10).
function math.multiple(n, size) size = size or 10 return math.round(n/size)*size end
 
-- Clamps a number to within a certain range.
function math.clamp(low, n, high) return math.min(math.max(low, n), high) end
 
-- Linear interpolation between two numbers.
function lerp(a,b,t) return (1-t)*a + t*b end
function lerp2(a,b,t) return a+(b-a)*t end
 
-- Cosine interpolation between two numbers.
function cerp(a,b,t) local f=(1-math.cos(t*math.pi))*.5 return a*(1-f)+b*f end
 
-- Normalize two numbers.
function math.normalize(x,y) local l=(x*x+y*y)^.5 if l==0 then return 0,0,0 else return x/l,y/l,l end end
 
-- Returns 'n' rounded to the nearest 'deci'th (defaulting whole numbers).
function math.round(n, deci) deci = 10^(deci or 0) return math.floor(n*deci+.5)/deci end
 
-- Randomly returns either -1 or 1.
function math.rsign() return love.math.random(2) == 2 and 1 or -1 end
 
-- Returns 1 if number is positive, -1 if it's negative, or 0 if it's 0.
function math.sign(n) return n>0 and 1 or n<0 and -1 or 0 end
 
-- Gives a precise random decimal number given a minimum and maximum
function math.prandom(min, max) return love.math.random() * (max - min) + min end

function math.angleDifference(t1, t2)
	return (t1 - t2 + math.pi) % (math.pi * 2) - math.pi
 end

function contains(table, val)
	for i=1,#table do
	   if table[i] == val then 
		  return true
	   end
	end
	return false
 end

-- GRAPHICS --
function isVisible(x, y, ww, hh)
	return x + ww >= 0 and y + hh >= 0 and x <= w and y <= h
end

local perlin = love.filesystem.read("gfx/perlin2d.glsl")
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

rain_noise = love.graphics.newShader(perlin .. [[
	uniform vec3 vars;
	vec4 effect(vec4 colour, Image image, vec2 local, vec2 screen)
	{
		// scale the screen coordinates to scale the noise
		number noise = perlin2d((vars.xy+screen + 32*vec2(0, -vars.z)) / 32);

		// the noise is between -1 and 1, so scale it between 0 and 1
		noise = noise * 0.5 + 0.5;
		if (noise > 0.85) {
			noise = mod(floor(screen.x), 8);
			if (noise >= 7 ) {
				noise = 1.0;
			} else {
				noise = 0.0;
			}
		} else {
			noise = 0.0;
		}

		return vec4(noise, noise, noise, noise);
	}
]])
-- END GRAPHICS --

-- DRAWING
local draw_pile = {}

function orderedDraw(z, drawable,x,y,r,sx,sy,ox,oy)
	local v = {z, drawable,x,y,r,sx,sy,ox,oy}
	table.insert(draw_pile, v)
end

function orderedAnimDraw(z, anim, drawable,x,y,r,sx,sy,ox,oy)
	local v = {z, anim, drawable,x,y,r,sx,sy,ox,oy}
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
			v[2]:draw(v[3], v[4], v[5], v[6], v[7], v[8], v[9], v[10])
		else
			love.graphics.draw(v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9])
		end
	end
	draw_pile = {}
end

-- SOUNDS
local _channels = { }
local _sounds = { }
_sounds.don = love.sound.newSoundData ( "sfx/don.ogg" )
_sounds.ka = love.sound.newSoundData ( "sfx/ka.ogg" )
_sounds.gong = love.sound.newSoundData ( "sfx/gong.ogg" )

function playSound ( sound, volume )
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
	if (volume ~= nil) then
		chan[ free ]:setVolume(volume)
	end
end