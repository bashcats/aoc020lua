local day12 = {}

day12.parse = function(rl)
	local string_match = string.match
	local line = rl()

	local opt = {}
	local dist = {}
	local y = 0
	while line do
		y = y + 1
		local op, di = string_match(line, "(%w)(%d+)")
		opt[y] = op
		if op == "R" or op == "L" then
			dist[y] = tonumber(di) / 90
		else
			dist[y] = tonumber(di)
		end
		line = rl()
	end
	
	return y, opt, dist
end

day12.create_ship = function()
	local xy = { 0, 0 }
	local dir = 1
	local dt = {
		{ 1, 0 },
		{ 0, 1 },
		{ -1, 0 },
		{ 0, -1 },
	}
	return {
		F = function(m)
			xy[1] = xy[1] + m * dt[dir][1] 
			xy[2] = xy[2] + m * dt[dir][2] 
		end,
		N = function(m)
			xy[2] = xy[2] - m
		end,
		S = function(m)
			xy[2] = xy[2] + m
		end,
		W = function(m)
			xy[1] = xy[1] - m
		end,
		E = function(m)
			xy[1] = xy[1] + m
		end,
		R = function(m)
			for _ = 1, m do
				if dir == 4 then
					dir = 1
				else
					dir = dir + 1
				end
			end
		end,
		L = function(m)
			for _ = 1, m do
				if dir == 1 then
					dir = 4
				else
					dir = dir - 1
				end
			end
		end,
		XY = function()
			return xy[1], xy[2]
		end,
	}
end


day12.solve = function(ninstructs, opt, dist)
	local ship = day12.create_ship()
	for i = 1, ninstructs do
		ship[opt[i]](dist[i])
	end
	local x, y = ship.XY()
	return  math.abs(x) + math.abs(y)
end

local ans = day12.solve(day12.parse(io.read))
print(ans)

