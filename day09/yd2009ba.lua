local day09 = {}

day09.parse = function(rl)
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

day09.solve_pt1 = function(nums, nmr_nums)
	local ramlength = 25
	local idx = ramlength + 1
	local sot = nums[idx]

	while sot do
		local addsup = false
		for i = 1, ramlength - 1 do
			local n = nums[idx - i]
			for j = i + 1, ramlength do
				local m = nums[idx - j]
				if m + n == sot then
					addsup = true
					break
				end
			end
			if addsup then break end
		end

		if not addsup then return nums[idx] end

		idx = idx + 1
		sot = nums[idx]
	end

end


day09.solve_pt2 = function(nums, nmr_nums)
	local invalid = day09.solve_pt1(nums, nmr_nums)

	local idx = 1
	local ival = nums[idx]
	while ival do
		local sum = ival
		local jdx = idx + 1
		local jval = nums[jdx]
		while jval do
			sum = sum + jval
			if sum == invalid then
				local lo, hi = math.maxinteger, math.mininteger
				for i = idx, jdx do
					local n = nums[i]
					if n < lo then
						lo = n
					end
					if n > hi then
						hi = n
					end
				end

				return lo + hi
			end
			jdx = jdx + 1
			jval  = nums[jdx]
		end
		idx = idx + 1
		ival = nums[idx]
	end
end

day09.solve = day09.solve_pt2
local ans = day09.solve(day09.parse(io.read))
print(ans)
