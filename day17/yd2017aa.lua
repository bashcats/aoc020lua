local day17 = {}

day17.parse = function(rl)
	local string_byte = string.byte
	local kc = function(x, y, z)
		return tostring(x) .. "*" .. tostring(y) .. "*" .. tostring(z)
	end
	local CUBE = string_byte("#")
	local result = {}

	local line = rl()
	local width = #line
	local y = 0
	while line do
		y = y + 1
		for x = 1, width do
			if string_byte(line, x) == CUBE then
				result[kc(x, y, 0)] = { x, y, 0 }
			end
		end
		line = rl()
	end
	return result, kc
end


day17.make_iter_neighbours = function()
	local vec = {}
	for x = -1, 1 do
		for y = -1, 1 do
			for z = -1, 1 do
				if z == 0 and y == 0 and x == 0 then
				else
					vec[#vec + 1] = { x, y, z }
				end
			end
		end
	end
	return function(coord)
		local idx = 0
		return function()
			idx = idx + 1
			local v = vec[idx]
			if v == nil
				then return nil
			end
			return { coord[1] + v[1], coord[2] + v[2], coord[3] + v[3] }
		end
	end
end


day17.update = function(cube, iter_neighbours, kc)
	local kct = function(t)
		return kc(t[1], t[2], t[3])
	end
	local newcube = {}
	local coords_to_check = {}
	for k, v in pairs(cube) do
		for nbcoord in iter_neighbours(v) do
			coords_to_check[kct(nbcoord)] = nbcoord
		end
	end
	for k, v in pairs(coords_to_check) do
		local nlive_naybs = 0
		for nbcoord in iter_neighbours(v) do
			if cube[kct(nbcoord)] then
				nlive_naybs = nlive_naybs + 1
			end
		end
		if (nlive_naybs == 3) or nlive_naybs == 2 and cube[k] then
			newcube[k] = v
		end
	end
	return newcube
end


day17.solve = function(cube, kc)
	local NSTEPS = 6
	local iter_neighbours = day17.make_iter_neighbours()

	for i = 1, NSTEPS do
		cube = day17.update(cube, iter_neighbours, kc)
	end
	local result = 0
	for k, v in pairs(cube) do
		result = result + 1
	end

	return result
end


local ans =  day17.solve(day17.parse(io.read))
print(ans)

