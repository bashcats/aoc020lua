day18 = { mt = {} }
day18.mt.__add = function(a, b)
	return day18.mkn(a.int + b.int)
end
day18.mt.__sub = function(a, b)
	return day18.mkn(a.int * b.int)
end
day18.mkn = function(n)
	local result = {}
	result.int = n
	setmetatable(result, day18.mt)
	return result
end


day18.parse = function(rl)
	local string_byte = string.byte
	local SYM = {
		[string_byte("*")] = "TIMES",
		[string_byte("+")] = "PLUS",
		[string_byte("(")] = "OPENPAREN",
		[string_byte(")")] = "CLOSEPAREN",
	}
	local SPACE = string_byte(" ")
	local result = {}
	local line = rl()
	local y = 0
	while line do
		y = y + 1
		local eq = {}
		local ix = 1
		local byte = string_byte(line, ix)
		while byte do
			if byte == nil then
				break
			end
			if byte == SPACE then
				ix = ix + 1
			else
				local sym = SYM[byte]
				if sym == nil then
					local integer = string.match(line, "%d+", ix)
					ix = ix + #integer
					eq[#eq + 1] = { "INTEGER", tonumber(integer) }
				else
					eq[#eq + 1] = { sym }
					ix = ix + 1
				end
			end
			byte = string_byte(line, ix)
		end
		result[y] = eq
		line = rl()
	end
	return result, y
end


day18.build_lua_expression = function(eq)
	local result = {}
	local i = 1
	local tok = eq[i]
	while tok do
		if tok[1] == "OPENPAREN" then
			result[i] = "("
		elseif tok[1] == "CLOSEPAREN" then
			result[i] = ")"
		elseif tok[1] == "INTEGER" then
			result[i] = "day18.mkn(" .. tostring(tok[2]) .. ")"
		elseif tok[1] == "TIMES" then
			-- __sub and __add have equal precedence
			result[i] = "-"
		elseif tok[1] == "PLUS" then
			result[i] = "+"
		else
			error("INVALID TOKEN")
		end
		i = i + 1
		tok = eq[i]
	end
	return table.concat(result, " ")
end


day18.solve = function(maths, nequations)
	local result = 0
	for y = 1, nequations do
		local eq = maths[y]
		local eqstring = day18.build_lua_expression(eq)
		load("cur = " .. eqstring)()
		result = result + cur.int
	end
	return result
end


local ans =  day18.solve(day18.parse(io.read))
print(ans)

