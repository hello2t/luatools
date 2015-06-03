--
-- Author: Your Name
-- Date: 2015-06-03 15:14:15
--
local byte = {}
byte.__index = byte

local up = string.unpack 
local size = string.packsize


function byte.create(data)
	local c ={}
	c.data = data
	c.currentByte = 1
	c.currentBit = 0
	return setmetatable(c, byte)
end

function byte:read(str,addcurrentByte)
	local v,p = up(str,self.data,self.currentByte)
	if addcurrentByte == nil then 
		self.currentByte = p
	end
	return v,p
end

function byte:getBit()
	local v = self:read("b",true)
	local bit 
	print(v,self.currentBit,v & (1<<self.currentBit))
	if (v & (1<<self.currentBit)) >0 then 
		bit = true
		-- print("true",self.currentBit,self.currentByte)
	else
		bit = false
		-- print("false",self.currentBit,self.currentByte)
	end

	self.currentBit = self.currentBit + 1

	if self.currentBit >= 8 then 
		self.currentBit = 0 
		self.currentByte = self.currentByte +1 
	end

	return bit
end


function byte:readint()
	local numBit = 0 
	while self:getBit()==false do
		numBit = numBit + 1
	end
	print(numBit)
	-- body
end


function byte:readBytes(len)
	local v,p = up("c"..len,self.data,self.currentByte)
	self.currentByte = p
	return v
end


function byte:readInt()
	local v,p = up("i",self.data,self.currentByte)
	self.currentByte = p
	print(size("i"),v)
	return v
end



return byte