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
	-- print(v,self.currentBit,v & (1<<self.currentBit))
	if (v & (1<<self.currentBit)) >0 then 
		bit = true
	else
		bit = false
	end

	self.currentBit = self.currentBit + 1

	if self.currentBit >= 8 then 
		self.currentBit = 0 
		self.currentByte = self.currentByte +1 
	end

	return bit
end


function byte:readint(signed)
	local numBit = 0 
	while self:getBit()==false do
		numBit = numBit + 1
	end
	local current = 0 
	for i=numBit-1,0,-1 do
		if self:getBit() then 
			current = current | 1 << a
		end
	end
	current = current | 1 << numBit

	local num 

	if signed then 
		local s = current % 2
		if s==1 then 
			num = current / 2
		else
			num = -current / 2
		end
	else
		num = current -1 
	end
	self:alignBits()
	return num 
end

function byte:alignBits()
	if self.currentBit >0 then 
		self.currentBit =0 
		self.currentByte = self.currentByte + 1
	end
end

function byte:readfloat()
	local type = self:readByte()
	if type == 0 then 
		return 0
	elseif type == 1 then
		return 1
	elseif type == 2 then
		return -1
	elseif type == 3 then
		return 0.5f
	elseif type == 4 then
		return self:readint(true)
	else
		local v = self:readByte() --pos + 1 nedd -1 
		self.currentByte = self.currentByte + string.packszie(f) - 1 
		return v
	end
end

function byte:readByte()
	return self:read("b")
end

function byte:readBool()
	local v,p = self:read("b")
	return v == 1 and true or false
end

function byte:readUTF8()
	local len = self:read(">H")
	local str = self:read("s"..len)
	return str
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


--[[格式串是由转换选项构成的序列。 这些转换选项列在后面：

<: 设为小端编码
>: 设为大端编码
=: 大小端遵循本地设置
![n]: 将最大对齐数设为 n （默认遵循本地对齐设置）
b: 一个有符号字节 (char)
B: 一个无符号字节 (char)
h: 一个有符号 short （本地大小）
H: 一个无符号 short （本地大小）
l: 一个有符号 long （本地大小）
L: 一个无符号 long （本地大小）
j: 一个 lua_Integer
J: 一个 lua_Unsigned
T: 一个 size_t （本地大小）
i[n]: 一个 n 字节长（默认为本地大小）的有符号 int
I[n]: 一个 n 字节长（默认为本地大小）的无符号 int
f: 一个 float （本地大小）
d: 一个 double （本地大小）
n: 一个 lua_Number
cn: n字节固定长度的字符串
z: 零结尾的字符串
s[n]: 长度加内容的字符串，其长度编码为一个 n 字节（默认是个 size_t） 长的无符号整数。
x: 一个字节的填充
Xop: 按选项 op 的方式对齐（忽略它的其它方面）的一个空条目
' ': （空格）忽略
（ "[n]" 表示一个可选的整数。） 除填充、空格、配置项（选项 "xX <=>!"）外， 每个选项都关联一个参数（对于 string.pack） 
或结果（对于 string.unpack）。

对于选项 "!n", "sn", "in", "In", n 可以是 1 到 16 间的整数。 所有的整数选项都将做溢出检查； string.pack 检查提供
的值是否能用指定的字长表示； string.unpack 检查读出的值能否置入 Lua 整数中。

任何格式串都假设有一个 "!1=" 前缀， 即最大对齐为 1 （无对齐）且采用本地大小端设置。

对齐行为按如下规则工作： 对每个选项，格式化时都会填充一些字节直到数据从一个特定偏移处开始， 这个位置是该选项的大小和最大
对齐数中较小的那个数的倍数； 这个较小值必须是 2 个整数次方。 选项 "c" 及 "z" 不做对齐处理； 选项 "s" 对对齐遵循其开头
的整数。]]

