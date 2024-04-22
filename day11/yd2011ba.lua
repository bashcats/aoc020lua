local day11 = {}

day11.parse = function(rl)
	local string_byte = string.byte
	local ck = function(x, y)
		return tostring(x) .. "-*-" .. tostring(y)
	end
	local CHAIR, FLOOR = string_byte("L"), string_byte(".")
	local grid = {}
	local chairs = {}

	local line = rl()
	local width = #line
	local y = 0
	while line do
		y = y + 1
		local row = {}
		for x = 1, width do
			local byte = string_byte(line, x)
			if byte == CHAIR then
				local loc = ck(x, y)
				chairs[loc] = {
					occupied = false,
					dim = {
						loc = loc,
						x = x,
						y = y,
					},
				}
				row[x] = true
			elseif byte == FLOOR then
				row[x] = false
			else
				error("unrecognised byte: should be chair(L) or floor(.)")
			end
		end

		grid[y] = row
		line = rl()
	end
	return grid, width, y, chairs, ck
end

day11.make_iter_dxdy = function()
	local ct = { -1, -1, -1, 0, -1, 1, 0, -1, 0, 1, 1, -1, 1, 0, 1, 1 }
	return function()
		local i = 1
		return function()
			local dx, dy = ct[i], ct[i + 1]
			if dx == nil then
				return nil
			end
			i = i + 2
			return dx, dy
		end
	end
end

day11.solve = function(grid, w, h, chairs, ck)
	local iter_dxdy = day11.make_iter_dxdy()
	local countn = function(v)
		local dxdy = iter_dxdy()
		local nn = 0
		for _ = 1, 8 do
			local dirocc = false
			local dx, dy = dxdy()
			local cx, cy = v.dim.x + dx, v.dim.y + dy
			while cx <= w and cx >= 1 and cy <= h and cy >= 1 do
				local spot = chairs[ck(cx, cy)]
				if spot then
					if spot.occupied then
						dirocc = true
					end
					break
				end
				cx, cy = cx + dx, cy + dy
			end
			if dirocc then
				nn = nn + 1
			end
		end
		return nn
	end

	local stable = false
	while not stable do
		local to_true = {}
		local lyy = 0
		local to_false = {}
		local lnn = 0
		for _, v in pairs(chairs) do
			if not v.occupied then
				if countn(v) == 0 then
					lyy = lyy + 1
					to_true[lyy] = v
				end
			else
				if countn(v) >= 5 then
					lnn = lnn + 1
					to_false[lnn] = v
				end
			end
		end
		for _, v in ipairs(to_false) do
			v.occupied = false
		end
		for _, v in ipairs(to_true) do
			v.occupied = true
		end

		stable = (lyy == 0) and (lnn == 0)
	end
	local result = 0
	for _, v in pairs(chairs) do
		if v.occupied then
			result = result + 1
		end
	end
	return result
end

local ans = day11.solve(day11.parse(io.read))
print(ans)
