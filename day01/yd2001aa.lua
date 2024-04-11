local day01 = {}

day01.solve = function(rl)
	local line = rl()

	local seen = {}
	while line do
		local nmr = tonumber(line)
		if not nmr then
			error("tonumber error: bad input")
		end
		if seen[2020 - nmr] then
			return (2020 - nmr) * nmr
		end
		seen[nmr] = true
		line = rl()
	end
end

local ans = day01.solve(io.read)
print(ans)
