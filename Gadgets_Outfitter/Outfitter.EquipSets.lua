Wykkyd.Outfitter.EquipSets = {}
Wykkyd.Outfitter.EquipSetFrame = false

function Wykkyd.Outfitter.EquipSets.UnEquip(slot)
	if pcall(Inspect.Item.Detail, slot) then
		local displacedItem = Inspect.Item.Detail(slot)
		if displacedItem then
			Wykkyd.Outfitter.AttemptEquip(displacedItem, "BAG", hasRoom)
		end
	end
end

function Wykkyd.Outfitter.EquipSets.Equip(id, targetSlot, hasRoom)
    if id == nil then return end
    if id == 0 then return end
    Wykkyd.Outfitter.AttemptEquip(id, targetSlot, hasRoom)
end

function Wykkyd.Outfitter.EquipSets.Delete(myCount, id)
    local upd = {}
    for _, v in pairs(Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList) do
        if v.value ~= id then 
            if v.text ~= nil and v.text ~= "" then
                table.insert(upd, v)
            end
        end
    end
    Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList = upd
    upd = {}
    for i, l in pairs(Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList) do
        for _, v in pairs(Wykkyd.Outfitter.ContextConfig[myCount].EquipSetGear) do
            if v.id ~= id and l.value == v.id then 
                table.insert(upd, v)
            end
        end
    end
    Wykkyd.Outfitter.ContextConfig[myCount].EquipSetGear = upd
end

function Wykkyd.Outfitter.EquipSets.Save(myCount, id)
--TODO: clean this function up, don't have to create 2 sets of variables just to put it in a set
    if Wykkyd.Outfitter.Selected[myCount] == nil then Wykkyd.Outfitter.Selected[myCount] = {} end
    local name          = Wykkyd.Outfitter.Selected[myCount].Name
    if name == nil then return end
    if wyk.func.Trim(name) == "" then return end
    local makeIcon      = Wykkyd.Outfitter.Selected[myCount].ButtonChk
    local icon          = Wykkyd.Outfitter.Selected[myCount].Icon
    local changeRole    = Wykkyd.Outfitter.Selected[myCount].RoleChk
    local targetRole    = Wykkyd.Outfitter.Selected[myCount].Role
    local manageKaruul  = Wykkyd.Outfitter.Selected[myCount].KaruulChk
    local karuulSet1    = Wykkyd.Outfitter.Selected[myCount].Set1
    local karuulSet2    = Wykkyd.Outfitter.Selected[myCount].Set2
    local alertCheck    = Wykkyd.Outfitter.Selected[myCount].AlertChk
    local alertText    = Wykkyd.Outfitter.Selected[myCount].AlertText
    local alertChannel    = Wykkyd.Outfitter.Selected[myCount].AlertChannel
    local changeWardrobe = Wykkyd.Outfitter.Selected[myCount].WardrobeChk
    local targetWardrobe = Wykkyd.Outfitter.Selected[myCount].Wardrobe
    if Wykkyd.Outfitter.ContextConfig[myCount].EquipSetGear == nil then Wykkyd.Outfitter.ContextConfig[myCount].EquipSetGear = {}; end
    if Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList == nil then Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList = {}; end
    local updating = true
    local matched = false
    if id == 0 then
        for _, v in pairs(Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList) do
            if v.text == name then 
                id = v.value
                matched = true
                break
            elseif v.value > id then 
                id = v.value
            end
        end
        if not matched then
            id = id + 1
            updating = false
        end
    end
    Wykkyd.Outfitter.EquipSets.Delete(myCount, id)
    table.insert( Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList, { value = id, text = name } )
    Wykkyd.Outfitter.PrepList(myCount)
    local gearSet = {
            { disabled = Wykkyd.Outfitter.ignoredSlots[myCount].helmet, 
                id = wyk.func.DeriveID(Wykkyd.Outfitter.displayedGear[myCount].helmet), 
                targetSlot = Wykkyd.Outfitter.displayedGearSlot[myCount].helmet, },
            { disabled = Wykkyd.Outfitter.ignoredSlots[myCount].shoulders, 
                id = wyk.func.DeriveID(Wykkyd.Outfitter.displayedGear[myCount].shoulders), 
                targetSlot = Wykkyd.Outfitter.displayedGearSlot[myCount].shoulders, },
            { disabled = Wykkyd.Outfitter.ignoredSlots[myCount].cape, 
                id = wyk.func.DeriveID(Wykkyd.Outfitter.displayedGear[myCount].cape), 
                targetSlot = Wykkyd.Outfitter.displayedGearSlot[myCount].cape, },
            { disabled = Wykkyd.Outfitter.ignoredSlots[myCount].chest, 
                id = wyk.func.DeriveID(Wykkyd.Outfitter.displayedGear[myCount].chest), 
                targetSlot = Wykkyd.Outfitter.displayedGearSlot[myCount].chest, },
            { disabled = Wykkyd.Outfitter.ignoredSlots[myCount].gloves, 
                id = wyk.func.DeriveID(Wykkyd.Outfitter.displayedGear[myCount].gloves), 
                targetSlot = Wykkyd.Outfitter.displayedGearSlot[myCount].gloves, },
            { disabled = Wykkyd.Outfitter.ignoredSlots[myCount].belt, 
                id = wyk.func.DeriveID(Wykkyd.Outfitter.displayedGear[myCount].belt), 
                targetSlot = Wykkyd.Outfitter.displayedGearSlot[myCount].belt, }, 
            { disabled = Wykkyd.Outfitter.ignoredSlots[myCount].legs, 
                id = wyk.func.DeriveID(Wykkyd.Outfitter.displayedGear[myCount].legs), 
                targetSlot = Wykkyd.Outfitter.displayedGearSlot[myCount].legs, }, 
            { disabled = Wykkyd.Outfitter.ignoredSlots[myCount].feet, 
                id = wyk.func.DeriveID(Wykkyd.Outfitter.displayedGear[myCount].feet), 
                targetSlot = Wykkyd.Outfitter.displayedGearSlot[myCount].feet, },
            { disabled = Wykkyd.Outfitter.ignoredSlots[myCount].seal, 
                id = wyk.func.DeriveID(Wykkyd.Outfitter.displayedGear[myCount].seal), 
                targetSlot = Wykkyd.Outfitter.displayedGearSlot[myCount].seal, },
            { disabled = Wykkyd.Outfitter.ignoredSlots[myCount].handmain, 
                id = wyk.func.DeriveID(Wykkyd.Outfitter.displayedGear[myCount].handmain), 
                targetSlot = Wykkyd.Outfitter.displayedGearSlot[myCount].handmain, },
            { disabled = Wykkyd.Outfitter.ignoredSlots[myCount].handoff, 
                id = wyk.func.DeriveID(Wykkyd.Outfitter.displayedGear[myCount].handoff), 
                targetSlot = Wykkyd.Outfitter.displayedGearSlot[myCount].handoff, },
            { disabled = Wykkyd.Outfitter.ignoredSlots[myCount].ranged, 
                id = wyk.func.DeriveID(Wykkyd.Outfitter.displayedGear[myCount].ranged), 
                targetSlot = Wykkyd.Outfitter.displayedGearSlot[myCount].ranged, },
            { disabled = Wykkyd.Outfitter.ignoredSlots[myCount].neck, 
                id = wyk.func.DeriveID(Wykkyd.Outfitter.displayedGear[myCount].neck), 
                targetSlot = Wykkyd.Outfitter.displayedGearSlot[myCount].neck, },
            { disabled = Wykkyd.Outfitter.ignoredSlots[myCount].trinket, 
                id = wyk.func.DeriveID(Wykkyd.Outfitter.displayedGear[myCount].trinket), 
                targetSlot = Wykkyd.Outfitter.displayedGearSlot[myCount].trinket, },
            { disabled = Wykkyd.Outfitter.ignoredSlots[myCount].ring1, 
                id = wyk.func.DeriveID(Wykkyd.Outfitter.displayedGear[myCount].ring1), 
                targetSlot = Wykkyd.Outfitter.displayedGearSlot[myCount].ring1, },
            { disabled = Wykkyd.Outfitter.ignoredSlots[myCount].ring2, 
                id = wyk.func.DeriveID(Wykkyd.Outfitter.displayedGear[myCount].ring2), 
                targetSlot = Wykkyd.Outfitter.displayedGearSlot[myCount].ring2, },
            { disabled = Wykkyd.Outfitter.ignoredSlots[myCount].synergy, 
                id = wyk.func.DeriveID(Wykkyd.Outfitter.displayedGear[myCount].synergy), 
                targetSlot = Wykkyd.Outfitter.displayedGearSlot[myCount].synergy, },
            { disabled = Wykkyd.Outfitter.ignoredSlots[myCount].focus, 
                id = wyk.func.DeriveID(Wykkyd.Outfitter.displayedGear[myCount].focus), 
                targetSlot = Wykkyd.Outfitter.displayedGearSlot[myCount].focus, },
        }
    local _id = id
    local _name = name
    local _makeIcon = makeIcon
    local _icon = icon
    local _changeRole = changeRole
    local _targetRole = targetRole
    local _manageKaruul = manageKaruul
    local _karuulSet1 = karuulSet1
    local _karuulSet2 = karuulSet2
    local _alertCheck = alertCheck
    local _alertText = alertText
    local _alertChannel = alertChannel
    local _changeWardrobe = changeWardrobe
    local _targetWardrobe = targetWardrobe
    local tempList = {
        id = _id,
        name = _name,
        makeIcon = _makeIcon,
        icon = _icon,
        changeRole = _changeRole,
        targetRole = _targetRole,
        manageKaruul = _manageKaruul,
        karuulSet1 = _karuulSet1,
        karuulSet2 = _karuulSet2,
        alertCheck = _alertCheck,
        alertText = _alertText,
        alertChannel = _alertChannel,
        gear = gearSet,
        changeWardrobe = _changeWardrobe,
        targetWardrobe = _targetWardrobe,
    }
    
    table.insert( Wykkyd.Outfitter.ContextConfig[myCount].EquipSetGear, tempList)
    Wykkyd.Outfitter.UpdateButton(myCount, tempList)
end

function Wykkyd.Outfitter.EquipSets.Load(myCount, id)
    if id == nil then return nil; end
    if id == 0 then return nil; end
    --print("context = "..myCount.." and set = "..id)
    local retVal = {}
    retVal.ignored = {}
    local hasRoom = Wykkyd.Outfitter.FindEmptySlots()
    Wykkyd.Outfitter.PrepGearChange()
    for _, g in pairs(Wykkyd.Outfitter.ContextConfig[myCount].EquipSetGear) do
        if g.id == id then
            retVal.id = g.id
            retVal.name = g.name
            retVal.icon = g.icon
            if type(g.makeIcon) == "string" then
                retVal.makeIcon = false
            else
                retVal.makeIcon = g.makeIcon
            end
            retVal.changeRole = g.changeRole
            retVal.manageKaruul = g.manageKaruul
            retVal.targetRole = g.targetRole
            retVal.karuulSet1 = g.karuulSet1
            retVal.karuulSet2 = g.karuulSet2
            retVal.alertCheck = g.alertCheck
            retVal.alertText = g.alertText
            retVal.alertChannel = g.alertChannel
            retVal.changeWardrobe = g.changeWardrobe
            retVal.targetWardrobe = g.targetWardrobe
            for idx, itm in pairs( g.gear ) do
                if not itm.disabled then
                    if wyk.func.NilSafe(itm.id) ~= "" then
                        Wykkyd.Outfitter.EquipSets.Equip(itm.id, itm.targetSlot, hasRoom)
                    end
                    table.insert(retVal.ignored, { slot = itm.targetSlot, ignored = false })
                else
                    table.insert(retVal.ignored, { slot = itm.targetSlot, ignored = true })
                end
            end
            for idx, itm in pairs( g.gear ) do
                if not itm.disabled then
                    if wyk.func.NilSafe(itm.id) == "" then
                        Wykkyd.Outfitter.EquipSets.UnEquip(itm.targetSlot)
                    end
                end
            end
            Wykkyd.Outfitter.DonePreparingGearChange()
            return retVal
        end
    end
    Wykkyd.Outfitter.DonePreparingGearChange()
    return nil
end

function Wykkyd.Outfitter.EquipSets.SwitchTo(myCount, id)
    local doNadaWithThis = Wykkyd.Outfitter.EquipSets.Load(myCount, id)
end

