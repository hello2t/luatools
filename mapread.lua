--
-- Author: Your Name
-- Date: 2015-06-19 17:47:35
--
local util = require "util"

local socket = require "socket"



local file = util.readfile("map.txt")


local t = socket.gettime()
local tb = string.split(file,",")
print(#tb)

print(socket.gettime()-t)

