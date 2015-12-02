package.cpath = package.cpath .. ";clib/?.so"

local lfs = require "lfs"

local imagick = require "imagick"


local imagelist = {}

local function scanDir( path,depth,fileCallback)
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

local function findimage(imagePath)
	local img,err  = imagick.open(imagePath)
	if img then 
		
		table.insert(imagelist,img)
	end
end

local function packimage()
	print("find files ",#imagelist)
	local oimg = imagick.open("xc:rgba(0,0,0,0)")
	oimg:resize(500,500)
	local offx = 0 
	local offy = 0
	for k,v in pairs(imagelist) do
		local size = {w=v:width(),h=v:height()}
		oimg:composite(v,offx,offy)
		offx = offx + 2
		offy = offy + 2
	end

	oimg:write("./data/ok.png")
end





scanDir("./data/imgs",10,findimage)

packimage()



