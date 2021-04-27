local t = {
	[9118] = {{x=32991, y=31539, z=1}, {x=32991, y=31539, z=4}, effect = true}, --last, to flying carpet
	[9119] = {{x=32991, y=31539, z=4}, {x=32991, y=31539, z=1}, effect = true}, --to flying carpet
	[9120] = {{x=32993, y=31547, z=4}, {x=33061, y=31527, z=14}, effect = true}, -- elevator to Farmine
	[9121] = {{x=33061, y=31527, z=10}, {x=32993, y=31547, z=4}, effect = true}, -- Farmine Stage 3
	[9122] = {{x=33061, y=31527, z=12}, {x=32993, y=31547, z=4}, effect = true}, -- Farmine Stage 2
	[9123] = {{x=33061, y=31527, z=14}, {x=32993, y=31547, z=4}, effect = true} -- Farmine Stage 1
}

local elevatorLever = Action()

function elevatorLever.onUse(cid, item, fromPosition, itemEx, toPosition)
	local k = t[item.actionid]
	local thing = getTopCreature(k[1]).uid
	if(item.actionid == 9120 and item.itemid == 1945) then -- elevator to Farmine
		if(isPlayer(thing)) then
			if cid:getStorageValue(Storage.TheNewFrontier.Mission05) == 7 then -- if Farmine is on Stage 3
				k[2].z = 10
			elseif cid:getStorageValue(Storage.TheNewFrontier.Mission03) >= 2 then -- if Farmine is on Stage 2
				k[2].z = 12
			elseif cid:getStorageValue(Storage.TheNewFrontier.Mission03) < 2 then -- if Farmine is on Stage 1
				k[2].z = 14
			end
			doTeleportThing(thing, k[2], false)
			if(k.effect) then
				doSendMagicEffect(k[2], CONST_ME_TELEPORT)
			end
		end
	elseif(k and item.itemid == 1945) then
		if(isPlayer(thing)) then
			doTeleportThing(thing, k[2], false)
			if(k.effect) then
				doSendMagicEffect(k[2], CONST_ME_TELEPORT)
			end
		end
	end
	return doTransformItem(item.uid, item.itemid == 1945 and 1946 or 1945)
end

elevatorLever:aid(9118, 9119, 9120, 9121, 9122, 9123)
elevatorLever:register()
