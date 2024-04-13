local day07 = {}
day07.parse = function(rl)
	local sm = string.match
	local rules, bgraph = {}, {}
	local y = 0
	local line = rl()
	local skiplength = #"bagscontainbags"
	while line do
		y = y + 1
		local bag = {
			color = sm(line, "^(%w+ %w+) bags contain"),
		}
		local ix = skiplength + #bag.color

		if sm(line, "^no other bags.", ix) then
			bag.contents = nil
		else
			local nib, ibcolor = sm(line, "^(%d+) (%w+ %w+) bag", ix)
			while nib do
				ix = ix + #nib + #ibcolor + 7
				if sm(line, "^s", ix - 2) then
					ix = ix + 1
				end
				local bcontents = bag.contents or {}
				bcontents[#bcontents + 1] = {
					color = ibcolor,
					quantity = tonumber(nib),
				}
				bag.contents = bcontents

				if sm(line, "^%.", ix - 2) then
					break
				end
				nib, ibcolor = sm(line, "^(%d+) (%w+ %w+) bag", ix)
			end
		end
		bgraph[bag.color] = bag.contents
		rules[y] = bag
		line = rl()
	end

	return rules, y, bgraph
end

day07.newsearch = function(bg)
	local search
	search = function(key, mult)
		local contents = bg[key]
		if contents == nil then
			return mult
		end
		local result = mult
		for _, cat in pairs(contents) do
			result = result + search(cat.color, mult * cat.quantity)
		end
		return result
	end
	return search
end
day07.solve = function(rules, nrules, bg)
	local search = day07.newsearch(bg)
	return search("shiny gold", 1) - 1
end

local ans = day07.solve(day07.parse(io.read))
print(ans)
