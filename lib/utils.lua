function lerp(a,b,t) return a * (1-t) + b * t end
function math.clamp(low, n, high) return math.min(math.max(n, low), high) end

function isVisible(x, y, w, h)
	return x + w >= 0 and y + h >= 0 and x <= w and y <= h
end

local _channels = { }
local _sounds = { }
--_sounds.hit = love.sound.newSoundData ( "hit.ogg" )

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