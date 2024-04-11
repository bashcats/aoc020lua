local day04 = {}

day04.parse_passport = function(rl, string_gmatch)
	string_gmatch = string_gmatch or string.gmatch

	local result = {}
	local line = rl()
	if line == nil or line == "" then
		return nil
	end

	while line and line ~= "" do
		for k, v in string_gmatch(line, "(%S+):(%S+)") do
			result[k] = v
		end

		line = rl()
	end
	return result
end

day04.parse = function(rl)
	local string_gmatch = string.gmatch
	local parse_pp = day04.parse_passport

	local result = {}
	local y = 0
	local pp = parse_pp(rl, string_gmatch)
	while pp do
		y = y + 1
		result[y] = pp
		pp = parse_pp(rl, string_gmatch)
	end
	return result
end

day04.solve = function(passports)
	local xpd = { "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid" }
	local result = 0
	local nexpected = #xpd
	for i, pp in ipairs(passports) do
		local valid = true
		for i = 1, nexpected do
			local valfoo = pp[xpd[i]]
			if valfoo == nil then
				valid = false
				break
			end
		end
		if valid then
			result = result + 1
		end
	end
	return result
end

local ans = day04.solve(day04.parse(io.read))
print(ans)
