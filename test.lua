--[[
--    A small utility library to aid productivity, tidiness and
--    to improve upon Lua's lack of well-needed functions.
--
--
--    Released under the zlib/libpng public license:
--    
--    Copyright (c) 2013 Nathan Cousins
--    
--    This software is provided 'as-is', without any express or implied
--    warranty. In no event will the authors be held liable for any damages
--    arising from the use of this software.
--    
--    Permission is granted to anyone to use this software for any purpose,
--    including commercial applications, and to alter it and redistribute it
--    freely, subject to the following restrictions:
--    
--       1. The origin of this software must not be misrepresented; you must not
--       claim that you wrote the original software. If you use this software
--       in a product, an acknowledgment in the product documentation would be
--       appreciated but is not required.
--    
--       2. Altered source versions must be plainly marked as such, and must not be
--       misrepresented as being the original software.
--    
--       3. This notice may not be removed or altered from any source
--       distribution.
--]]


require 'utils'



--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
--------------------------------
--  Test related functions.
--------------------------------
--//////////////////////////////



function check(name, func)
	
	local success, err = func()
	
	io.write("Starting " .. name .. " test...")
	
	if not success then
		print()
		error(name .. ": Test failed" .. ((err == nil) and (".") or (": " .. err)), 2)
	end
	
	io.write("done\n")
	
end


function errmsg(expression, expected, got)
	
	return "\"" .. expression .. "\" should have returned "
	.. tostring(expected) .. " (a " .. type(expected) .. " value), "
	.. "got " .. tostring(got) .. " (a " .. type(got) .. " value)"
	
end


--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
--------------------------------
--  Testing.
--------------------------------
--//////////////////////////////


check("isnil", function()
	
	local result
	
	result = isnil(nil)
	if result ~= true then
		return false, errmsg("isnil(nil)", true, result)
	end
	
	result = isnil('')
	if result ~= false then
		return false, errmsg("isnil('')", false, result)
	end
	
	result = isnil(0)
	if result ~= false then
		return false, errmsg("isnil(0)", false, result)
	end
	
	return true
	
end)


check("isnumber", function()
	
	local result
	
	result = isnumber(-1.23)
	if result ~= true then
		return false, errmsg("isnumber(-1.23)", true, result)
	end
	
	result = isnumber('-1.23')
	if result ~= false then
		return false, errmsg("isnumber('-1.23')", false, result)
	end
	
	return true
	
end)


check("isstring", function()
	
	result = isstring('')
	if result ~= true then
		return false, errmsg("isstring('')", true, result)
	end
	
	result = isstring(nil)
	if result ~= false then
		return false, errmsg("isstring(nil)", false, result)
	end
	
	return true
	
end)


check("isboolean", function()
	
	local result
	
	result = isboolean(false)
	if result ~= true then
		return false, errmsg("isboolean(false)", true, result)
	end
	
	result = isboolean(1)
	if result ~= false then
		return false, errmsg("isboolean(1)", false, result)
	end
	
	return true
	
end)


check("istable", function()
	
	local result
	
	result = istable({})
	if result ~= true then
		return false, errmsg("istable({})", true, result)
	end
	
	result = istable(nil)
	if result ~= false then
		return false, errmsg("istable({})", false, result)
	end
	
	return true
	
end)


check("isfunction", function()
	
	local result
	
	result = isfunction(function()end)
	if result ~= true then
		return false, errmsg("isfunction(function()end)", true, result)
	end
	
	result = isfunction(isfunction)
	if result ~= true then
		return false, errmsg("isfunction(isfunction)", true, result)
	end
	
	result = isfunction(nil)
	if result ~= false then
		return false, errmsg("isfunction(nil)", false, result)
	end
	
	return true
	
end)


check("isthread", function()
	
	local result
	
	result = isthread(coroutine.create(function()end))
	if result ~= true then
		return false, errmsg("isthread(coroutine.create(function()end))", true, result)
	end
	
	result = isthread(function()end)
	if result ~= false then
		return false, errmsg("isthread(function()end)", false, result)
	end
	
	return true
	
end)


check("isuserdata", function()
	
	local result
	
	result = isuserdata({})
	if result ~= false then
		return false, errmsg("isuserdata({})", false, result)
	end
	
	return true
	
end)


check("switch", function()
	
	local result
	
	local cases = {
		[1] = function() return 50 end,
		[2] = function() return 20 end,
		[3] = function() return 60 end,
		["2"] = function() return -2 end
	}
	
	local default = function() return false end
	
	result = switch('2', cases, default)
	if result ~= -2 then
		return false, errmsg("switch('2', cases, default)", -2, result)
	end
	
	result = switch('nonexistantcase', cases, default)
	if result ~= false then
		return false, errmsg("switch('nonexistantcase', cases, default)", false, result)
	end
	
	return true
	
end)


check("tobool", function()
	
	local result
	
	result = tobool(0)
	if result ~= false then
		return false, errmsg("tobool(0)", false, result)
	end
	
	result = tobool(-51204609.2974)
	if result ~= true then
		return false, errmsg("tobool(-51204609.2974)", true, result)
	end
	
	result = tobool('')
	if result ~= false then
		return false, errmsg("tobool('')", false, result)
	end
	
	result = tobool('true')
	if result ~= true then
		return false, errmsg("tobool('true')", true, result)
	end
	
	result = tobool(nil)
	if result ~= false then
		return false, errmsg("tobool('nil')", false, result)
	end
	
	result = tobool({})
	if result ~= true then
		return false, errmsg("tobool('{}')", true, result)
	end
	
	return true
	
end)


check("math.clamp", function()
	
	local result
	
	result = math.clamp(-10, 1.5, 10)
	if result ~= 1.5 then
		return false, errmsg("math.clamp(-10, 1.5, 10)", 1.5, result)
	end
	
	result = math.clamp(10.1, 1, 10)
	if result ~= 10 then
		return false, errmsg("result = math.clamp(10.1, 1, 10)", 10, result)
	end
	
	result = math.clamp(1.1, 0, 10)
	if result ~= 1.1 then
		return false, errmsg("math.clamp(1.1, 1, 10)", 1.1, result)
	end
	
	return true
	
end)


check("math.dist2", function()
	
	local result
	
	result = math.dist2(-1,-1, -2,-1)
	if result ~= 1 then
		return false, errmsg("math.dist2(-1,-1, -2,-1)", 1, result)
	end
	
	return true
	
end)


check("math.dist3", function()
	
	local result
	
	result = math.dist3(-1,-1,-1, -1,-1,2)
	if result ~= 3 then
		return false, errmsg("SOMETHING", 3, result)
	end
	
	return true
	
end)


check("math.distsqr2", function()
	
	local result
	
	result = math.distsqr2(-1,-1, 1,1)
	if result ~= 8 then
		return false, errmsg("SOMETHING", 8, result)
	end
	
	return true
	
end)


check("math.distsqr3", function()
	
	local result
	
	result = math.distsqr3(-1,-1,-1, 1,1,1)
	if result ~= 12 then
		return false, errmsg("math.distsqr3(-1,-1,-1, 1,1,1)", 12, result)
	end
	
	return true
	
end)


check("math.lerp", function()
	
	local result
	
	result = math.lerp(0.5, 1, 3)
	if result ~= 2 then
		return false, errmsg("math.lerp(0.5, 1, 3)", 2, result)
	end
	
	result = math.lerp(2, -500, 500)
	if result ~= 1500 then
		return false, errmsg("math.lerp(2, -500, 500)", 1500, result)
	end
	
	return true
	
end)


check("math.randomf", function()
	
	local result
	
	result = math.randomf()
	if result < 0 or result >= 1 then
		return false, errmsg("math.randomf()", "0 <= R < 1", result)
	end
	
	result = math.randomf(20)
	if result < 0 or result >= 20 then
		return false, errmsg("math.randomf(20)", "0 <= R < 20", result)
	end
	
	result = math.randomf(-10, -5)
	if result < -10 or result >= -5 then
		return false, errmsg("math.randomf(-10, -5)", "-10 <= R < -5", result)
	end
	
	return true
	
end)


check("math.floor2", function()
	
	local result
	
	result = math.floor2(10.12345678, 6)
	if result ~= 10.123456 then
		return false, errmsg("math.floor2(10.12345678, 6)", 10.123456, result)
	end
	
	return true
	
end)


check("math.fract", function()
	
	local result
	
	result = math.fract(1.0)
	if result ~= 0 then
		return false, errmsg("math.fract(1.0)", 0, result)
	end
	
	result = math.fract(-1.123)
	if result ~= 0.123 then
		return false, errmsg("math.fract(-1.123)", 0.123, result)
	end
	
	return true
	
end)


check("math.ceil2", function()
	
	local result
	
	result = math.ceil2(10.12345678, 6)
	if result ~= 10.123457 then
		return false, errmsg("math.ceil2(10.12345678, 6)", 10.12346, result)
	end
	
	return true
	
end)


check("math.round", function()
	
	local result
	
	result = math.round(5.5)
	if result ~= 6 then
		return false, errmsg("math.round(5.5)", 6, result)
	end
	
	result = math.round(-5.5)
	if result ~= -5 then
		return false, errmsg("math.round(-5.5)", -5, result)
	end
	
	return true
	
end)


check("math.round2", function()
	
	local result
	
	result = math.round2(10.12345678, 6)
	if result ~= 10.123457 then
		return false, errmsg("math.round2(10.12345678, 6)", 10.123457, result)
	end
	
	return true
	
end)


check("math.sign", function()
	
	local result
	
	result = math.sign(-0.1)
	if result ~= -1 then
		return false, errmsg("math.sign(-0.1)", -1, result)
	end
	
	result = math.sign(0)
	if result ~= 1 then
		return false, errmsg("math.sign(0)", 1, result)
	end
	
	result = math.sign(0.1)
	if result ~= 1 then
		return false, errmsg("math.sign(0.1)", 1, result)
	end
	
	return true
	
end)


check("string:append", function()
	
	local result
	
	result = string.append('Hello', ', test!')
	if result ~= "Hello, test!" then
		return false, errmsg("string.append('Hello', ', test!')", "Hello, test!", result)
	end
	
	return true
	
end)


check("string:charat", function()
	
	local result
	
	result = string.charat('12345678', 4)
	if result ~= "4" then
		return false, errmsg("string.charat('12345678', 4)", "4", result)
	end
	
	return true
	
end)


check("string:endswith", function()
	
	local result
	
	result = string.endswith('pacman', 'man')
	if result ~= true then
		return false, errmsg("string.endswith('pacman', 'man')", true, result)
	end
	
	return true
	
end)


check("string:explode", function()
	
	local result
	
	result = string.explode('abcd')
	if result[1] ~= 'a' then
		return false, errmsg("string.explode('abcd')[1]", 'a', result)
	end
	if result[2] ~= 'b' then
		return false, errmsg("string.explode('abcd')[2]", 'b', result)
	end
	if result[3] ~= 'c' then
		return false, errmsg("string.explode('abcd')[3]", 'c', result)
	end
	if result[4] ~= 'd' then
		return false, errmsg("string.explode('abcd')[4]", 'd', result)
	end
	if result[5] ~= nil then
		return false, errmsg("string.explode('abcd')[5]", nil, result)
	end
	
	return true
	
end)


check("string.merge", function()
	
	local result
	
	result = string.merge({'pac', 'man', 5000}, '-')
	if result ~= 'pac-man-5000' then
		return false, errmsg("string.merge({'pac', 'man', 5000}, '-')", 'pac-man-5000', result)
	end
	
	return true
	
end)


check("string:replace", function()
	
	local result
	
	result = string.replace('pacman', 'a', '4')
	if result ~= 'p4cm4n' then
		return false, errmsg("string.replace('pacman', '4')", 'p4cm4n', result)
	end
	
	return true
	
end)


check("string:split", function()
	
	local result
	
	result = string.split('a,b, c, d e,', ',')
	if result[1] ~= "a" then
		return false, errmsg("string.split('a,b, c, d e,', ',')[1]", "a", result[1])
	end
	if result[2] ~= "b" then
		return false, errmsg("string.split('a,b, c, d e,', ',')[2]", "b", result[2])
	end
	if result[3] ~= " c" then
		return false, errmsg("string.split('a,b, c, d e,', ',')[3]", " c", result[3])
	end
	if result[4] ~= " d e" then
		return false, errmsg("string.split('a,b, c, d e,', ',')[4]", " d e", result[4])
	end
	if result[5] ~= nil then
		return false, errmsg("string.split('a,b, c, d e,', ',')[5]", nil, result[5])
	end
	
	result = string.split('a,b, c, d e,')
	if result[1] ~= "a,b," then
		return false, errmsg("string.split('a,b, c, d e,')[1]", "a,b,", result[1])
	end
	if result[2] ~= "c," then
		return false, errmsg("string.split('a,b, c, d e,')[2]", "c,", result[2])
	end
	if result[3] ~= "d" then
		return false, errmsg("string.split('a,b, c, d e,')[3]", "d", result[3])
	end
	if result[4] ~= "e," then
		return false, errmsg("string.split('a,b, c, d e,')[4]", "e,", result[4])
	end
	
	return true
	
end)


check("string:startswith", function()
	
	local result
	
	result = string.startswith('pacman', 'pa')
	if result ~= true then
		return false, errmsg("string.startswith('pacman', 'pa')", true, result)
	end
	
	result = string.startswith('pacman', 'ac')
	if result ~= false then
		return false, errmsg("string.startswith('pacman', 'ac')", false, result)
	end
	
	result = string.startswith('pacman', 'man')
	if result ~= false then
		return false, errmsg("string.startswith('pacman', 'man')", false, result)
	end
	
	return true
	
end)


check("string:trim", function()
	
	local result
	
	result = string.trim('\tHello\n ')
	if result ~= "Hello" then
		return false, errmsg("string.trim('\tHello\n ')", "Hello", result)
	end
	
	return true
	
end)


check("string:trimleft", function()
	
	local result
	
	result = string.trimleft('\tHello\n ')
	if result ~= "Hello\n " then
		return false, errmsg("string.trimleft('\tHello\n ')", "Hello\n ", result)
	end
	
	return true
	
end)


check("string:trimright", function()
	
	local result
	
	result = string.trimright('\tHello\n ')
	if result ~= "\tHello" then
		return false, errmsg("string.trimright('\tHello\n ')", "\tHello", result)
	end
	
	return true
	
end)


check("table.append", function()
	
	local t = {1,2}
	
	table.append(t, {val = 3})
	if t[1] ~= 1 then
		return false, errmsg("table.append(t := {1,2}, {val = 3}); t[1]", 1, t[1])
	end
	if t[2] ~= 2 then
		return false, errmsg("table.append(t := {1,2}, {val = 3}); t[2]", 2, t[2])
	end
	if t[3] ~= 3 then
		return false, errmsg("table.append(t := {1,2}, {val = 3}); t[3]", 3, t[3])
	end
	
	return true
	
end)


check("table.clear", function()
	
	local result
	
	local t = { 1, 2, somekey = 3 }
	
	table.clear(t)
	
	result = #t
	if result ~= 0 then
		return false, errmsg("#t (after table.clear(t))", 0, result)
	end
	
	return true
	
end)


check("table.clearkeys", function()
	
	local result = { 1, 2, somekey = 3 }
	
	table.clearkeys(result)
	
	if result[1] ~= 1 then
		return false, errmsg("t == tref", true, result)
	end
	
	return true
	
end)


check("table.copy", function()
	
	local result
	
	local t = {1, someval = 2}
	
	result = table.copy(t)
	if result == t then
		return false, errmsg("result == t", false, result)
	end
	
	if result[1] ~= t[1] then
		return false, errmsg("result[1] ~= t[1]", false, result)
	end
	
	if result.someval ~= t.someval then
		return false, errmsg("result.someval ~= t.someval", false, result)
	end
	
	return true
	
end)


check("table.count", function()
	
	local result
	
	result = table.count({1,2,3,someval=40,50,60})
	if result ~= 6 then
		return false, errmsg("table.count({1,2,3,someval=40,50,60})", 6, result)
	end
	
	return true
	
end)


check("table.contains", function()
	
	local result
	
	result = table.contains({5,2,4,0}, 4)
	if result ~= true then
		return false, errmsg("table.contains({5,2,4,0}, 4)", true, result)
	end
	
	result = table.contains({5,2,4,0}, nil)
	if result ~= false then
		return false, errmsg("table.contains({5,2,4,0}, nil)", false, result)
	end
	
	return true
	
end)


check("table.empty", function()
	
	local result
	
	result = table.empty({})
	if result ~= true then
		return false, errmsg("table.empty({})", true, result)
	end
	
	result = table.empty({1})
	if result ~= false then
		return false, errmsg("table.empty({1})", false, result)
	end
	
	result = table.empty({key=1})
	if result ~= false then
		return false, errmsg("table.empty({key=1})", false, result)
	end
	
	return true
	
end)


check("table.findfirst", function()
	
	local result
	
	local t = { val = 3, 3, 6, 3, 5, 6, 7, 4, 2 }
	
	result = table.findfirst(t, 3)
	if result ~= 1 then
		return false, errmsg("table.findfirst(t := { val = 3, 3, 6, 3, 5, 6, 7, 4, 2 }, 3)", 1, result)
	end
	
	result = table.findfirst(t, 10)
	if result ~= nil then
		return false, errmsg("table.findfirst(t := { val = 3, 3, 6, 3, 5, 6, 7, 4, 2 }, 10)", nil, result)
	end
	
	result = table.findfirst(t, nil)
	if result ~= nil then
		return false, errmsg("table.findfirst(t := { val = 3, 3, 6, 3, 5, 6, 7, 4, 2 }, nil)", nil, result)
	end
	
	return true
	
end)


check("table.findfirsti", function()
	
	local result
	
	local t = { 3, 6, 3, 5, 6, 7, val = 3, 4, 2 }
	
	result = table.findfirsti(t, 3)
	if result ~= 1 then
		return false, errmsg("table.findfirsti(t := { val = 3, 3, 6, 3, 5, 6, 7, 4, 2 }, 3)", 1, result)
	end
	
	result = table.findfirsti(t, 10)
	if result ~= nil then
		return false, errmsg("table.findfirsti(t := { val = 3, 3, 6, 3, 5, 6, 7, 4, 2 }, 10)", nil, result)
	end
	
	result = table.findfirsti(t, nil)
	if result ~= nil then
		return false, errmsg("table.findfirsti(t := { val = 3, 3, 6, 3, 5, 6, 7, 4, 2 }, nil)", nil, result)
	end
	
	return true
	
end)


check("table.findlast", function()
	
	local result
	
	local t = { val = 3, 3, 6, 3, 5, 6, 7, 4, 2 }
	
	result = table.findlast(t, 3)
	if result ~= 'val' then
		return false, errmsg("table.findlast(t := { val = 3, 3, 6, 3, 5, 6, 7, 4, 2 }, 3)", 'val', result)
	end
	
	result = table.findlast(t, 10)
	if result ~= nil then
		return false, errmsg("table.findlast(t := { val = 3, 3, 6, 3, 5, 6, 7, 4, 2 }, 10)", nil, result)
	end
	
	result = table.findlast(t, nil)
	if result ~= nil then
		return false, errmsg("table.findlast(t := { val = 3, 3, 6, 3, 5, 6, 7, 4, 2 }, nil)", nil, result)
	end
	
	return true
	
end)


check("table.findlasti", function()
	
	local result
	
	local t = { 3, 6, 3, 5, 6, 7, val = 3, 4, 2 }
	
	result = table.findlasti(t, 3)
	if result ~= 3 then
		return false, errmsg("table.findlasti(t := { val = 3, 3, 6, 3, 5, 6, 7, 4, 2 }, 3)", 3, result)
	end
	
	result = table.findlasti(t, 10)
	if result ~= nil then
		return false, errmsg("table.findlasti(t := { val = 3, 3, 6, 3, 5, 6, 7, 4, 2 }, 10)", nil, result)
	end
	
	result = table.findlasti(t, nil)
	if result ~= nil then
		return false, errmsg("table.findlasti(t := { val = 3, 3, 6, 3, 5, 6, 7, 4, 2 }, nil)", nil, result)
	end
	
	return true
	
end)


check("table.findall", function()
	
	local result
	
	local t = { 3, 6, 3, 5, 6, 7, val = 3, 4, 2 }
	
	result = table.findall(t, 3)
	
	for k,v in pairs(result) do
		if t[v] ~= 3 then
			return false, errmsg("t["..v.."]", 3, result)
		end
	end
	
	return true
	
end)


check("table.foreach", function()
	
	local t = { 1, 2, val = 3 }
	
	table.foreach(t, function(k,v) t[k] = v + 1 end)
	
	if t[1] ~= 2 then
		return false, errmsg("t[1]", 2, t[1])
	end
	if t[2] ~= 3 then
		return false, errmsg("t[2]", 3, t[2])
	end
	if t.val ~= 4 then
		return false, errmsg("t.val", 4, t.val)
	end
	
	return true
	
end)


check("table.foreachi", function()
	
	local t = { 1, 2, val = 3 }
	
	table.foreachi(t, function(k,v) t[k] = v + 1 end)
	
	if t[1] ~= 2 then
		return false, errmsg("t[1]", 2, t[1])
	end
	if t[2] ~= 3 then
		return false, errmsg("t[2]", 3, t[2])
	end
	if t.val ~= 3 then
		return false, errmsg("t.val", 3, t.val)
	end
	
	return true
	
end)


check("table.merge", function()
	
	local t = { val = 0, 1, 2 }
	
	table.merge(t, {val = 5, 3}, false)
	
	if t.val ~= 0 then
		return false, errmsg("t.val", 0, t.val)
	end
	
	if t[1] ~= 1 then
		return false, errmsg("t[1]", 1, t[1])
	end
	
	if t[2] ~= 2 then
		return false, errmsg("t[2]", 2, t[2])
	end
	
	if t[3] ~= 3 then
		return false, errmsg("t[3]", 3, t[3])
	end
	
	t = { val = 0, 1, 2 }
	
	table.merge(t, {val = 5, 3})
	
	if t.val ~= 5 then
		return false, errmsg("t.val", 5, t.val)
	end
	
	if t[1] ~= 1 then
		return false, errmsg("t[1]", 1, t[1])
	end
	
	if t[2] ~= 2 then
		return false, errmsg("t[2]", 2, t[2])
	end
	
	if t[3] ~= 3 then
		return false, errmsg("t[3]", 3, t[3])
	end
	
	return true
	
end)


check("table.random", function()
	
	local result
	
	result = table.random({5,6,7,4})
	
	if result < 4 or result > 7 then
		return false, errmsg("result := table.random({5,6,7,4});", "result >= 4 or result <= 7", result)
	end
	
	result = table.random({})
	if result ~= nil then
		return false, errmsg("table.random({})", nil, result)
	end
	
	return true
	
end)


check("table.randomkv", function()
	
	local result
	
	local k
	k, result = table.randomkv({5,6,7,4})
	
	if k == nil or k < 1 or k > 4 then
		return false, errmsg("result := table.random({5,6,7,4});", "k >= 1 and k <= 4", k)
	end
	
	if result < 4 or result > 7 then
		return false, errmsg("result := table.random({5,6,7,4});", "result >= 4 and result <= 7", result)
	end
	
	k, result = table.random({})
	if k ~= nil then
		return false, errmsg("table.random({})", nil, k)
	end
	
	return true
	
end)


check("table.tree", function()
	
	table.tree(_G)
	
	return true
	
end)


--[[
check("TESTNAME", function()
	
	local result
	
	result = SOMETHING
	if result ~= EXPECTED then
		return false, errmsg("SOMETHING", EXPECTED, result)
	end
	
	return true
	
end)
]]


print("\nTests completed successfully.")
io.read()