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
		bgraph[bag.color] = {}
		rules[y] = bag
		line = rl()
	end

	return rules, y, bgraph
end

day07.setrules = function(rules, nrules, bgraph, shinykey)
	local shinybag = bgraph[shinykey or "shiny gold"]
	for i = 1, nrules do
		local b = rules[i]
		local bcontents = b.contents
		local bcolor = b.color
		if bcontents then
			local bag = bgraph[bcolor]
			bag.nkinds = 0
			for ii, v in ipairs(bcontents) do
				local vcolor = v.color
				bag.color = bcolor
				bag.nkinds = bag.nkinds + 1
				bag.contents = bag.contents or {}
				bag.contents[ii] = bgraph[vcolor]
			end
		end
	end
	return bgraph, shinybag, shinykey
end

day07.newsearch = function(sbag)
	local search
	search = function(bg, bagkey)
		local bag = bg[bagkey]
		if not bag then
			return nil
		end
		if bag == sbag then
			return true
		end
		local bcontents = bag.contents
		if bcontents then
			for i = 1, bag.nkinds do
				local ibag = bcontents[i]
				if search(bg, ibag.color) then
					return true
				end
			end
		end
		return false
	end
	return search
end

day07.solve = function(rules, nrules, nodes)
	local bg, shinybag, sk = day07.setrules(rules, nrules, nodes, "shiny gold")
	local search = day07.newsearch(shinybag)
	local rulenames = (function(t, k)
		local length = #t
		local result = {}
		for i = 1, length do
			result[i] = t[i][k]
		end
		return result
	end)(rules, "color")
	local result = 0
	for _, bk in ipairs(rulenames) do
		if bk ~= sk and search(bg, bk) then
			result = result + 1
		end
	end
	return result
end
local ans = day07.solve(day07.parse(io.read))
print(ans)
