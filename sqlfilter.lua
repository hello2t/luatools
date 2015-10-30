--
-- Author: Your Name
-- Date: 2015-10-10 10:20:14
--
local lines ={}

local f = assert(io.open("sql.sql","r"))

local content = f:read("*a")

io.close(f)


lines = string.gmatch(content,"(.-)\n")

local index = 1 
for line in lines do
	if line:sub(1,3) =="sql" then 
		print(index .."		 "..line)
		index = index +1
	end
end