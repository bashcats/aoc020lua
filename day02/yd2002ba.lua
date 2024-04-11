local day02 = {}

day02.solve = function(rl)
	local string_match = string.match
	local string_byte = string.byte
	local re = "(%d+)-(%d+) (%a): (%a+)"

	local result = 0

	local line = rl()
	while line do
		local min, max, letter, pass = string_match(line, re)
		min, max = tonumber(min), tonumber(max)
		letter = string_byte(letter)

		if string_byte(pass, min) == letter then
			if string_byte(pass, max) ~= letter then
				result = result + 1
			end
		elseif string_byte(pass, max) == letter then
			result = result + 1
		end

		line = rl()
	end

	return result
end

local ans = day02.solve(io.read)
print(ans)
