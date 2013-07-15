local toc, data = ...
local id = toc.identifier

function wyk.func.PlayerCalling()
    if wyk.vars.loadedCalling == nil then
		--print("trying to load calling...")
        local usr = Inspect.Unit.Detail("player")
		wyk.vars.loadedCalling = usr.calling
		--print("found calling "..tostring(usr.calling))
    end
    return wyk.vars.loadedCalling
end

function wyk.func.LTrim(s) return string.match(s, "%S.*") end

function wyk.func.RTrim(s) return string.match(s, ".*%S") end

function wyk.func.Trim(s) return wyk.func.LTrim(wyk.func.RTrim(s)) end

function wyk.func.LineClose(n) if n > 0 then return "\n"; else return ""; end end

function wyk.func.NilSafe(t) if t == nil then return ""; else return t; end end

function wyk.func.isNumeric(t)
	if t == nil then return false end
	if tonumber(t) then return true end
	return false
end

function wyk.func.isBoolean(t)
	if t == nil then return false end
	if t == false or t == true then return true end
	return false
end

function wyk.func.Count(list)
    if list == nil then return 0 end
	local ii = 0
    for _ in pairs(list) do ii = ii + 1 end
    return ii
end

function wyk.func.Contains(list,targetval)
    if list == nil then return false; end
    for _, v in pairs(list) do
        if v == targetval then
            return true
        end
    end
    return false
end

function wyk.func.TPrint(t, indent, done) print(wyk.func.TDump(t, indent, done)) end

function wyk.func.TDump(t, indent, done)
    local function show (val)
        if type (val) == "string" then
            return '"' .. val .. '"'
        else
            return tostring (val)
        end
    end
    if type (t) ~= "table" then return "Note a table. Type is: " .. type (t) end
    done = done or {}
    indent = indent or 0
    str = ""
    for key, value in pairs (t) do
        str = str .. (string.rep (" ", indent))
        if type (value) == "table" and not done [value] then
            done [value] = true
            str = str .. show(key) .. ":\r"
            str = str .. wyk.func.TDump (value, indent + 2, done)
        else
            str = str .. show (key) .. " = "
            str = str .. show (value) .. "\r"
        end
    end
    return str
end

function wyk.func.Round( x )
  if x >= 0 then return math.floor (x + 0.5) end
  return math.ceil (x - 0.5)
end

function wyk.func.DeriveID(obj) if obj then return obj.id; else return nil; end end

function wyk.func.Gadgets()
    if wyk.vars.Gadgets == nil then
        local addonList = Inspect.Addon.List()
        if addonList.Gadgets ~= nil then 
            wyk.vars.Gadgets = true
        end
    end
    return wyk.vars.Gadgets
end

function wyk.func.kAlert()
    if wyk.vars.kAlert == nil then
        local addonList = Inspect.Addon.List()
        if addonList.kAlert ~= nil then 
            wyk.vars.kAlert = true
        end
    end
    return wyk.vars.kAlert
end

function wyk.func.ClassIcons()
    if wyk.vars.usrCallingIcons == nil and wyk.func.PlayerCalling() ~= nil then
		--print(wyk.func.PlayerCalling())
        local ii = 0
        local retVal = {}
        for i, c in pairs(wyk.vars.Images.classes[wyk.func.PlayerCalling()]) do
            if c.src ~= nil then
                ii = ii + 1
                retVal[ii] = { src = c.src, file = c.file }
            end
        end
        wyk.vars.usrCallingIcons = retVal
        wyk.vars.usrCallingIconCount = ii
        iconRepos = nil
        curImageCount = 0
    end
    return wyk.vars.usrCallingIcons
end

function wyk.func.ClassIconCount()
    if wyk.vars.usrCallingIcons == nil then local dmp = wyk.func.ClassIcons() end
    return wyk.vars.usrCallingIconCount
end

function wyk.func.FindGearIcons()
	local lst = wyk_saved_GearIcons or {}
	local ii = 0
	local slot = Utility.Item.Slot.All()
	local items = Inspect.Item.Detail(slot)
	local nameList = {}
	local gearIconCount = wyk.func.Count(lst)
	
	if gearIconCount > 0 then
		for ii = 1, gearIconCount, 1 do nameList[lst[ii].file] = true end
	end
	
	ii = gearIconCount
	
	for k,v in pairs(items) do
		if nameList[v.icon] ~= true then
			ii = ii + 1
			lst[ii] = { src = "Rift", file = v.icon }
			nameList[v.icon] = true
		end
	end
	
	wyk_saved_GearIcons = lst
end

function wyk.func.LoadIcons()
	local a = wyk_saved_GearIcons
	local b = wyk.vars.usrCallingIcons
	local xx = wyk.func.Count(a)
	local yy = wyk.func.Count(b)
	local zz = 0
	local lst = {}
	for ii = 1, yy, 1 do
		zz = zz + 1
		lst[zz] = b[ii]
	end
	for ii = 1, xx, 1 do
		zz = zz + 1
		lst[zz] = a[ii]
	end
	wyk.vars.Icons = lst
	wyk.vars.IconCount = zz
end

function wyk.func.SelectIconFromList(lst, file)
    for ii = 1, wyk.func.Count(lst), 1 do
        if lst[ii].file == file then return ii; end
    end
    return 1
end

function wyk.func.IconID(file)
    for ii = 1, wyk.vars.IconCount, 1 do
        if wyk.vars.Icons[ii].file == file then return ii; end
    end
    return 1
end

function wyk.func.deriveSlot(slot)
    return Utility.Item.Slot.Equipment(slot)
end

function wyk.func.deriveItem(slot)
    return Inspect.Item.Detail(deriveSlot(slot))
end

function wyk.func.colorize(text, fromHex, toHex)
	-- special thanks to Vincemann of RiftMeter [chuckySTAR@gmail.com]
	--local colored = ""
	local colored = {}
	local len = text:len() - 1

	local from = {
		r = bit.rshift(fromHex, 16),
		g = bit.band(bit.rshift(fromHex, 8), 0xff),
		b = bit.band(fromHex, 0xff)
	}

	local to = {
		r = bit.rshift(toHex, 16),
		g = bit.band(bit.rshift(toHex, 8), 0xff),
		b = bit.band(toHex, 0xff)
	}
	
	local step = {
		r = (to.r - from.r) / len,
		g = (to.g - from.g) / len,
		b = (to.b - from.b) / len
	}

	for char in text:gmatch(".") do
		--colored = colored.."<font color='#"..tostring(from.r)..tostring(from.g)..tostring(from.b).."'>"..char.." "..tostring(from.r)..tostring(from.g)..tostring(from.b).." </font>"
		table.insert(colored, ("<font color=\"#%02x%02x%02x\">%s</font>"):format(from.r, from.g, from.b, char))
		from.r = from.r + step.r
		from.g = from.g + step.g
		from.b = from.b + step.b
	end

	--return colored
	return table.concat(colored)
end

function wyk.func.colorPrint(text, fromHex, toHex)
	local t = wyk.func.colorize(text, fromHex, toHex)
	Command.Console.Display("general", true, t, true)
end

