local day07 = {}
day07.parse = function(rl)
	local sm = string.match
	local result = {}
	local y = 0
	local line = rl()
	local skiplength = #"bagscontainbags"
	while line do
		y = y + 1
		local bag = {
			color = sm(line, "^(%w+ %w+) bags contain"),
		}
		local ix = skiplength + #bag.color

		local leafbag = sm(line, "^no other bags.", ix)
		if leafbag then
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
		result[y] = bag
		line = rl()
	end

	return result
end

local ans = day07.parse(io.read)
for _, v in ipairs(ans) do
	if v.contents == nil then
		print("Leaf: " .. v.color)
	else
		print("Node: " .. tostring(#v.contents))
		local leftpad = "    "
		for _, vv in ipairs(v.contents) do
			print(leftpad .. vv.color)
		end
	end
end
print(#ans)
