local day06 = {}

local havefun = {}
havefun.combine = function(h, t)
	local result = {}
	for k, v in pairs(h) do
		if t[k] then
			result[k] = v
		end
	end
	return result
end
havefun.new_dittocombine = function()
	local combine = havefun.combine
	local ditto = {}
	return ditto, function(h, t)
		if h == ditto then
			return t
		end
		return combine(h, t)
	end
end
day06.raskeycounter = function(rl)
	local string_byte = string.byte
	local line = rl()
	if line == nil or line == "" then
		return nil
	end
	local vt, combine = havefun.new_dittocombine()
	while line and line ~= "" do
		local bt = {}
		local ix = 1
		local byte = string_byte(line, ix)
		while byte do
			bt[byte] = true
			ix = ix + 1
			byte = string_byte(line, ix)
		end
		vt = combine(vt, bt)
		line = rl()
	end
	local keycount = function(t)
		local count = 0
		for _, _ in pairs(t) do
			count = count + 1
		end
		return count
	end
	return keycount(vt)
end
day06.parse = function(rl)
	local nmrof_letters = day06.raskeycounter
	local result = {}
	local group = nmrof_letters(rl)
	while group do
		result[#result + 1] = group
		group = nmrof_letters(rl)
	end
	return result
end

local ans = (function(t)
	local sum = 0
	for i = 1, #t do
		sum = sum + t[i]
	end
	return sum
end)(day06.parse(io.read))
print(ans)
