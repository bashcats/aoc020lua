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

day09.solve = function(nums, nmr_nums)
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


local ans = day09.solve(day09.parse(io.read))
print(ans)
