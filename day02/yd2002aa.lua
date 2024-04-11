local day02 = {}

day02.solve = function(rl)
	local string_match = string.match
	local string_gmatch = string.gmatch
	local re = "(%d+)-(%d+) (%a): (%a+)"

	local result = 0

	local line = rl()
	while line do
		local min, max, letter, pass = string_match(line, re)
		min, max = tonumber(min), tonumber(max)

		local toolong = false
		local occurences = 0
		for _, _ in string_gmatch(pass, letter) do
			if occurences == max then
				toolong = true
				break
			end
			occurences = occurences + 1
		end
		if not toolong and occurences >= min then
			result = result + 1
		end

		line = rl()
	end

	return result
end

local ans = day02.solve(io.read)
print(ans)
