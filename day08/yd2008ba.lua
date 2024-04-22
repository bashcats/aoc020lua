local day08 = {}

day08.parse = function(rl)
	local result = {}
	local jumplist = {}
	local noplist = {}
	local y = 0
	
	local line = rl()
	while line do
		y = y + 1
		local op, sign, nmr = string.match(line, "(%w+) (%W)(%d+)")
		if op == "jmp" then
			jumplist[#jumplist+1] = y
		elseif op == "nop" then
			noplist[#noplist+1] = y
		end
		result[y] = {
			op = op,
			arg = (sign == "-" and -1 or 1) * nmr
		}
		
		line = rl()
	end
	
	return result, y, jumplist, noplist

end

day08.iter_ixop = function(jay, enn, jsym, nsym)
	local t = jay
	local i = 1
	local iswitch = #jay + 1
	-- the first ix, op returned should not affect program
	local ixrev, srev = jay[1], jsym
	return function()
		local ix, shout

		if ixrev then
			ix, shout = ixrev, srev
			ixrev, srev = nil, nil
			return ix, shout
		end
		if i == iswitch and t == jay then
			i = 1
			t = enn
			local tempsym = jsym
			jsym = nsym
			nsym = tempsym
		end

		ix = t[i]
		ixrev, srev = ix, jsym
		i = i + 1
		return ix, nsym
	end
end


day08.solve = function(program, ncodes, jt, nt)
	local itr = day08.iter_ixop(jt, nt, "jmp", "nop")
	local accum = 0
	local ptr = 1
	local visited = {}
	ncodes = ncodes + 1
	while ptr ~= ncodes do
		local instruction = program[ptr]
		if visited[ptr] then
			local ix, sym = itr()
			program[ix].op = sym
			ix, sym = itr()
			program[ix].op = sym
			accum = 0
			ptr = 1
			visited = {}
		else
			visited[ptr] = true
			if not instruction then
				error('no instruction')
			end
			local op, arg = instruction.op, instruction.arg
			if op == "acc" then
				accum = accum + arg
				ptr = ptr + 1
			elseif op == "jmp" then
				ptr = ptr + arg
			elseif op == "nop" then
				ptr = ptr + 1
			else
				error("invalid op")
			end
		end


	end
	return accum
end

local ans = day08.solve(day08.parse(io.read))
print(ans)

