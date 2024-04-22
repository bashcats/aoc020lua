local day10 = {}

day10.parse = function(rl)
	local result = {}
	local y = 0
	local line= rl()
	while line do
		y = y + 1
		result[y] = tonumber(line)
		line = rl()
	end
	return result, y
end

day10.solve = function(nums, nmr_nums)
	table.sort(nums)
	local jold = 0
	local njo = 0
	local njt = 0
	for i = 1, nmr_nums do
		local jv = nums[i]
		local jdiff = jv - jold
		jold = jv
		if jdiff == 1 then
			njo = njo + 1
		elseif jdiff == 3 then
			njt = njt + 1
		end
	end
	return njo * (njt + 1)
end


local ans = day10.solve(day10.parse(io.read))
print(ans)
