--
-- Author: Your Name
-- Date: 2015-08-01 23:17:04
--


local test = {}
local testx = {}
local testy = {}
local testdata = {}

print(1024*1024)
for i=1,1024*1024 do
	-- test[i] = {size=10000,data=1,x=1,y=1000}


	testx[i] = 1  				--16
	-- testy[i] = 1 				--48
	-- testdata[i] = 1				--71
	-- test[i]=1 					--98
end

collectgarbage("collect")


while true do
	--todo
end
