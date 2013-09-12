local thingsToMove = {}
local hasThingsToMove = false
local waitingCount = 0
local onItem = 0
local waitingFor = nil
local thingsMoved = {}
local stageOneComplete = false
local stageTwoComplete = false
local stageThreeComplete = false

Wykkyd.Outfitter.EmptySlots = {}
Wykkyd.Outfitter.EmptySlotCount = 0
Wykkyd.Outfitter.UsingSlot = 1

function Wykkyd.Outfitter.SittingInBag(slot)
    if string.match(slot, "si01.") then return true
    elseif string.match(slot, "si02.") then return true
    elseif string.match(slot, "si03.") then return true
    elseif string.match(slot, "si04.") then return true
    elseif string.match(slot, "si05.") then return true
    elseif string.match(slot, "si06.") then return true
    elseif string.match(slot, "si07.") then return true
    else return false
    end
end

local handedOut = {}

local function firstEmpty(stack)
    if stack then
        --wyk.func.TPrint(stack)
        for s, i in pairs(stack) do
            if i == false then
                for _, v in pairs(handedOut) do
                    if s ~= v then
                        table.insert(handedOut, s)
                        return s
                    end
                end
                table.insert(handedOut, s)
                return s
            end
        end
    end
    return nil
end

function Wykkyd.Outfitter.FirstEmptyBagSlot()
	local slot = nil
	slot = firstEmpty(Inspect.Item.List("si01"))
	if slot ~= nil then return slot; end
	slot = firstEmpty(Inspect.Item.List("si02"))
	if slot ~= nil then return slot; end
	slot = firstEmpty(Inspect.Item.List("si03"))
	if slot ~= nil then return slot; end
	slot = firstEmpty(Inspect.Item.List("si04"))
	if slot ~= nil then return slot; end
	slot = firstEmpty(Inspect.Item.List("si05"))
	if slot ~= nil then return slot; end
	slot = firstEmpty(Inspect.Item.List("si06"))
	if slot ~= nil then return slot; end
	slot = firstEmpty(Inspect.Item.List("si07"))
	return slot
end

local function secondEmpty(stack,ignore)
    if stack then
        for s, i in pairs(stack) do
            if i == false then
                if s ~= ignore then return s; end
            end
        end
    end
    return nil
end

function Wykkyd.Outfitter.SecondEmptyBagSlot(ignore)
	local slot = nil
	slot = secondEmpty(Inspect.Item.List("si01"),ignore)
	if slot ~= nil then return slot; end
	slot = secondEmpty(Inspect.Item.List("si02"),ignore)
	if slot ~= nil then return slot; end
	slot = secondEmpty(Inspect.Item.List("si03"),ignore)
	if slot ~= nil then return slot; end
	slot = secondEmpty(Inspect.Item.List("si04"),ignore)
	if slot ~= nil then return slot; end
	slot = secondEmpty(Inspect.Item.List("si05"),ignore)
	if slot ~= nil then return slot; end
	slot = secondEmpty(Inspect.Item.List("si06"),ignore)
	if slot ~= nil then return slot; end
	slot = secondEmpty(Inspect.Item.List("si07"),ignore)
	return slot
end

function Wykkyd.Outfitter.FindEmptySlots()
    local slotCount = 0
    Wykkyd.Outfitter.EmptySlotCount = 0
    Wykkyd.Outfitter.EmptySlots = {}
    local stack = Inspect.Item.List("si01")
    if stack then
        for s, i in pairs(stack) do
            if i == false then
                slotCount = slotCount+1
                Wykkyd.Outfitter.EmptySlots[slotCount] = s
                Wykkyd.Outfitter.EmptySlotCount = slotCount
            end
        end
    end
    stack = Inspect.Item.List("si02")
    if stack then
        for s, i in pairs(stack) do
            if i == false then
                slotCount = slotCount+1
                Wykkyd.Outfitter.EmptySlots[slotCount] = s
                Wykkyd.Outfitter.EmptySlotCount = slotCount
            end
        end
    end
    stack = Inspect.Item.List("si03")
    if stack then
        for s, i in pairs(stack) do
            if i == false then
                slotCount = slotCount+1
                Wykkyd.Outfitter.EmptySlots[slotCount] = s
                Wykkyd.Outfitter.EmptySlotCount = slotCount
            end
        end
    end
    stack = Inspect.Item.List("si04")
    if stack then
        for s, i in pairs(stack) do
            if i == false then
                slotCount = slotCount+1
                Wykkyd.Outfitter.EmptySlots[slotCount] = s
                Wykkyd.Outfitter.EmptySlotCount = slotCount
            end
        end
    end
    stack = Inspect.Item.List("si05")
    if stack then
        for s, i in pairs(stack) do
            if i == false then
                slotCount = slotCount+1
                Wykkyd.Outfitter.EmptySlots[slotCount] = s
                Wykkyd.Outfitter.EmptySlotCount = slotCount
            end
        end
    end

    stack = Inspect.Item.List("si06")
    if stack then
        for s, i in pairs(stack) do
            if i == false then
                slotCount = slotCount+1
                Wykkyd.Outfitter.EmptySlots[slotCount] = s
                Wykkyd.Outfitter.EmptySlotCount = slotCount
            end
        end
    end
    stack = Inspect.Item.List("si07")
    if stack then
        for s, i in pairs(stack) do
            if i == false then
                slotCount = slotCount+1
                Wykkyd.Outfitter.EmptySlots[slotCount] = s
                Wykkyd.Outfitter.EmptySlotCount = slotCount
            end
        end
    end

    if Wykkyd.Outfitter.EmptySlotCount == 0 then
        Wykkyd.Outfitter.UsingSlot = 0
    else
        Wykkyd.Outfitter.UsingSlot = 1
    end
    return Wykkyd.Outfitter.EmptySlotCount
end

local function rebuildthingsToMove(o, i)
    local c = 0
    local x = 0
    for _, v in pairs(o) do
        x = x+1
    end
    local n = {}
    for ii = 1, x, 1 do
        if ii ~= i then
            c = c + 1
            n[c] = thingsToMove[ii]
        end
    end
    if c == 0 then
        stageOneComplete = true
        stageTwoComplete = true
        stageThreeComplete = true
    end
    thingsToMove = n
    return c
end

function Wykkyd.Outfitter.RegisterGearSwap( stageNum, src, dest, itm1, itm2, swap, waitFor )
    if thingsToMove == nil then thingsToMove = {}; end
    waitingCount = rebuildthingsToMove(thingsToMove, 0)
    waitingCount = waitingCount + 1
    thingsToMove[waitingCount] = { 
        stage = stageNum,
        key = waitingCount, 
        from = src, to = dest, wait = waitFor, }
end

function Wykkyd.Outfitter.AttemptEquip(id, targetSlot, hasRoom)
    if wyk.func.NilSafe(id) == "" then
        return 
    end
    if not Inspect.Item.Find(id) then 
		local itm = Inspect.Item.Detail(id)
		local nm = nil
		if itm then nm = itm.name else nm = id end
        print("Couldn't find item: "..nm)
        table.insert( Wykkyd.Outfitter.Globals.notFound, { item = id, slot = targetSlot } )
        return 
    end
    local item = Inspect.Item.Detail(id)
    if item then
        --wyk.func.TPrint(item)
        itemType = Wykkyd.Outfitter.ParseItemType(item.category)
        if itemType ~= nil then
            if itemType.typeArmor or itemType.typeCostume or itemType.typeWeapon or itemType.typeAccessory or itemType.typePlanarFocus then
				--print("trying to equip it")
                local source = Inspect.Item.Find(item)
                local target = ""
                local alreadyInBag = false
                local midPoint = nil
                if source then
                    source = source.id
                    if targetSlot ~= nil then
                        for idx, slot in pairs(itemType.slotID) do
                            if wyk.vars.eqpSlots[targetSlot] ~= null then
                                if wyk.vars.eqpSlots[targetSlot] == slot then
                                    target = slot
                                end
                            elseif targetSlot == slot then
                                target = slot
                            end
                        end
                    end
                    if target == "" then
                        for idx, slot in pairs(itemType.slotID) do
                            target = slot
                            
                            break
                        end
                    end
                    if Wykkyd.Outfitter.SittingInBag(source) then
                        alreadyInBag = true
                        midPoint = nil
                    else
                        if hasRoom == 0 then
                            midPoint = Wykkyd.Outfitter.FirstEmptyBagSlot()
                        end
                    end
                    if source ~= target then
                        local displacedItem = false
                        if target ~= nil then 
                            if target ~= "BAG" then 
								if pcall(Inspect.Item.Detail, target) then
									displacedItem = Inspect.Item.Detail(target) 
								end
                            end
                        end
                        if displacedItem then
                            local displacedID = displacedItem.id
                            if not alreadyInBag then
                                if midPoint == nil and hasRoom == 0 then
                                    print("You must have at least 1 bag slot open to swap gear that isn't already in your bags")
                                else
                                    if hasRoom > 0 then
                                        if Wykkyd.Outfitter.EmptySlots == nil then Wykkyd.Outfitter.EmptySlots = hasRoom end
                                        Wykkyd.Outfitter.RegisterGearSwap( 1, source, "BAG", id, false, false, { thing = id, inPlace = source, notInPlace = false, } )
                                        Wykkyd.Outfitter.RegisterGearSwap( 2, "BAG", target, id, displacedID, true, { thing = id, inPlace = false, notInPlace = source, } )
                                        Wykkyd.Outfitter.RegisterGearSwap( 3, "BAG", source, displacedID, false, false, { thing = displacedID, inPlace = false, notInPlace = target, } )
                                    else
                                        --print("Prepping stage 4 swap")
                                        Wykkyd.Outfitter.RegisterGearSwap( 4, source, midPoint, id, false, false, { thing = id, inPlace = source, notInPlace = false, } )
                                        Wykkyd.Outfitter.RegisterGearSwap( 4, midPoint, target, id, displacedID, true, { thing = id, inPlace = false, notInPlace = source, } )
                                        Wykkyd.Outfitter.RegisterGearSwap( 4, midPoint, source, displacedID, false, false, { thing = displacedID, inPlace = false, notInPlace = target, } )
                                    end
                                end
                            else
                                --pcall(Command.Item.Move, source, target)
                                Wykkyd.Outfitter.RegisterGearSwap( 1, source, target, id, false, false, { thing = id, inPlace = source, notInPlace = false, } )
                            end
                        else
							if hasRoom > 0 then
                            Wykkyd.Outfitter.RegisterGearSwap( 1, source, "BAG", id, false, false, { thing = id, inPlace = source, notInPlace = false, } )
                            Wykkyd.Outfitter.RegisterGearSwap( 2, "BAG", target, id, false, false, { thing = id, inPlace = false, notInPlace = source, } )
                            end
                            
                        end
                    end
                end
            end
        end
    end
end

function Wykkyd.Outfitter.CheckStages()
    stageOneComplete = true
    stageTwoComplete = true
    stageThreeComplete = true
    for ii = 1, waitingCount, 1 do
        if thingsToMove[ii].stage == 1 then
            stageOneComplete = false
            break
        end
    end
    for ii = 1, waitingCount, 1 do
        if thingsToMove[ii].stage == 2 then
            stageTwoComplete = false
            break
        end
    end
    for ii = 1, waitingCount, 1 do
        if thingsToMove[ii].stage == 3 then
            stageThreeComplete = false
            break
        end
    end
end

local inProcess = false

function Wykkyd.Outfitter.PrepGearChange()
    inProcess = true
    --print("starting a new gear swap. Was waiting for "..waitingCount.." items")
    waitingCount = 0
    handedOut = {}
    thingsToMove = {}
end

function Wykkyd.Outfitter.DonePreparingGearChange()
    inProcess = false
    Wykkyd.Outfitter.FindEmptySlots()
    waitingCount = rebuildthingsToMove(thingsToMove, 0)
    --print("ready for new gear swap, "..waitingCount.." items")
    Wykkyd.Outfitter.ChangeGear()
end

local function processStage(n)
    waitingCount = rebuildthingsToMove(thingsToMove, 0)
    local dump = {}
    local x = 0
    for ii = 1, waitingCount, 1 do
        if thingsToMove[ii].stage == n then
            local place = Inspect.Item.Find(thingsToMove[ii].wait.thing) 
            if place ~= nil then
                if type(thingsToMove[ii].wait.inPlace) == "string" then
                    --print("Stage "..n.." item should be in place "..thingsToMove[ii].wait.inPlace.." and is in "..place)
                    if place == thingsToMove[ii].wait.inPlace then
                        if thingsToMove[ii].to == "BAG" then
                            --print("trying to use slot "..Wykkyd.Outfitter.UsingSlot)
                            local bagSlot = Wykkyd.Outfitter.EmptySlots[Wykkyd.Outfitter.UsingSlot]
                            Wykkyd.Outfitter.UsingSlot = Wykkyd.Outfitter.UsingSlot + 1
                            --print("Moving to bag slot "..bagSlot)
                            if pcall(Command.Item.Move, thingsToMove[ii].from, bagSlot) then
                                --print("Moved "..thingsToMove[ii].wait.thing.." from "..thingsToMove[ii].from.." to "..thingsToMove[ii].to)
                                waitingCount = rebuildthingsToMove(thingsToMove, ii)
                                inProcess = false
                                return 
                            end
                        else
                            if pcall(Command.Item.Move, thingsToMove[ii].from, thingsToMove[ii].to) then
                                --print("Moved "..thingsToMove[ii].wait.thing.." from "..thingsToMove[ii].from.." to "..thingsToMove[ii].to)
                                waitingCount = rebuildthingsToMove(thingsToMove, ii)
                                inProcess = false
                                return 
                            end
                        end
                    --else
                        --print("Waiting on "..thingsToMove[ii].wait.thing.." to be "..thingsToMove[ii].wait.inPlace)
                    end
                elseif place ~= thingsToMove[ii].wait.notInPlace then
                    if thingsToMove[ii].to == "BAG" then
                        if pcall(Command.Item.Move, place, Wykkyd.Outfitter.FirstEmptyBagSlot()) then
                            --print("Moved "..thingsToMove[ii].wait.thing.." from "..place.." to "..thingsToMove[ii].to)
                            waitingCount = rebuildthingsToMove(thingsToMove, ii)
                            inProcess = false
                            return 
                        end
                    else
                        if thingsToMove[ii].from == "BAG" then
                            if Wykkyd.Outfitter.SittingInBag(place) then
                                if pcall(Command.Item.Move, place, thingsToMove[ii].to) then
                                    --print("Moved "..thingsToMove[ii].wait.thing.." from "..place.." to "..thingsToMove[ii].to)
                                    waitingCount = rebuildthingsToMove(thingsToMove, ii)
                                    inProcess = false
                                    return 
                                end
                            --else
                                --print("Needed it to be in a bag but it's not")
                            end
                        else
                            if pcall(Command.Item.Move, place, thingsToMove[ii].to) then
                                --print("Moved "..thingsToMove[ii].wait.thing.." from "..place.." to "..thingsToMove[ii].to)
                                waitingCount = rebuildthingsToMove(thingsToMove, ii)
                                inProcess = false
                                return 
                            end
                        end
                    end
                --else
                    --print("Waiting on "..thingsToMove[ii].wait.thing.." to not be "..thingsToMove[ii].wait.notInPlace)
                end
            --else
                --print("Couldn't find "..thingsToMove[ii].wait.thing)
            end
        end
    end
    inProcess = false
end

local bHasBeenForced = false

function Wykkyd.Outfitter.ChangeGear()
    if waitingCount > 0 and not inProcess then 
		--print("Changing Gear, I think")
        inProcess = true
        Wykkyd.Outfitter.CheckStages()
        if not stageOneComplete then processStage(1); return; end
        if not stageTwoComplete then processStage(2); return; end
        if not stageThreeComplete then processStage(3); return; end
        processStage(4)
        --print("Still waiting on "..waitingCount.." item")
    end
end

if not bHasBeenForced then
	Command.Event.Attach(Event.System.Update.Begin, Wykkyd.Outfitter.ChangeGear, "Gear Change Monitor")
    bHasBeenForced = true
end
