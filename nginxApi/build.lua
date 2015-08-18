
local function get_funcs_and_consts( data )
	local funcs, consts = {}, {}
	for h3 in string.gmatch(data, "<b>syntax:.-</i>") do
		local code = string.match(h3, "<i>.-</i>")
		if code then
			
			local code = string.sub(code, 4, -5)
			-- print(code)
			if string.find(code, "%(") then
				code = string.gsub(code, "&middot;", ".")
				table.insert(funcs, code)
				-- print("func",code)
			else
				table.insert(consts, code)
				-- print("consts",code)
			end
		end
	end
	return funcs, consts
end

local function get_content( func )
	local content = func
	local code = string.match(func, "%(.-%)")
	if code then
		code = string.sub(code, 2, -2)
		if string.len(code) > 0 then
			local args = {}
			local n = 1
			for arg in string.gmatch(code, "([%w%.]+)") do
				table.insert(args, string.format("${%d:%s}", n, arg))
				n = n + 1
			end
			content = string.sub(func, 1, string.find(func, "%(") - 2) .. "(".. table.concat(args, ", ") .. ")"
		end
	end
	return "<![CDATA[" .. content .. "]]>"
end

local function get_func_name( func )
	local start = string.find(func,"ngx.")
	if start ==nil then 
		start = string.find(func,"= ")
		if start then 
			start = start + 2
		end
	end

	if start ==nil then 
		start = 1
	end

	local endflag = string.find(func, "%(")-1

	if endflag ==nil then 
		endflag = string.find(func, "&lt")
	end

	-- print(func,start)
	return string.sub(func, start, endflag)
end

local function get_description( func )
	return string.match(func, "%(.-%)")
end

local function get_snippet( content, trigger, description )
	local space = string.rep(" ", 4)
	local snippet = string.format("<snippet>\n%s\n%s\n%s\n%s\n</snippet>\n",
		space .. "<content>" .. content .. "</content>",
		space .. "<tabTrigger>" .. trigger .. "</tabTrigger>",
		space .. "<scope>source.lua</scope>",
		space .. "<description>" .. description .. "</description>")
	return snippet
end

local function output_funcs( funcs, dir )
	if string.sub(dir, -1) ~= "/" then
		dir = dir .. "/"
	end
	for _, func in ipairs(funcs) do
		local func_name = get_func_name(func)
		-- print(func_name)
		local snippet = get_snippet(get_content(func), func_name, get_description(func))

		local f_name = func_name .. ".sublime-snippet"
		local f = io.open(dir .. f_name, "w")
		f:write(snippet)
		f:close()
	end
end

local function getConstName(str)
	local start = string.find(str,"ngx.")
	if start ==nil then 
		start = string.find(str,"= ")
		if start then 
			start = start + 2
		end
	end
	if start ==nil then 
		start = 1
	end
	local endflag = string.find(str, " ")

	if endflag ==nil then 
		endflag = string.find(str, "&lt")
	else
		endflag =  endflag -1
	end
	if endflag and endflag<start then 
		endflag = nil
	end
	return string.sub(str, start, endflag)
end

local function output_consts( consts, dir )
	if string.sub(dir, -1) ~= "/" then
		dir = dir .. "/"
	end
	for _, const in ipairs(consts) do
		const = getConstName(const)
		local snippet = get_snippet("<![CDATA[" .. const .. "]]>", const, const)

		local f_name = const .. ".sublime-snippet"
		local f = io.open(dir .. f_name, "w")
		f:write(snippet)
		f:close()
	end
end


local f = io.open("HttpLuaModule - Nginx Community.html", "r")
local data = f:read("*all")
f:close()

local funcs, consts = get_funcs_and_consts(data)

os.execute("mkdir nginx")

output_funcs(funcs, "nginx")
output_consts(consts, "nginx")

print("all done")