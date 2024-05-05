local day15 = {}

day15.parse = function(rl)
	local result = {} 
	local y = 0
	for n in string.gmatch(rl(), "%d+") do
		y = y + 1
		result[y] = tonumber(n)
	end
	return result, y
end


day15.solve = function(sn, nn)
	local ht = {}
	for i = 1, nn do
		ht[sn[i]] = i
	end
	local pn = sn[nn]
	local turn = nn + 1
	while turn <= 2020 do
		pi = ht[pn]
		local saying
		if pi then
			saying = turn - 1 - pi
		else
			saying = 0
		end
		ht[pn] = turn - 1
		pn = saying

		turn = turn + 1
	end
	return pn
end

local ans = day15.solve(day15.parse(io.read))
print(ans)

