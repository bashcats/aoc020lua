local day13 = {}
day13.parse = function(rl)
	-- earlier depart estimate is not used in pt 2
	rl() -- so skip the first line
	local itr = string.gmatch(rl(), "%w+")

	local busid = {}
	local tplus = {}
	local bus = itr()
	local shift = 0
	local y = 0
	while bus do
		if bus ~= "x" then
			y = y + 1
			busid[y] = tonumber(bus)
			tplus[y] = shift
		end

		bus = itr()
		shift = shift + 1
	end
	return busid, tplus, y
end

day13.solve = function(busid, tplus, nbus)
	-- a real lcm function is not needed; every bus id is prime
	local lcm = function(a, b)
		return a * b
	end
	local ts = busid[1]
	local period = ts

	for i = 2, nbus do
		local id = busid[i]
		local shift = tplus[i]

		while (ts + shift) % id ~= 0 do
			ts = ts + period
		end
		period = lcm(period, id)
	end
	return ts
end

local ans = day13.solve(day13.parse(io.read))
print(ans)
