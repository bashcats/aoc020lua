local livefun = {}
livefun.iter_range = function(t, start, cap)
	cap = cap or #t
	local ix = start or 1
	ix = ix - 1
	return function()
		if ix >= cap then
			return nil
		end
		ix = ix + 1
		return t[ix]
	end
end

local bsp = {}
bsp.calc = function(itr, n, front, back)
	local size = 1
	for _ = 1, n do
		size = size * 2
	end

	local ix = 0
	for _ = 1, n do
		size = size / 2
		local byte = itr()
		if byte == front then
		elseif byte == back then
			ix = ix + size
		else
			error("unrecognised codepoint")
		end
	end

	return ix
end

local day05 = {}
day05.parse = function(rl)
	local string_byte = string.byte
	local result = {}
	local y = 0
	local line = rl()
	while line do
		y = y + 1
		local ix = 1
		local bt = {}
		local byte = string_byte(line, ix)
		while byte do
			bt[ix] = byte
			ix = ix + 1
			byte = string_byte(line, ix)
		end
		result[y] = bt
		line = rl()
	end
	return result, y
end

day05.solve = function(seatlist, npassengers)
	local bsp_calc = bsp.calc
	local iter_range = livefun.iter_range
	local bt = {
		rf = string.byte("F"),
		rb = string.byte("B"),
		cf = string.byte("L"),
		cb = string.byte("R"),
	}

	local occupied = {}
	local highid = 0
	for pn = 1, npassengers do
		local pst = seatlist[pn]
		local row = bsp_calc(iter_range(pst, 1, 7), 7, bt.rf, bt.rb)
		local col = bsp_calc(iter_range(pst, 8, 10), 3, bt.cf, bt.cb)
		local seatid = row * 8 + col
		occupied[seatid] = true
		if seatid > highid then
			highid = seatid
		end
	end
	local conseq = 0
	for sid = 1, highid do
		if occupied[sid] then
			conseq = conseq + 1
		else
			if conseq > 0 and occupied[sid + 1] then
				return sid
			end
			conseq = 0
		end
	end
end

local ans = day05.solve(day05.parse(io.read))
print(ans)
