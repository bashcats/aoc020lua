local day16 = {}

day16.parse = function(rl)
	local string_match = string.match
	local string_gmatch = string.gmatch
	local parse_rule = function(line)
		local field = string.match(line, "%w+")
		local ft = {}
		for from, to in string.gmatch(line, "(%d+)-(%d+)") do
			ft[#ft + 1] = { tonumber(from), tonumber(to) }
		end
		return field, ft
	end
	local rules = {}
	local line = rl()
	while line and line ~= "" do
		local field, ft = parse_rule(line)
		rules[field] = ft
		line = rl()
	end
	rl()  -- your ticket:
	line = rl()
	while line and line ~= "" do
		line = rl()
	end
	rl()  -- nearby tickets:
	local tickets = {}
	local nt = 0
	line = rl()
	while line and line ~= "" do
		nt = nt + 1
		local tic = {}
		local i = 0
		for n in string.gmatch(line, "%d+") do
			i = i + 1
			tic[i] = tonumber(n)
		end
		tickets[nt] = tic
		line = rl()
	end
	return rules, tickets, nt
end


day16.compile_scanner = function(rules)
	return function(n)
		for _, t in pairs(rules) do
			for _, v in ipairs(t) do
				if n >= v[1] and n <= v[2] then
					return true
				end
			end
		end
		return false
	end
end


day16.solve = function(rules, tickets, nt)
	local valid = day16.compile_scanner(rules)
	local result = 0
	for _, tic in ipairs(tickets) do
		for _, v in ipairs(tic) do
			if not valid(v) then
				result = result + v
			end
		end
	end
	return result
end


local ans = day16.solve(day16.parse(io.read))
print(ans)

