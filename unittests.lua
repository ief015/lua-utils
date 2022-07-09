require 'utils'

function test_all(cases)
	local test_count = 0
	local test_passed = 0
	local test_elapsed = os.clock()
	local failed = {}
	for k,v in pairs(cases) do
		io.write("("..test_count..") \""..k.. "\" running...")
		local start = os.clock()
		local ret, msg = v()
		local finish = os.clock()
		if ret then
			io.write("succeeded in "..(finish-start).." seconds")
			test_passed = test_passed + 1
		else
			io.write("FAILED in "..(finish-start).." seconds")
			failed[k] = msg and "" or msg
		end
		if msg ~= nil then
			io.write(" with message: "..msg)
		end
		io.write("\n")
		test_count = test_count + 1
	end
	local test_elapsed = os.clock() - test_elapsed
	if test_passed == test_count then
		print("All "..test_count.." tests passed! ("..test_elapsed.." seconds)")
	else
		print (test_passed .. " of " .. test_count .. " tests passed ("..test_elapsed.." seconds)")
		for k,v in pairs(failed) do
			if string.len(v) == 0 then
				print(k.." failed")
			else
				print(k.." failed ("..v..")")
			end
		end
	end
end


local tests = {

	["benchmark string.startswith"] = function()
		local start, finish
		start = os.clock()
		for i=1, 1000000 do
			string.startswith("hello, world", "hell")
		end
		finish = os.clock();
		local t_startswith = (finish - start)
		start = os.clock();
		for i=1, 1000000 do
			string.match("hello, world", "^hell")
		end
		finish = os.clock();
		local t_match = (finish - start)
		return true, t_startswith..", "..t_match
	end,
	
	["benchmark HSV/HSL"] = function()
		math.randomseed(0)
		start = os.clock()
		for i=1, 1000000 do
			hsv2rgb(math.random()*360, math.random(), math.random())
		end
		finish = os.clock()
		io.write("\nhsv2rgb =\t" .. (finish-start))
		
		math.randomseed(0)
		start = os.clock()
		for i=1, 1000000 do
			hsl2rgb(math.random()*360, math.random(), math.random())
		end
		finish = os.clock()
		io.write("\nhsl2rgb =\t" .. (finish-start))
		
		math.randomseed(0)
		start = os.clock()
		for i=1, 1000000 do
			rgb2hsl(math.random(), math.random(), math.random())
		end
		finish = os.clock()
		io.write("\nrgb2hsl =\t" .. (finish-start) .. "\n")
		return true
	end,

}


test_all(tests)
io.read()