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
	local filedata = util.readfile(file,"rb")
	local byte1 = string_byte(filedata,1)
	local byte2 = string_byte(filedata,2)
	local byte3 = string_byte(filedata,3)

	-- local fileinfo = util.pathinfo(file)
	-- print(byte1,byte2,byte3,fileinfo.basename)
	print( mgc:file( file ) );
	-- print(string_char(byte1).." "..string_char(byte2).." "..string_char(byte3))
end



util.scanDir("/Users/zj/Library/Caches/com.apple.Safari/WebKitCache/Version 4/Records/facebook.com",10,findFile)