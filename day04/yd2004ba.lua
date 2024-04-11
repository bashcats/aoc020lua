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
	local string_match = string.match
	local xpd = { "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid" }
	local xpf = {
		function(v) -- byr
			return v >= "1920" and v <= "2002"
		end,
		function(v) -- iyr
			return v >= "2010" and v <= "2020"
		end,
		function(v) -- eyr
			return v >= "2020" and v <= "2030"
		end,
		function(v) -- hgt
			local val, unit = string_match(v, "(%d+)(%a+)")
			if unit == "cm" then
				return val >= "150" and val <= "193"
			elseif unit == "in" then
				return val >= "59" and val <= "76"
			else
				return false
			end
		end,
		function(v) -- hcl
			return #v == 7 and #string_match(v, "[0-9a-f]+") == 6
		end,
		function(v) -- ecl
			local ct = { amb = true, blu = true, brn = true, gry = true, grn = true, hzl = true, oth = true }
			return ct[v]
		end,
		function(v) -- pid
			return #string_match(v, "%d+") == 9
		end,
	}
	local result = 0
	local nexpected = #xpd
	assert(#xpf == nexpected, "there is an expected number of xpf functions")
	for _, pp in ipairs(passports) do
		local valid = true
		for i = 1, nexpected do
			local keebar = xpd[i]
			local valfoo = pp[keebar]
			if valfoo == nil then
				valid = false
				break
			end
			if not xpf[i](valfoo) then
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
