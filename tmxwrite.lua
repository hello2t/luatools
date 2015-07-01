--
-- Author: Your Name
-- Date: 2015-06-24 16:48:06
--
local util = require("util")
local xml = require("xml")
local lub = require("lub")
local map = require("map")

local xmlData = xml.loadpath("data/WorldMap.tmx")
local mapwrite = map.new(1020*1020*4)

local writes

local function getType( tb )
	return tb.xml
end

local function traverse(tb)
	if tb ==nil then 
		return 
	end
	local t = getType(tb)
	local f = writes[t]
	if f then 
		print("write",t)
		f(tb)
	else
		print(t,"----------------")
		for k,v in pairs(tb) do
			print(k,v)
		end
		print("*******************")
	end
end

local function writeMap( tb )
	print("writeMap")
	map.writeInt(mapwrite,tb.version)
	map.writeString(mapwrite,tb.orientation)
	map.writeString(mapwrite,tb.renderorder)
	map.writeInt(mapwrite,tb.width)
	map.writeInt(mapwrite,tb.height)
	map.writeInt(mapwrite,tb.tilewidth)
	map.writeInt(mapwrite,tb.tileheight)
	map.writeInt(mapwrite,tb.nextobjectid)
	for i,v in ipairs(tb) do
		traverse(v)
	end
end

local function readMap()
	local tb ={}
	tb.version = map.readInt(mapwrite)
	tb.orientation = map.writeString(mapwrite)
	tb.renderorder = map.writeString(mapwrite)
	tb.width = map.readInt(mapwrite)
	tb.height = map.readInt(mapwrite)
	tb.tilewidth = map.readInt(mapwrite)
	tb.tileheight = map.readInt(mapwrite)
	tb.nextobjectid = map.readInt(mapwrite)
	return tb
end


local function writeTileset(tb)
	map.writeInt(mapwrite,tb.firstgid)
	map.writeString(mapwrite,tb.name)
	map.writeInt(mapwrite,tb.tilewidth)
	map.writeInt(mapwrite,tb.tileheight)
	map.writeInt(mapwrite,tb.spacing)
	map.writeInt(mapwrite,tb.margin)
	for i,v in ipairs(tb) do
		traverse(v)
	end
end

local function readTileset()

end

local function writeImage(tb)
	map.writeString(mapwrite,tb.source)
	map.writeInt(mapwrite,tb.width)
	map.writeInt(mapwrite,tb.height)
end

local function readImage()
	

end


local function writeTerraintypes(tb)
	for k,v in ipairs(tb) do
		traverse(v)
	end
end

local function readTerraintypes()
	

end

local function writeTerrain(tb)
	map.writeInt(mapwrite,tb.name)
	map.writeInt(mapwrite,tb.tile)
	for k,v in ipairs(tb) do
		traverse(v)
	end

end

local function readTerrain()
	

end


local function writeProperties(tb)
	for k,v in ipairs(tb) do
		traverse(v)
	end
end

local function readProperties()

end

local function writeProperty(tb)
	map.writeString(mapwrite,tb.name)
	map.writeString(mapwrite,tb.value)
end

local function readProperty()

end


local function writeTile(tb)
	map.writeInt(mapwrite,tb.id)
	local str = string.split(tb.terrain,",")
	for i,v in ipairs(str) do
		map.writeInt(mapwrite,v)
	end
end

local function readTile()
	

end

local function writeLayer(tb)
	map.writeString(mapwrite,tb.name)
	map.writeInt(mapwrite,tb.width)
	map.writeInt(mapwrite,tb.height)
	--data 
	for k,v in ipairs(tb) do
		traverse(v)
	end
end

local function readLayer()

end


local function writeData(tb)
	map.writeString(mapwrite,tb.encoding)
	local str = string.split(tb[1],",")
	map.writeInt(mapwrite,#tb)
	for i,v in ipairs(str) do
		map.writeInt(mapwrite,tonumber(v))
	end

end


writes ={
	map = writeMap,
	tileset = writeTileset,
	image = writeImage,
	terraintypes = writeTerraintypes,
	terrain = writeTerrain,
	tile = writeTile,
	properties = writeProperties,
	property = writeProperty,
	layer = writeLayer,
	data =  writeData
}



traverse(xmlData)
