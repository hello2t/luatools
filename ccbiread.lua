--
-- Author: Your Name
-- Date: 2015-06-03 14:13:40
--
local util = require "util"
local Byte = require "Byte"



local str = util.readfile("/Users/zj/Desktop/cok/ccbi/AchieveFinishView.ccbi")

local read = Byte.create(str)


local function readHead()
	print("head",read:readBytes(4))
	print(read:readint())
end





readHead()