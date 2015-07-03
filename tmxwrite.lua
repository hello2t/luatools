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

local function writeProperty(tb)
	map.writeString(mapwrite,tb.name)
	map.writeString(mapwrite,tb.value)
end

local function writeProperties(tb)
	--properties->property
	map.writeInt(mapwrite,#tb)
	for k,v in ipairs(tb) do
		writeProperty(v)
	end
end

local function writeTerrain(tb)
	map.writeInt(mapwrite,tb.name)
	-- map.writeInt(mapwrite,tb.tile) --error value -1
	--terrain->properties
	print("writeProperties:",#tb)
	map.writeInt(mapwrite,#tb)
	for k,v in ipairs(tb) do
		writeProperties(v)
	end
end

local function writeTerraintypes(tb)
	--terraintypes ->terrain
	print("write terraintypes:"..#tb)
	map.writeInt(mapwrite,#tb)
	for k,v in ipairs(tb) do
		writeTerrain(v)
	end
end

local function writeTile(tb)
	map.writeInt(mapwrite,tb.id)
	local str = string.split(tb.terrain,",")
	for i,v in ipairs(str) do
		map.writeInt(mapwrite,v)
	end
end

local function writeTiles(tb)
	print("writeTiles:"..#tb)
	map.writeInt(mapwrite,#tb)
	for i,v in ipairs(tb) do
		writeTile(v)
	end
end

local function writeImage(tb)
	print("writeImage")
	map.writeString(mapwrite,tb.source)
	map.writeInt(mapwrite,tb.width)
	map.writeInt(mapwrite,tb.height)
end

local function writeTileset(tb)
	print("writeTileset")
	map.writeInt(mapwrite,tb.firstgid)
	map.writeString(mapwrite,tb.name)
	map.writeInt(mapwrite,tb.tilewidth)
	map.writeInt(mapwrite,tb.tileheight)
	map.writeInt(mapwrite,tb.spacing)
	map.writeInt(mapwrite,tb.margin)
	local images
	local terraintypes
	local tiles = {}
	for i,v in ipairs(tb) do
		if v.xml =="image" then 
			images=v
		elseif v.xml=="terraintypes"then 
			terraintypes = v
		elseif v.xml =="tile" then 
			table.insert(tiles,v)
		else
			print("no handler "..v.xml)
		end
	end
	writeImage(images)
	writeTerraintypes(terraintypes)
	writeTiles(tiles)
end

local function writeTilesets(tb)
	print("writeTilesets:"..#tb)
	map.writeInt(mapwrite,#tb)
	for i,v in ipairs(tb) do
		writeTileset(v)
	end
end

local function writeData(tb)
	local str = string.split(tb[1],",")
	map.writeInt(mapwrite,#str)
	print("writeData:"..#str)
	for i,v in ipairs(str) do
		map.writeInt(mapwrite,tonumber(v))
	end
end

local function writeLayer(tb)
	map.writeString(mapwrite,tb.name)
	map.writeInt(mapwrite,tb.width)
	map.writeInt(mapwrite,tb.height)
	--data 
	for k,v in ipairs(tb) do
		writeData(v)
	end
end

local function writeLayers(tb)
	map.writeInt(mapwrite,#tb)
	for i,v in ipairs(tb) do
		writeLayer(v)
	end
end

local function writeMap( tb )
	map.writeInt(mapwrite,tb.version)
	map.writeString(mapwrite,tb.orientation)
	map.writeString(mapwrite,tb.renderorder)
	map.writeInt(mapwrite,tb.width)
	map.writeInt(mapwrite,tb.height)
	map.writeInt(mapwrite,tb.tilewidth)
	map.writeInt(mapwrite,tb.tileheight)
	map.writeInt(mapwrite,tb.nextobjectid)
	--tileset and layer
	local tilesets = {}
	local layers = {}
	for i,v in ipairs(tb) do
		if v.xml =="tileset" then 
			table.insert(tilesets,v)
		elseif v.xml=="layer" then 
			table.insert(layers,v)
		else
			print("no handler :"..v.xml)
		end
	end
	writeTilesets(tilesets)
	writeLayers(layers)
end

writeMap(xmlData)

local d = map.getString(mapwrite)
util.savefile("data/byte.tmx",d)
print("write ok size:"..#d)

