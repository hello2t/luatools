--
-- Author: Your Name
-- Date: 2015-05-27 14:19:33
--
local util = require("util")
local xml = require("xml")
local lub = require("lub")

local cmd = "TexturePacker %s.pvr.ccz --sheet %s.png --algorithm Basic --allow-free-size --no-trim --max-size 4048"


local pvrExt = ".pvr.ccz"
local plistExt = ".plist"
local pngExt = ".png"
local xmlExt =".local.xml"

local lang = util.language("text_zh_CN.ini")

function pvr2pngFile( filePath )
	local fileinfo = util.pathinfo(filePath)
	if fileinfo.extname == pvrExt then 
		local newFilename = fileinfo.dirname..fileinfo.basename
		os.execute(string.format(cmd, newFilename,newFilename))
		util.rmfile(filePath)
	end
end


function repFileString( filePath )
	local fileinfo = util.pathinfo(filePath)
	if fileinfo.extname == plistExt then 
		util.filegsub(filePath,pvrExt,pngExt)
	end
end


local cut = "convert %s -crop %sx%s+%s+%s %s"
local rotate="convert %s -rotate -90 %s"
function splitPlist2Images( filePath )
	local fileinfo = util.pathinfo(filePath)
	if fileinfo.extname == plistExt then 
		local xmlData = xml.loadpath(filePath)
		-- util.trace(xmlData)

		local images = xmlData[1][2]
		if images ==nil then 
			return 
		end
		local image = xmlData[1][4][4][1]
		local imageName 
		local imageRect 
		local isRot
		local lastFileName = fileinfo.dirname.. fileinfo.basename.."/"
		print(lastFileName)
		lub.makePath(lastFileName)
		
		for i,v in ipairs(images) do
			if i%2==1 then 
				imageName = v[1]
			else
				imageRect = v[2][1]
				isRot = v[6]["xml"]
				imageRect = imageRect:gsub("{",""):gsub("}","")
				
				local rect = string.split(imageRect, ",")
				local rot = ""
				if isRot =="true" then 
					local temp = rect[3]
					rect[3]=rect[4]
					rect[4]=temp
					-- rot = rotate
				end
				local filename = string.gsub(lastFileName ..imageName," ","_")
				local cmd = string.format(cut,fileinfo.dirname..image,tonumber(rect[3])+4,tonumber(rect[4])+4,tonumber(rect[1])-1,tonumber(rect[2])-1,filename)
				-- print(cmd)
				os.execute(cmd)
				if isRot =="true" then 
					os.execute(string.format(rotate, filename,filename))
				end
			end
		end
	end
	
end

function splitXml( filePath )
	local fileinfo = util.pathinfo(filePath)
	if fileinfo.extname == xmlExt then 
		local xmlData = xml.loadpath(filePath)
		for i,v in ipairs(xmlData) do
			local xmlstr = xml.dump(v)
			for k,v in pairs(lang) do
				xmlstr = xmlstr:gsub(k,v)
			end

			xmlstr = xmlstr:gsub("|","|\n\r")
			util.savefile(fileinfo.dirname.."xml2/"..v["id"]..".xml",xmlstr,"w")
		end
	end
end





-- util.scanDir("/Users/zj/Desktop/cok",10,filterFile)
-- util.scanDir("/Users/zj/Desktop/cok/World",10,splitPlist2Images)
-- splitXml("database.local.xml")