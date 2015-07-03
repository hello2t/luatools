--
-- Author: zj
-- Date: 2015-07-02 11:00:32
--
local util = require("util")
local map = require("map")

local data = util.readfile("data/byte.tmx")
local mapread = map.newBuf(data)
data = nil
local mapdata ={}

local function readProperty(tb)
	tb[map.readString(mapread)] = map.readString(mapread)
end

local function readProperties(tb)
	local len = map.readInt(mapread)
	local p ={}
	for i=1,len do
		readProperty(p)
	end
	table.insert(tb, p)
end

local function readTerrain(tb)
	local t = {}
	t.name = map.readInt(mapread)
	-- t.tile = map.readInt(mapread) --error value -1
	local len = map.readInt(mapread)
	-- print("readProperties:"..len)
	t.proproperties={}
	for i=1,len do
		readProperties(t.proproperties)
	end
	table.insert(tb, t)
end

local function readTerraintypes(tb)
	local len = map.readInt(mapread)
	-- print("readTerraintypes:"..len)
	for i=1,len do
		readTerrain(tb)
	end
end

local function readTile(tb)
	local t = {}
	t.id = map.readInt(mapread)
	t.terrain ={}
	for i=1,4 do
		table.insert(t.terrain, map.readInt(mapread))
	end
	table.insert(tb,t)
end

local function readTiles(tb)
	local len = map.readInt(mapread)
	-- print("readTiles:"..len)
	for i=1,len do
		readTile(tb)
	end
end

local function readImage(tb)
	-- print("readImage")
	tb.source = map.readString(mapread)
	tb.width = map.readInt(mapread)
	tb.height = map.readInt(mapread)
end

local function readTileset(tb)
	local tileset = {}
	tileset.firstgid = map.readInt(mapread)
	tileset.name = map.readString(mapread)
	tileset.tilewidth = map.readInt(mapread)
	tileset.tileheight = map.readInt(mapread)
	tileset.spacing = map.readInt(mapread)
	tileset.margin = map.readInt(mapread)
	tileset.image = {}
	tileset.terraintypes ={}
	tileset.tiles ={}

	readImage(tileset.image)
	readTerraintypes(tileset.terraintypes)
	readTiles(tileset.tiles)

	table.insert(tb, tileset)
end

local function readTilesets(tb)
	local len = map.readInt(mapread)
	-- print("readTilesets:"..len)
	for i=1,len do
		readTileset(tb)	
	end

end

local function readData()
	local data = map.readIntArray(mapread)
	return data
end

local function readLayer(tb)
	local layer ={}
	layer.name = map.readString(mapread)
	layer.width = map.readInt(mapread)
	layer.height = map.readInt(mapread)
	layer.data = readData()
	table.insert(tb,layer)
end

local function readLayers(tb)
	local len = map.readInt(mapread)
	for i=1,len do
		readLayer(tb)
	end
end

local function readMap()
	
	mapdata.version = map.readInt(mapread)
	mapdata.orientation = map.readString(mapread)
	mapdata.renderorder = map.readString(mapread)
	mapdata.width = map.readInt(mapread)
	mapdata.height = map.readInt(mapread)
	mapdata.tilewidth = map.readInt(mapread)
	mapdata.tileheight = map.readInt(mapread)
	mapdata.nextobjectid = map.readInt(mapread)

	mapdata.tilesets = {}
	mapdata.layers = {}

	readTilesets(mapdata.tilesets)
	readLayers(mapdata.layers)
end

-- local s= require("socket")
-- local time = s.gettime()
readMap()
-- print(s.gettime()-time)

-- util.trace(mapdata,"",10)