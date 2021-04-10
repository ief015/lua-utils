--[[
--   Revision: April 10, 2021
--   https://github.com/ief015/lua-utils
--   
--   lua-utils (utils.lua)
--   A small utility library to expand on Lua's standard library with some common functions.
--   
--   MIT License
--   
--   Copyright (c) 2021 Nathan Cousins
--   
--   Permission is hereby granted, free of charge, to any person obtaining a copy
--   of this software and associated documentation files (the "Software"), to deal
--   in the Software without restriction, including without limitation the rights
--   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--   copies of the Software, and to permit persons to whom the Software is
--   furnished to do so, subject to the following conditions:
--   
--   The above copyright notice and this permission notice shall be included in all
--   copies or substantial portions of the Software.
--   
--   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--   SOFTWARE.
--]]


local math   = require 'math'
local string = require 'string'
local table  = require 'table'

local error    = _G.error
local type     = _G.type
local pairs    = _G.pairs
local ipairs   = _G.ipairs
local tostring = _G.tostring



--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
--------------------------------
--  Global utility functions
--------------------------------
--//////////////////////////////



-- Check the type of the given value.
-- 
-- v - The value to examine.
--
-- Returns true if v is nil, else false.
--
function isnil(v)
	return type(v) == 'nil'
end



-- Check the type of the given value.
-- 
-- v - The value to examine.
--
-- Returns true if v is a number, else false.
--
function isnumber(v)
	return type(v) == 'number'
end



-- Check the type of the given value.
-- 
-- v - The value to examine.
--
-- Returns true if v is a string, else false.
--
function isstring(v)
	return type(v) == 'string'
end



-- Check the type of the given value.
-- 
-- v - The value to examine.
--
-- Returns true if v is a boolean, else false.
--
function isboolean(v)
	return type(v) == 'boolean'
end



-- Check the type of the given value.
-- 
-- v - The value to examine.
--
-- Returns true if v is a table, else false.
--
function istable(v)
	return type(v) == 'table'
end



-- Check the type of the given value.
-- 
-- v - The value to examine.
--
-- Returns true if v is a function, else false.
--
function isfunction(v)
	return type(v) == 'function'
end



-- Check the type of the given value.
-- 
-- v - The value to examine.
--
-- Returns true if v is coroutine thread, else false.
--
function isthread(v)
	return type(v) == 'thread'
end



-- Check the type of the given value.
-- 
-- v - The value to examine.
--
-- Returns true if v is userdata, else false.
--
function isuserdata(v)
	return type(v) == 'userdata'
end



-- Check the type of the given value. Errors if the check fails.
-- 
-- v - The value to examine.
--
-- Returns v
--
function checknil(v)
	if isnil(v) then
		return v
	end
	local fn = debug.getinfo(2, 'n').name
	error("bad type in " .. (fn and ("'" .. fn .. "'") or "main chunk") .. " (nil expected, got " .. type(v) .. ")", 2)
end



-- Check the type of the given value. Errors if the check fails.
-- 
-- v - The value to examine.
--
-- Returns v
--
function checknumber(v)
	if isnumber(v) then
		return v
	end
	local fn = debug.getinfo(2, 'n').name
	error("bad type in " .. (fn and ("'" .. fn .. "'") or "main chunk") .. " (number expected, got " .. type(v) .. ")", 2)
end



-- Check the type of the given value. Errors if the check fails.
-- 
-- v - The value to examine.
--
-- Returns v
--
function checkstring(v)
	if isstring(v) then
		return v
	end
	local fn = debug.getinfo(2, 'n').name
	error("bad type in " .. (fn and ("'" .. fn .. "'") or "main chunk") .. " (string expected, got " .. type(v) .. ")", 2)
end



-- Check the type of the given value. Errors if the check fails.
-- 
-- v - The value to examine.
--
-- Returns v
--
function checkboolean(v)
	if isboolean(v) then
		return v
	end
	local fn = debug.getinfo(2, 'n').name
	error("bad type in " .. (fn and ("'" .. fn .. "'") or "main chunk") .. " (boolean expected, got " .. type(v) .. ")", 2)
end



-- Check the type of the given value. Errors if the check fails.
-- 
-- v - The value to examine.
--
-- Returns v
--
function checktable(v)
	if istable(v) then
		return v
	end
	local fn = debug.getinfo(2, 'n').name
	error("bad type in " .. (fn and ("'" .. fn .. "'") or "main chunk") .. " (table expected, got " .. type(v) .. ")", 2)
end



-- Check the type of the given value. Errors if the check fails.
-- 
-- v - The value to examine.
--
-- Returns v
--
function checkfunction(v)
	if isfunction(v) then
		return v
	end
	local fn = debug.getinfo(2, 'n').name
	error("bad type in " .. (fn and ("'" .. fn .. "'") or "main chunk") .. " (function expected, got " .. type(v) .. ")", 2)
end



-- Check the type of the given value. Errors if the check fails.
-- 
-- v - The value to examine.
--
-- Returns v
--
function checkthread(v)
	if isthread(v) then
		return v
	end
	local fn = debug.getinfo(2, 'n').name
	error("bad type in " .. (fn and ("'" .. fn .. "'") or "main chunk") .. " (thread expected, got " .. type(v) .. ")", 2)
end



-- Check the type of the given value. Errors if the check fails.
-- 
-- v - The value to examine.
--
-- Returns v
--
function checkuserdata(v)
	if isuserdata(v) then
		return v
	end
	local fn = debug.getinfo(2, 'n').name
	error("bad type in " .. (fn and ("'" .. fn .. "'") or "main chunk") .. " (userdata expected, got " .. type(v) .. ")", 2)
end



-- Switch-Case implementation.
-- 
-- case - The case selector.
-- funcs - Table of case functions.
--         The function who's key matches the case will be called.
-- [default] - Optional function that's called if case is not handled.
--
-- Returns what the selected function returns, or nil if no function is selected.
--
function switch(case, funcs, default)
	local f = funcs[case]
	if isfunction(f) then
		return f()
	elseif isfunction(default) then
		return default()
	end
	return nil
end



-- Convert any value into an appropriate boolean value.
-- 
-- v - The value to convert. Can be any type of variable.
--     Integer/number conversion will only accept 0 as false, any other integer/number is true.
--     String conversion will only accept "true" as true, any other string is false. Case-insensitive.
--
-- Returns boolean.
--
function tobool(v)
	if v then
		local t = type(v)
		if t == 'number' then
			return v ~= 0
		elseif t == 'string' then
			return string.lower(v) == 'true'
		end
		return true
	end
	return false
end



-- Convert HSV colour space to RGB colour space.
-- 
-- h - [0:360] The hue amount in degrees.
-- s - [0:1] The saturation amount.
-- v - [0:1] The value amount.
--
-- Returns three values: red [0:1], green [0:1], blue [0:1]
--
function hsv2rgb(h, s, v)
	-- https://stackoverflow.com/questions/3018313/algorithm-to-convert-rgb-to-hsv-and-hsv-to-rgb-in-range-0-255-for-both
	local p, q, t, fract
	h = (h % 360) / 60
	s = math.clamp(s, 0, 1)
	v = math.clamp(v, 0, 1)
	fract = h - math.floor(h)
	p = v * (1 - s)
	q = v * (1 - (s*fract))
	t = v * (1 - (s*(1 - fract)))
	if 0 <= h and h < 1 then
		return v, t, p
	elseif 1 <= h and h < 2 then
		return q, v, p
	elseif 2 <= h and h < 3 then
		return p, v, t
	elseif 3 <= h and h < 4 then
		return p, q, v
	elseif 4 <= h and h < 5 then
		return t, p, v
	elseif 5 <= h and h < 6 then
		return v, p, q
	end
	return 0, 0, 0
end



-- Convert HSL colour space to RGB colour space.
-- More expensive to calculate than hsv2rgb (hsv2rgb is about 50% faster on average).
--
-- h - [0:360] The hue amount in degrees.
-- s - [0:1] The saturation amount.
-- l - [0:1] The lightness amount.
--
-- Returns three values: red [0:1], green [0:1], blue [0:1]
--
function hsl2rgb(h, s, l)
	-- https://stackoverflow.com/questions/2353211/hsl-to-rgb-color-conversion
	local r, g, b
	h = (h % 360) / 360
	s = math.clamp(s, 0, 1)
	l = math.clamp(l, 0, 1)
	if s == 0 then
		r = l
		g = l
		b = l
	else
		local hue2rgb = function(p, q, t)
			if t < 0 then t = t + 1 end
			if t > 1 then t = t - 1 end
			if t < 1/6 then return p + (q - p) * 6 * t end
			if t < 1/2 then return q end
			if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
			return p
		end
		local q = (l < 0.5) and (l * (1 + s)) or (l + s - l * s)
		local p = 2 * l - q
		r = hue2rgb(p, q, h + 1/3)
		g = hue2rgb(p, q, h)
		b = hue2rgb(p, q, h - 1/3)
	end
	return r, g, b
end



-- Convert RGB colour space to HSL colour space.
--
-- r - [0:1] The red channel.
-- g - [0:1] The green channel.
-- b - [0:1] The blue channel.
--
-- Returns three values: hue [0:360], saturation [0:1], lightness [0:1]
--
function rgb2hsl(r, g, b)
	-- https://stackoverflow.com/questions/2353211/hsl-to-rgb-color-conversion
	r = math.clamp(r, 0, 1)
	g = math.clamp(g, 0, 1)
	b = math.clamp(b, 0, 1)
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local h, s, l
	l = (max + min) / 2
	if max == min then
		h = 0
		s = 0
	else
		local d = max - min
		s = (l > 0.5) and (d / (2 - max - min)) or (d / (max + min))
		if max == r then
			h = (g - b) / d + (g < b and 6 or 0)
		elseif max == g then
			h = (b - r) / d + 2
		else--if max == b then
			h = (r - g) / d + 4
		end
		h = h / 6
	end
	return h * 360, s, l
end



--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
--------------------------------
--  math Library
--------------------------------
--//////////////////////////////



-- Rounds the given number to nearest specified decimal place greater than or equal to n.
-- 
-- n - The number to round.
-- p - Decimal places.
--
-- Returns rounded value.
--
function math.ceil2(n, p)
	p = 10 ^ p
	return math.ceil(n * p) / p
end




-- Clamps number 'n' between min and max.
-- 
-- min - The minimum allowed value.
-- max - The maximum allowed value.
-- n - The number to clamp.
--
-- Returns clamped value.
--
function math.clamp(min, max, n)
	if n <= min then
		return min
	elseif n >= max then
		return max
	end
	return n
end




-- Get the disance between two 2D points.
-- 
-- x1,y1 - First point.
-- x2,y2 - Second point.
--
-- Returns the distance.
--
function math.dist2(x1, y1, x2, y2)
	return math.sqrt(math.distsqr2(x1, y1, x2, y2))
end



-- Get the disance between two 3D points.
-- 
-- x1,y1,z1 - First point.
-- x2,y2,z2 - Second point.
--
-- Returns the distance.
--
function math.dist3(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.distsqr3(x1, y1, z1, x2, y2, z2))
end



-- Get the squared disance between two 2D points.
-- 
-- x1,y1 - First point.
-- x2,y2 - Second point.
--
-- Returns the squared distance.
--
function math.distsqr2(x1, y1, x2, y2)
	local dx = x2 - x1
	local dy = y2 - y1
	return dx * dx + dy * dy
end



-- Get the squared disance between two 3D points.
-- 
-- x1,y1,z1 - First point.
-- x2,y2,z2 - Second point.
--
-- Returns the squared distance.
--
function math.distsqr3(x1, y1, z1, x2, y2, z2)
	local dx = x2 - x1
	local dy = y2 - y1
	local dz = z2 - z1
	return dx * dx + dy * dy + dz * dz
end



-- Rounds the given number to nearest specified decimal place less than or equal to n.
-- 
-- n - The number to round.
-- p - Decimal places.
--
-- Returns rounded value.
--
function math.floor2(n, p)
	p = 10 ^ p
	return math.floor(n * p) / p
end



-- Get the fractional portion of a number. Results are always positive.
-- 
-- n - The number.
--
-- Returns fractional value.
--
function math.fract(n)
	return math.abs(n) % 1
end



-- Infinity
math.inf  = 1/0



-- Negative infinity
math.infn = -1/0



-- Linear interpolation from a to b.
-- 
-- a - Start value.
-- b - End value.
-- t - Fraction {0:1}.
--
-- Returns the number from a to b based on the fraction provided.
--
function math.lerp(a, b, t)
	return (b - a) * t + a
end



-- Linear interpolation clamped between a and b.
-- 
-- a - Start value.
-- b - End value.
-- t - Fraction {0:1}.
--
-- Returns the number from a to b based on the fraction provided.
--
function math.lerpclamped(a, b, t)
	return math.min(b, math.max(a, (b - a) * t + a))
end



-- Floating-point implementation of math.random.
-- 
-- [m1] - Optional. See below.
-- [m2] - Optional. See below.
--
-- Returns a random number {0 <= R < 1} if no arguments are provided.
-- Returns a random number {0 <= R < max} if only m1 is provided.
-- Returns a random number {min <= R < max} if both m1 and m2 arguments are provided.
--
function math.randomf(m1, m2)
	if m1 then
		if m2 then
			return math.random() * (m2 - m1) + m1
		end
		return math.random() * m1
	end
	return math.random()
end



-- Rounds the given number to nearest integer.
-- 
-- n - The number to round.
--
-- Returns rounded value.
--
function math.round(n)
	return math.floor(n + 0.5)
end



-- Rounds the given number to nearest specified decimal place.
-- 
-- n - The number to round.
-- p - Decimal places.
--
-- Returns rounded value.
--
function math.round2(n, p)
	p = 10 ^ p
	return math.floor(n * p + 0.5) / p
end



-- Get the sign of a number.
-- 
-- n - The number.
--
-- Returns 1 if positive, -1 if negative.
--
function math.sign(n)
	return n >= 0 and 1 or -1
end



--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
--------------------------------
--  string Library
--------------------------------
--//////////////////////////////



-- Append/concatenate string.
-- 
-- str - The string to append to self.
--
-- Returns with concatenated string.
--
function string:append(str)
	return self .. str
end



-- Get a single character in the string.
-- 
-- spot - The location of the character to get.
--        This can be negative to get the character from the right side of the string.
--
-- Returns a single character string.
--
function string:charat(spot)
	return self:sub(spot,spot)
end



-- Check if self ends with the string 'str'.
-- 
-- str - The used to test.
--
-- Returns true if self ends with the string 'str'
--
function string:endswith(str)
	return self:sub(-#str, -1) == str
end



-- Explodes the string into a table of characters.
--
-- Returns table of characters.
--
function string:explode()
	local t = {}
	local s_sub, t_insert = string.sub, table.insert
	for i=1, #self do
		t_insert(t, s_sub(self, i, i))
	end
	return t
end



-- Merges a table's integer-key values into a single string separated by a separator.
-- 
-- t - The table to merge into a string.
-- [separator = " "] - A string to separate the values.
-- 
-- Returns a string of merged values.
-- 
function string.merge(t, separator)
	local str = ""
	local first = true
	separator = separator or " "
	for k,v in ipairs(t) do
		if first then
			str = str .. tostring(v)
			first = false
		else
			str = str .. separator .. tostring(v)
		end
	end
	return str
end



-- Replace all instances of string 'from' in self with string 'to'.
-- If string self is not expected to resemble a Lua string pattern,
-- use string:gsub() instead of this as it may be faster.
-- 
-- from - The substring to be replaced.
-- to - The substitute string.
--
-- Returns new string with changes.
--
function string:replace(from, to)
	local i, init = 0, 1
	local pos = 0
	local s = ""
	local s_find, s_sub = string.find, string.sub
	if from ~= "" then
		while true do
			pos, i = s_find(self, from, init, true)
			if pos == nil then
				break
			end
			s = s .. s_sub(self, init, pos-1) .. to
			init = i+1
		end
	end
	return s .. s_sub(self, init)
end



-- Separates a string using a separator.
-- 
-- [separator = " "] - The pattern used to separate the string.
--
-- Returns a table of split strings.
--
function string:split(separator)
    local t = {}
	local t_insert = table.insert
	separator = separator or " "
	for c in self:gmatch('([^'..separator..']+)') do
		t_insert(t, c)
	end
    return t
end



-- Check if self starts with the string 'str'.
-- 
-- str - The used to test.
--
-- Returns true if self starts with the string 'str'
--
function string:startswith(str)
	return self:sub(1, #str) == str
end



-- Trims the string of all whitespace.
--
-- Returns trimmed string.
--
function string:trim()
	local s = self:gsub('^%s*(.-)%s*$', '%1')
	return s
end



-- Trims the whitespace off of the left side of the string.
--
-- Returns trimmed string.
--
function string:trimleft()
	local s = self:gsub('^%s*(.-)', '%1')
	return s
end



-- Trims the whitespace off of the right side of the string.
--
-- Returns trimmed string.
--
function string:trimright()
	local s = self:gsub('(.-)%s*$', '%1')
	return s
end



--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
--------------------------------
--  table Library
--------------------------------
--//////////////////////////////



-- Insert all values from table 't2' into 't'.
-- 
-- t2 - The table that is appended into 't'.
--
-- Returns nil.
--
function table.append(t, t2)
	local insert = table.insert
	for k,v in pairs(t2) do
		insert(t, v)
	end
end



-- Empties a table without creating a new table.
--
-- Returns nil.
--
function table.clear(t)
	for k,v in pairs(t) do
		t[k] = nil
	end
end



-- Removes non-integer keys from the table and replaces them with an integer key.
--
-- Returns nil.
--
function table.clearkeys(t)
	local insert = table.insert
	for k,v in pairs(t) do
		if not isnumber(k) then
			insert(t, v)
			t[k] = nil
		end
	end
end



-- Creates a duplicate table.
-- 
-- t - The table to duplicate.
--
-- Returns a copy of table 't'
--
function table.copy(t)
	local dup = {}
	for k,v in pairs(t) do
		dup[k] = v
	end
	return dup
end



-- Counts the number of elements in the table, including non-integer keys.
-- If the table is indexed with integers keys, use the # operator instead.
--
-- Returns the number of elements.
--
function table.count(t)
	local n = 0
	for k,v in pairs(t) do
		n = n + 1
	end
	return n
end



-- Checks if the value 'val' is in the table.
-- 
-- val - The value to search for.
--
-- Returns true if found, else false.
--
function table.contains(t, val)
	for k,v in pairs(t) do
		if v == val then
			return true
		end
	end
	return false
end



-- Checks if the table is completely empty.
--
-- Returns true if empty, else false.
--
function table.empty(t)
	return next(t) == nil
end



-- Finds the first instance of 'val' in the table.
-- Use table.findfirsti() when dealing with integer keys only.
-- 
-- val - The value to find in the table.
--
-- Returns the key to the value in the table.
-- Returns nil if value was not found.
--
function table.findfirst(t, val)
	for k,v in pairs(t) do
		if v == val then
			return k
		end
	end
	return nil
end



-- Finds the first instance of 'val' with an integer key in the table.
-- 
-- val - The value to find in the table.
--
-- Returns the integer key to the value in the table.
-- Returns nil if value was not found.
--
function table.findfirsti(t, val)
	for k,v in ipairs(t) do
		if v == val then
			return k
		end
	end
	return nil
end



-- Finds the last instance of 'val' in the table.
-- Use table.findlasti() when dealing with integer keys only.
-- 
-- val - The value to find in the table.
--
-- Returns the key to the value in the table.
-- Returns nil if value was not found.
--
function table.findlast(t, val)
	local key = nil
	for k,v in pairs(t) do
		if v == val then
			key = k
		end
	end
	return key
end



-- Finds the last instance of 'val' with an integer key in the table.
-- 
-- val - The value to find in the table.
--
-- Returns the integer key to the value in the table.
-- Returns nil if value was not found.
--
function table.findlasti(t, val)
	local i = #t
	while i > 0 do
		if t[i] == val then
			return i
		end
		i = i - 1
	end
	return nil
end



-- Finds all instances of 'val' in the table.
-- 
-- val - The value to find in the table.
--
-- Returns a table of keys.
--
function table.findall(t, val)
	local keys = {}
	local insert = table.insert
	for k,v in pairs(t) do
		if v == val then
			insert(keys, k)
		end
	end
	return keys
end



-- Iterate through all elements in the table.
-- 
-- func - The function to call for each element.
--        Passes two arguments: key, val
--
-- Returns nil.
--
table.foreach = table.foreach or function(t, func)
	for k,v in pairs(t) do
		func(k,v)
	end
end



-- Iterate through integer key elements in the table.
-- 
-- func - The function to call for each indexed element.
--        Passes two arguments: index, val
--
-- Returns nil.
--
table.foreachi = table.foreachi or function(t, func)
	for i=1, #t do
		func(i, t[i])
	end
end



-- Merge table 't2' with 't'. Integer key-values will always be inserted.
-- Non-integer keys will be added and overwritten (unless specified not to.)
-- 
-- t2 - The table to be merged with 't'.
-- [overwrite = true] - Optional argument that, when true, will overwrite
--                      any values in 't' with matching keys. Default is true.
--
-- Returns nil.
--
function table.merge(t, t2, overwrite)
	if overwrite == nil then overwrite = true end
	local insert = table.insert
	for k,v in pairs(t2) do
		if isnumber(k) then
			insert(t, v)
		else
			if overwrite or t[k] == nil then
				t[k] = v
			end
		end
	end
end



-- Picks a random value (of an integer key) from the table.
-- Use table.randomkv() instead to include non-integer keys.
--
-- Returns random value.
-- Returns nil if table is empty.
--
function table.random(t)
	if #t == 0 then return nil end
	return t[math.random(#t)]
end



-- Picks a random key-value pair from the table.
--
-- Returns random key-value pair, in that order.
-- Returns nil if table is empty.
--
function table.randomkv(t)
	local r = math.random(table.count(t))
	local n = 1
	for k,v in pairs(t) do
		if n == r then
			return k,v
		end
		n = n + 1
	end
	return nil
end



-- Shuffles the contents of a table.
--
-- Returns nil.
--
function table.shuffle(t)
	-- Algorithm altered and borrowed from http://snippets.luacode.org/snippets/Shuffle_array_145
	local n, order = #t, {};
	for i=1,n do order[i] = { rnd = math.random(), val = t[i] }; end
	table.sort(order, function(a,b) return a.rnd < b.rnd; end);
	for i=1,n do t[i] = order[i].val; end
end



-- Prints the contents of the table into a formatted, human-readable string.
-- 
-- [_rd = nil] - Recursive data. This is used internally and should be ignored.
--
-- Returns a string representing the table.
--
function table.tree(t, _rd)
	local str = ""
	local t_contains, t_insert, t_remove, t_tree = table.contains, table.insert, table.remove, table.tree
	local sub = function(c)
		if c=='\\' then return '\\\\'
		elseif c=='\"' then return '\\\"'
		elseif c=='\t' then return '\\t'
		elseif c=='\n' then return '\\n'
		end
	end
	local first = true
	_rd = _rd or { tabs = 0, tbls = {t} }
	for k,v in pairs(t) do
		if first then
			first = false
		else
			str = str .. '\n'
		end
		for i=1, _rd.tabs do
			str = str .. '\t'
		end
		if istable(v) then
			if t_contains(_rd.tbls, v) then
				str = str .. k .. ':\t' .. tostring(v)
				if v == _rd.tbls[1] then
					str = str .. " [ROOT]"
				end
			else
				_rd.tabs = _rd.tabs + 1
				t_insert(_rd.tbls, v)
				str = str .. k .. ':\t(' .. tostring(v) .. ')\n' .. t_tree( v, _rd )
				t_remove(_rd.tbls, #_rd.tbls)
				_rd.tabs = _rd.tabs - 1
			end
		elseif isstring(v) then
			str = str .. k .. ':\t"' .. v:gsub("[\\\"\t\n]", sub) .. '"'
		else
			str = str .. k .. ':\t' .. tostring(v)
		end
	end
	return str
end