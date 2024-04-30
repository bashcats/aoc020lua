local byter = {}



byter.create_tobits = function(nbits)
	local bigpot = 2 ^ (nbits - 1)
	return function(n)
		local pot = bigpot
		local result = {}
		for i = 1, nbits do
			if n >= pot then
				n = n - pot
				result[i] = true
			else
				result[i] = false
			end
			pot = pot / 2
		end
		return result
	end
end


byter.create_frombits = function(nbits)
	local bigpot = 2 ^ (nbits - 1) 
	return function(t)
		local pot = bigpot
		local result = 0
		for i = 1, nbits do
			if t[i] == true then
				result = result + pot
			end
			pot = pot / 2
		end
		return result
	end
end


local day13 = {}

day13.create_readmask = function(nskip, nbits, abyte, bbyte, cbyte)
	local string_byte = string.byte
	nbits = nskip + nbits
	if cbyte then
		return function(line)
			local owdices = {}
			local chdices = {}
			for i = 1 + nskip, nbits do
				local byte = string_byte(line, i)
				 if byte == abyte then
					 owdices[#owdices+1] = i - nskip
				 elseif byte == cbyte then
					 chdices[#chdices+1] = i - nskip
				 end
			end
			return owdices, chdices
		end

	end
	return function(line)
		local atab, btab = {}, {}
		for i = 1 + nskip, nbits do
			local byte = string_byte(line, i)
			 if byte == abyte then
				 atab[#atab+1] = i - nskip
			 elseif byte == bbyte then
				 btab[#btab+1] = i - nskip
			 end
		end
		return atab, btab
	end
end

day13.parse = function(rl)
	local NBITS = 36
	local string_byte = string.byte
	local string_match = string.match
	local readmask = day13.create_readmask(7, NBITS, string_byte("1"), string_byte("0"), string_byte("X"))
	local SNDMASK = string_byte("a")
	local SNDMEM = string_byte("e")
	
	local result = {}
	local line = rl()
	local y = 0
	while line do
		y = y + 1
		local secondbyte = string_byte(line, 2)
		if secondbyte == SNDMASK then
			local owdices, chdices = readmask(line)
			result[y] = {
				op = "SETMASK",
				arg = { owdices, chdices },
			}
		elseif secondbyte == SNDMEM then
			local address, value = string_match(line, "mem%[(%d+)%] = (%d+)")
			address = tonumber(address)
			value = tonumber(value)
			result[y] = {
				op = "WRITE",
				arg = { address, value }, 
			}
		else
			error("Unrecognised instruction")
		end

		line = rl()
	end
	return result, y, NBITS
end


day13.create_iter_addresses = function()
	local pots = {}
	return function(bt, indices, frombits)
		local n = #indices
		local stop = pots[n]
		if not stop then
			stop = 2 ^ n
			pots[n] = stop
		end
		local count = -1
		return function()
			count = count + 1
			if count == stop then
				return nil
			end
			local cc = count
			local pot = 2
			local i = 0
			while pot <= stop do
				i = i + 1 
				local rem = cc % pot
				if rem ~= 0 then
					cc = cc - rem
					bt[indices[i]] = true
				else
					bt[indices[i]] = false
				end

				pot = pot * 2
			end
			return frombits(bt)
		end
	end
end


day13.solve = function(ins, nins, NBITS)
	local tobits = byter.create_tobits(NBITS)
	local frombits = byter.create_frombits(NBITS)
	local iter_addresses = day13.create_iter_addresses()
	local memory = {}
	local wtwfloat = { {}, {} }  -- write to one, float
	for i = 1, nins do
		local instruction = ins[i]
		if instruction.op == "SETMASK" then
			wtwfloat[1] = instruction.arg[1]
			wtwfloat[2] = instruction.arg[2]
		elseif instruction.op == "WRITE" then
			local bt = tobits(instruction.arg[1])
			for _, v in ipairs(wtwfloat[1]) do
				bt[v] = true
			end
			local value = instruction.arg[2]

			for addy in iter_addresses(bt, wtwfloat[2], frombits) do
				memory[addy] = value
			end
		end
		local instruction = ins[i]
	end

	local result = 0
	for k, v in pairs(memory) do
		result = result + v
	end
	return math.floor(result)
end


local ans = day13.solve(day13.parse(io.read))
print(ans)

