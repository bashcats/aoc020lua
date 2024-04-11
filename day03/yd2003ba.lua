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
	local vec = {
		t12 = { 1, 1 },
		t13 = { 3, 1 },
		t41 = { 5, 1 },
		t42 = { 7, 1 },
		t15 = { 1, 2 },
	}
	local home = { 1, 1 }

	local result = 1
	for _, v in pairs(vec) do
		local x, y = home[1], home[2]
		local encounters = 0
		while true do
			if y > height then
				break
			end
			if matrix[y][x] == true then
				encounters = encounters + 1
			end

			x = x + v[1]
			if x > width then
				x = x - width
			end
			y = y + v[2]
		end
		result = result * encounters
	end
	return result
end

local ans = day03.solve(ras.binarymatrix(io.read))
print(ans)
