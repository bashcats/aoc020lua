local day13 = {}
day13.parse = function(rl)
	local depart = tonumber(rl())
	local itr = string.gmatch(rl(), "%d+")

	local busid = {}
	local bus = itr()
	while bus do
		busid[#busid+1] = tonumber(bus)
		bus = itr()
	end


	return depart, busid, #busid
end


day13.solve = function(depart, busid, nbus)
	local bestrem = math.maxinteger
	local bestbus = -1
	for i = 1, nbus do
		local period = busid[i]
		local rem = period - (depart) % period
		if bestrem > rem then
			bestrem = rem
			bestbus = period
		end
	end
	return bestbus * bestrem
end

local ans = day13.solve(day13.parse(io.read))
print(ans)
