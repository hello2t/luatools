--
-- Author: zj
-- Date: 2015-05-27 14:20:31
--
local string = string
local print = print
local table = table

local lfs = require("lfs")
local util ={}
local lub = require("lub")



-- local lpeg = require "lpeg"
-- local P = lpeg.P
-- local C = lpeg.C
-- local Ct =  lpeg.Ct
-- local M = lpeg.match

-- function string.split (s, sep)
--   sep = P(sep)
--   local elem = C((1 - sep)^0)
--   local p = lpeg.Ct(elem * (sep * elem)^0)   -- make a table capture
--   return M(p, s)
-- end

--字符串拆分
function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

--清楚空白
function string.trim(input)
    input = string.gsub(input, "^[ \t\n\r]+", "")
    return string.gsub(input, "[ \t\n\r]+$", "")
end

function util.run(cmd)
    
end

function util.language( path)
    local keyvalue ={}
    for line in io.lines(path) do 
        local key,value = string.match(line,"(.-)=(.*)")
        if key ~= nil then 
            keyvalue[key] = value
        end
    end
    return keyvalue
end



--执行命令返回结果
function util.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

--扫描目录  找到文件就回调
function util.scanDir( path,depth,fileCallback)
    --获取目录下所有的文件
	for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local f = path..'/'..file
            --获取当前文件属性
            local attr = lfs.attributes (f)
            if (type(attr) == "table") then 
                --如果文件属性是目录 递归遍历这个目录
                if attr.mode == "directory" and depth >0 then
                    util.scanDir(f,depth-1,fileCallback)
                else
                	fileCallback(f)
                end
            else
                util.trace(attr,"error")
            end
        end
    end
end

--检测是否存在文件
function util.fileExists(path)
    local file = io.open(path, "r")
    if file then
    	io.close(file)
        return true
    end
    return false
end

--获取文件类型路径后缀
function util.pathinfo(path)
    local pos = string.len(path)
    local extpos = pos + 1
    while pos > 0 do
        local b = string.byte(path, pos)
        if b == 46 then -- 46 = char "."
            extpos = pos
        elseif b == 47 then -- 47 = char "/"
            break
        end
        pos = pos - 1
    end

    local dirname = string.sub(path, 1, pos)
    local filename = string.sub(path, pos + 1)
    extpos = extpos - pos
    local basename = string.sub(filename, 1, extpos - 1)
    local extname = string.sub(filename, extpos)
    return {
        dirname = dirname,
        filename = filename,
        basename = basename,
        extname = extname
    }
end

--文件内容替换  
function util.filegsub( file, oldStr,newStr )
	local filecontent = util.readfile(file)
	local count 
	filecontent,count = string.gsub(filecontent,oldStr,newStr)
	util.savefile(file,filecontent)
	filecontent = nil
	return count
end

--删除文件
function util.rmfile( path )
	os.execute("rm "..path)
end

function util.copy(src,target)
    os.execute("cp "..src.." "..target)
end

function util.rmdir(path)
    os.execute("rm -rf "..src.." "..target)
end


--读取文件
function util.readfile( path ,mode)
	local file = io.open(path, mode or "r")
    if file then
        local content = file:read("*a")
        io.close(file)
        return content
    end
    return nil
end

--保存文件
function util.savefile( path,content,mode )
    lub.makePath(path)
	mode = mode or "w+b"
    local file = io.open(path, mode)
    if file then
        if file:write(content) == nil then return false end
        io.close(file)
        return true
    else
        return false
    end
end

--输出表格调试
function util.trace(value, desciption, nesting, filterString)
    if type(nesting) ~= "number" then nesting = 5 end

    local lookupTable = {}
    local result = {}

    local filterString = filterString or false

    local function _v(v)
        if type(v) == "string" then
            v = "\"" .. v .. "\""
        end
        return tostring(v)
    end

    local traceback = string.split(debug.traceback("", 2), "\n")
    print("dump from: " .. string.trim(traceback[3]))
    local function _dump(value, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(_v(desciption)))
        end
        if type(value) ~= "table" then
            if filterString == false then
                result[#result +1 ] = string.format("%s%s%s = %s", indent, _v(desciption), spc, _v(value))
            end
        elseif lookupTable[value] then
            result[#result +1 ] = string.format("%s%s%s = *REF*", indent, desciption, spc)
        else
            lookupTable[value] = true
            if nest > nesting then
                result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent, desciption)
            else
                result[#result +1 ] = string.format("%s%s = {", indent, _v(desciption))
                local indent2 = indent.."    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = _v(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then keylen = vkl end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    _dump(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result +1] = string.format("%s}", indent)
            end        end
    end
    _dump(value, desciption, "- ", 1)

    for i, line in ipairs(result) do
        print(line)
    end
end


function util.execute(cmd)
	os.execute(cmd)
end


return util