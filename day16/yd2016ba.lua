local day16 = {}

day16.parse = function(rl)
	local string_match = string.match
	local string_gmatch = string.gmatch
	local parse_rule = function(line)
		local field = string_match(line, "[%w%s]+")
		local ft = {}
		for from, to in string_gmatch(line, "(%d+)-(%d+)") do
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
	local my_ticket = {}
	rl()  -- your ticket
	for nmr in string_gmatch(rl(), "%d+") do
		my_ticket[#my_ticket + 1] = nmr
	end
	rl() -- == ""
	rl() -- nearby tickets:
	local tickets = {}
	local nt = 0
	line = rl()
	while line and line ~= "" do
		nt = nt + 1
		local tic = {}
		local i = 0
		for n in string_gmatch(line, "%d+") do
			i = i + 1
			tic[i] = tonumber(n)
		end
		tickets[nt] = tic
		line = rl()
	end
	return rules, tickets, nt, my_ticket
end


day16.compile_all_valid = function(rules)
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


day16.compile_valid = function(rule)
	return function(n)
		for _, v in ipairs(rule) do
			if n >= v[1] and n <= v[2] then
				return true
			end
		end
		return false
	end
end


day16.remove_invalid = function(tickets, nmr_tickets, allvalid)
	local valid_tickets = {}
	local vnt = 0
	for nt = 1, nmr_tickets do
		local tic = tickets[nt]
		local valid_tic = true
		for _, v in ipairs(tic) do
			if not allvalid(v) then
				valid_tic = false
				break
			end
		end
		if valid_tic then
			vnt = vnt + 1
			valid_tickets[vnt] = tic
		end
	end
	return valid_tickets, vnt
end


day16.eliminate = function(possibilities, nmr_fields, submitted)
	local ok = function(t) for k in pairs(t) do return k end end
	submitted = submitted or {}
	local all_solved = true
	for i, v in ipairs(possibilities) do
		local nk = 0
		for field, _ in pairs(v) do
			nk = nk + 1
		end
		if nk ~= 1 then
			all_solved = false
		else
			local field = ok(v)
			local sub = submitted[i]
			if not sub then
				for icheck, rmv in ipairs(possibilities) do
					if icheck ~= i then
						rmv[field] = nil
					end
				end
			end
			submitted[field] = i
		end
	end
	if all_solved then
		return submitted
	else
		return day16.eliminate(possibilities, nil, submitted)
	end
end


day16.solve = function(rules, tickets, nmr_tickets, my_tickets)
	local allvalid = day16.compile_all_valid(rules)
	local ftt = {}
	local vft = {}
	for k, rule in pairs(rules) do
		vft[k] = day16.compile_valid(rule)
	end

	local nmr_fields = #tickets[1]
	tickets, nmr_tickets = day16.remove_invalid(tickets, nmr_tickets, allvalid)

	local ft = {}
	for fi = 1, nmr_fields do
		local possib = {}
		for k, _ in pairs(rules) do
			possib[k] = true
		end
		for k, _ in pairs(rules) do
			local valid = vft[k]
			for nt = 1, nmr_tickets do
				if not valid(tickets[nt][fi]) then
					possib[k] = nil
					break
				end
			end
		end
		ftt[fi] = possib
	end

	local result = 1
	
	local fieldindices = day16.eliminate(ftt, nmr_fields)
	for field, index in pairs(fieldindices) do
		if string.sub(field, 1, 9) == "departure" then
			result = result * my_tickets[index]
		end
	end

	return result
end


local ans = day16.solve(day16.parse(io.read))
print(ans)

