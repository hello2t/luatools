--
-- Author: Your Name
-- Date: 2015-07-23 21:31:42
--brew install libmagic
--luarocks install --from=http://mah0x211.github.io/rocks/ magic


local util = require("util")
local unpack = require("struct").unpack
local string_char = string.char
local string_byte = string.byte

local magic = require('magic');
local mgc = magic.open( magic.RAW, magic.NO_CHECK_COMPRESS );
local rc = mgc:load();


function findFile (file)
	local fileinfo = util.pathinfo(file)
	local t =mgc:file( file )

	if t:find("Flash") then 
		util.copy(file,"~/Desktop/swf/"..fileinfo.filename..".swf")
	end
end



-- util.scanDir("/Users/zj/Library/Caches/com.apple.Safari/WebKitCache/Version 4/Records/facebook.com",10,findFile)


util.scanDir("/Users/zj/Library/Caches/com.apple.Safari/fsCachedData",10,findFile)
