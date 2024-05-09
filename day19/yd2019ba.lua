local day19 = {}

day19.parse = function(rl)
	local string_byte = string.byte
	local string_match = string.match
	local QUOTE = string_byte("\"")
	local parsearg = function(arg)
		if string_byte(arg) == QUOTE then
			return { "letter", string_byte(string_match(arg, "%a")) }
		end
		return { "rule", tonumber(arg) }
	end
	local string_gmatch = string.gmatch
	local string_sub = string.sub
	local rules = {}
	local line = rl()
	while line and line ~= "" do
		if line == "8: 42" then
			line = "8: 42 | 42 8"
		elseif line == "11: 42 31" then
			line = "11: 42 31 | 42 11 31"
		end
		local itr = string_gmatch(line, "%S+")
		local rulename = tonumber(string_sub(itr(), 1, -2))
		local parts = {}
		local pt
		for word in itr do
			pt = pt or {}
			if word == "|" then
				parts[#parts + 1] = pt
				pt = nil
			else
				pt[#pt + 1] = parsearg(word)
			end
		end
		if pt then
			parts[#parts + 1] = pt
		end
		rules[rulename] = parts
		line = rl()
	end
	local samples = {}
	line = rl()
	while line do
		samples[#samples + 1] = line
		line = rl()
	end
	return rules, samples
end


day19.matchrule = function(text, rules, rule, position)
	local matches = {}
	for _, attempt in ipairs(rule) do
		local positions = { position }
		for _, rtrv in ipairs(attempt) do
			local rt, rv = rtrv[1], rtrv[2]
			local new_positions = {}
			for _, pos in ipairs(positions) do
				if rt == "rule" then
					for _, p in ipairs(day19.matchrule(text, rules, rules[rv], pos)) do
						new_positions[#new_positions + 1] = p
					end
				else
					if position <= #text and string.byte(text, position) == rv then
						new_positions[#new_positions + 1] = pos + 1
					end
				end
			end
			positions = new_positions

		end
		for _, pos in ipairs(positions) do
			matches[#matches + 1] = pos
		end
	end
	return matches
end


day19.solve = function(rules, samples)
	local nothing = {
		"ababbb",
		"bababa",
		"abbbab",
		"aaabbb",
		"aaaabbb",
	}
	local result = 0
	for _, samp in ipairs(samples) do
		local samplen = #samp
		local rez = day19.matchrule(samp, rules, rules[0], 1)
		for i, v in ipairs(rez) do
			if v - 1 == samplen then 
				result = result + 1
			end
		end
	end
	return result
end


local ans = day19.solve(day19.parse(io.read))
print(ans)

