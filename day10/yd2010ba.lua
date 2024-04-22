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

local seen = {}
day10.count_arrangements = function(nums, nmr_nums, nseen, jold, thisfunc)
	thisfunc = thisfunc or day10.count_arrangements
	local sc = seen[nseen]
	if sc then return sc end
	if nseen == nmr_nums then
		return 1
	end
	local result = 0
	for i = 1, 3 do
		local j = nums[nseen + i]
		if j and j - jold <= 3 then
			result = result + thisfunc(nums, nmr_nums, nseen + i, j, thisfunc)
		end
	end
	seen[nseen] = result
	return result
end

day10.solve = function(nums, nmr_nums)
	local count
	do
		local seenindices = {}
		local ct = day10.count_arrangements
		count = function(t, nt, ns, jold)
			local si = seenindices[nseen]
			if si then return si end
			local result = ct(nums, nmr_nums, ns, jold, ct)
			seenindices[ns] = result
			return result
		end
	end
	table.sort(nums)
	nums[nmr_nums+1] = nums[nmr_nums] + 3
	nmr_nums = nmr_nums + 1
	return count(nums, nmr_nums, 0, 0)
end


local ans = day10.solve(day10.parse(io.read))
print(ans)
