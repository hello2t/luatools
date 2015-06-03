local strTemp = [[
{
  "images" : [
    {
      "size" : "29x29",
      "idiom" : "iphone",
      "filename" : "Icon-Small.png",
      "scale" : "1x"
    },
    {
      "size" : "29x29",
      "idiom" : "iphone",
      "filename" : "Icon-Small@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "29x29",
      "idiom" : "iphone",
      "filename" : "Icon-Small@3x.png",
      "scale" : "3x"
    },
    {
      "size" : "40x40",
      "idiom" : "iphone",
      "filename" : "Icon-Small-40@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "40x40",
      "idiom" : "iphone",
      "filename" : "Icon-Small-40@3x.png",
      "scale" : "3x"
    },
    {
      "size" : "57x57",
      "idiom" : "iphone",
      "filename" : "Icon.png",
      "scale" : "1x"
    },
    {
      "size" : "57x57",
      "idiom" : "iphone",
      "filename" : "Icon@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "60x60",
      "idiom" : "iphone",
      "filename" : "Icon-60@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "60x60",
      "idiom" : "iphone",
      "filename" : "Icon-60@3x.png",
      "scale" : "3x"
    },
    {
      "size" : "29x29",
      "idiom" : "ipad",
      "filename" : "Icon-Small.png",
      "scale" : "1x"
    },
    {
      "size" : "29x29",
      "idiom" : "ipad",
      "filename" : "Icon-Small@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "40x40",
      "idiom" : "ipad",
      "filename" : "Icon-Small-40.png",
      "scale" : "1x"
    },
    {
      "size" : "40x40",
      "idiom" : "ipad",
      "filename" : "Icon-Small-40@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "50x50",
      "idiom" : "ipad",
      "filename" : "Icon-Small-50.png",
      "scale" : "1x"
    },
    {
      "size" : "50x50",
      "idiom" : "ipad",
      "filename" : "Icon-Small-50@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "72x72",
      "idiom" : "ipad",
      "filename" : "Icon-72.png",
      "scale" : "1x"
    },
    {
      "size" : "72x72",
      "idiom" : "ipad",
      "filename" : "Icon-72@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "76x76",
      "idiom" : "ipad",
      "filename" : "Icon-76.png",
      "scale" : "1x"
    },
    {
      "size" : "76x76",
      "idiom" : "ipad",
      "filename" : "Icon-76@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "120x120",
      "idiom" : "car",
      "filename" : "Icon-60@2x.png",
      "scale" : "1x"
    }
  ],
  "info" : {
    "version" : 1,
    "author" : "AppIconTemplate"
  },
    "properties" : {
    "pre-rendered" : true
  }
}

]]


local split= function (value,split)
	local  tab={}
	for  v  in string.gmatch(value, "[^"..split.."]+") do
		table.insert(tab,v)
	end
	return tab
end

local json = require("cjson")


local list = json.decode(strTemp)


local str = "convert Icon-180.png -resize \'%s\' %s"
for k,v in pairs(list.images) do
	local scale = tonumber(string.sub(v.scale, 1,1))
	local size = tonumber(split(v.size,"x")[1])
	-- print(scale,size)
	local ss= size*scale.."x"..size*scale
	-- print(string.format("echo %s",v.idiom))
	print(string.format(str, ss,v.filename))
end


