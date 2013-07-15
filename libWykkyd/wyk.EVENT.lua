local toc, data = ...
local id = toc.identifier

wyk.EVENT.SecureEnter = {}
function wyk.EVENT.SecureEntry()
	for _,callback in pairs(wyk.EVENT.SecureEnter) do
		callback()
	end
end
--table.insert(Event.System.Secure.Enter, {wyk.EVENT.SecureEntry, id, "libWykkyd Security Handler"} )
Command.Event.Attach(Event.System.Secure.Enter, wyk.EVENT.SecureEntry, "libWykkyd Security Handler")
wyk.EVENT.SecureLeave = {}
function wyk.EVENT.SecureExit()
	for _,callback in pairs(wyk.EVENT.SecureLeave) do
		callback()
	end
end
--table.insert(Event.System.Secure.Leave, {wyk.EVENT.SecureExit, id, "libWykkyd Security Handler"} )
Command.Event.Attach(Event.System.Secure.Leave, wyk.EVENT.SecureExit, "libWykkyd Security Handler")
--Command.Event.Attach(Event.Item.Slot, Wykkyd.Outfitter.UpdateWindow, "Wykkyd.Outfitter.UpdateWindow")
--table.insert(Event.Item.Slot,{Wykkyd.Outfitter.UpdateWindow, "Gadgets_Outfitter", "Wykkyd.Outfitter.UpdateWindow" })
