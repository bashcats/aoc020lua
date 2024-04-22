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
	local dxy = { 10, -1 }
	return {
		F = function(m)
			xy[1] = xy[1] + m * dxy[1]
			xy[2] = xy[2] + m * dxy[2] 
		end,
		N = function(m)
			dxy[2] = dxy[2] - m
		end,
		S = function(m)
			dxy[2] = dxy[2] + m
		end,
		W = function(m)
			dxy[1] = dxy[1] - m
		end,
		E = function(m)
			dxy[1] = dxy[1] + m
		end,
		R = function(m)
			for _ = 1, m do
				local xx, yy = dxy[1], dxy[2]
				yy = -1 * yy
				dxy[1], dxy[2] = yy, xx
			end
		end,
		L = function(m)
			for _ = 1, m do
				local xx, yy = dxy[1], dxy[2]
				xx = -1 * xx
				dxy[1], dxy[2] = yy, xx
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
	return math.abs(x) + math.abs(y)
end

local ans = day12.solve(day12.parse(io.read))
print(ans)

