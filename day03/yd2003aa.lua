local day03 = {}

local ras = {}
ras.binarymatrix = function(rl, zb, wunbyte, width, height)
	local string_byte = string.byte
	zb = zb or string_byte(".")
	wunbyte = wunbyte or string_byte("#")

	local result = {}
	local y = 0
	local line = rl()

	while line do
		y = y + 1
		local row = {}
		local x = 1
		local byte = string_byte(line, x)
		while byte do
			if byte == zb then
				row[x] = false
			elseif byte == wunbyte then
				row[x] = true
			else
				error("ras.binarymatrix Error: invalid bytecode")
			end
			x = x + 1
			byte = string_byte(line, x)
		end
		x = x - 1

		if width == nil then
			width = x
		elseif x ~= width then
			error("ras.binarymatrix Error: wrong amount of bytes in line")
		end
		result[y] = row
		line = rl()
	end
	if height then
		if height ~= y then
			error("ras.binaryrect Error: y should be equal to height arg")
		end
	else
		height = y
	end

	return result, width, height
end

local day03 = {}

day03.solve = function(matrix, width, height)
	local t13 = { 3, 1 }
	local x, y = 1, 1

	local result = 0
	while true do
		if y > height then
			return result
		end
		if matrix[y][x] == true then
			result = result + 1
		end

		x = x + t13[1]
		if x > width then
			x = x - width
		end
		y = y + t13[2]
	end
end

local ans = day03.solve(ras.binarymatrix(io.read))
print(ans)
