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

day13.create_readmask = function(nskip, nbits, abyte, bbyte)
	local string_byte = string.byte
	nbits = nskip + nbits
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
	local readmask = day13.create_readmask(7, NBITS, string_byte("1"), string_byte("0"))
	local SNDMASK = string_byte("a")
	local SNDMEM = string_byte("e")
	
	local result = {}
	local line = rl()
	local y = 0
	while line do
		y = y + 1
		local secondbyte = string_byte(line, 2)
		if secondbyte == SNDMASK then
			local toon, tooff = readmask(line)
			result[y] = {
				op = "SETMASK",
				arg = { toon, tooff },
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


day13.solve = function(ins, nins, NBITS)
	local tobits = byter.create_tobits(NBITS)
	local frombits = byter.create_frombits(NBITS)
	local memory = {}
	local onoff = { {}, {} }
	local mask = function(t)
		for _, v in ipairs(onoff[1]) do
			t[v] = true
		end
		for _, v in ipairs(onoff[2]) do
			t[v] = false
		end
		return t
	end

	for i = 1, nins do
		local instruction = ins[i]
		if instruction.op == "SETMASK" then
			onoff[1] = instruction.arg[1]
			onoff[2] = instruction.arg[2]
		elseif instruction.op == "WRITE" then
			memory[instruction.arg[1]] = mask(tobits(instruction.arg[2]))
		end
		local instruction = ins[i]
	end

	local result = 0
	for k, v in pairs(memory) do
		result = result + frombits(v)
	end
	return math.floor(result)
end


local ans = day13.solve(day13.parse(io.read))
print(ans)

