local day08 = {}

day08.parse = function(rl)
	local result = {}
	local y = 0
	
	local line = rl()
	while line do
		local op, sign, nmr = string.match(line, "(%w+) (%W)(%d+)")
		y = y + 1
		result[y] = {
			op = op,
			arg = (sign == "-" and -1 or 1) * nmr
		}
		
		line = rl()
	end
	return result, y
end


day08.solve = function(program, ncodes)
	local accum = 0
	local ptr = 1
	local visited = {}
	while not visited[ptr] do
		visited[ptr] = true
		local instruction = program[ptr]
		local op, arg = instruction.op, instruction.arg
		print(op, arg)
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
	return accum
end


local ans = day08.solve(day08.parse(io.read))
print(ans)

