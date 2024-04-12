local day06 = {}

day06.raskeycounter = function(rl)
	local string_byte = string.byte
	local line = rl()
	local vt = nil
	while line and line ~= "" do
		vt = vt or {}
		local ix = 1
		local byte = string_byte(line, ix)
		while byte do
			vt[byte] = (vt[byte] or 0) + 1
			ix = ix + 1
			byte = string_byte(line, ix)
		end
		line = rl()
	end
	if vt == nil then
		return nil
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
	local grp = nmrof_letters(rl)
	while grp do
		result[#result + 1] = grp
		grp = nmrof_letters(rl)
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
