local day01 = {}

day01.solve = function(rl)
	local line = rl()

	local seen = {}
	local expenses = {}
	while line do
		local nmr = tonumber(line)
		if not nmr then
			error("tonumber error: bad input")
		end
		local win = seen[2020 - nmr]
		if win then
			return nmr * win[1] * win[2]
		end
		for _, exp in ipairs(expenses) do
			local sum = exp + nmr
			if sum < 2020 then
				seen[sum] = { exp, nmr }
			end
		end
		expenses[#expenses + 1] = nmr
		line = rl()
	end
end

local ans = day01.solve(io.read)
print(ans)
