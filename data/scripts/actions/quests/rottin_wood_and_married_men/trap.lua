function removeMonster()
    doRemoveItem(getTileItemById({x = 32662, y = 32190, z = 7}, 2768).uid,1)
    doSendMagicEffect({x = 32662, y = 32190, z = 7}, 45)
    TOP_LEFT_CORNER = {x = 32651, y = 32178, z = 7, stackpos=253}
    BOTTOM_RIGHT_CORNER = {x = 32668, y = 32190, z = 7, stackpos=253}
	for Py = TOP_LEFT_CORNER.y, BOTTOM_RIGHT_CORNER.y do
		for Px = TOP_LEFT_CORNER.x, BOTTOM_RIGHT_CORNER.x do
			creature = getThingfromPos({x=Px, y=Py, z=7, stackpos=253})
			if isMonster(creature.uid) then
				if getCreatureName(creature.uid) == "Travelling Merchant" then
					--doRemoveCreature(creature.uid)
					doSendMagicEffect({x=Px, y=Py, z=7}, 45)
					--setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Trap, -1)
				end
			end
		end
    end
    return TRUE
end


function removeTrap()
    TOP_LEFT_CORNER = {x = 32651, y = 32178, z = 7, stackpos=253}
   	 BOTTOM_RIGHT_CORNER = {x = 32668, y = 32190, z = 7, stackpos=253}
		for Py = TOP_LEFT_CORNER.y, BOTTOM_RIGHT_CORNER.y do
			for Px = TOP_LEFT_CORNER.x, BOTTOM_RIGHT_CORNER.x do
   			    local trap = getTileItemById({x=Px, y=Py, z=7}, 13174)
 				 if trap then
				 setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Trap, -1)
    		     doRemoveItem(trap.uid, 1)
			end
		end
    end
    return TRUE
end


local rottinWoodtrap = Action()
function rottinWoodtrap.onUse(cid, item, fromPosition, itemEx, toPosition, isHotkey)
	if(item.itemid == 13173) then
		if(itemEx.itemid == 11436) then
			if(getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Mission03) == 5) and getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Trap) < 3 then
			doCreatureSay(cid, "You place the trap carefully on the  ground. Between twigs and leaves it is almost invisible.", TALKTYPE_ORANGE_1)
			doRemoveItem(item.uid, 1)
			Game.createItem(13174, 1, toPosition)
			setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Trap, getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Trap) + 1)
		else
			if(getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Trap) == 3) then
			doCreatureSay(cid, "It looks like the merchants are about to arrive, better hide somewhere where you can see whats going on in the area.", TALKTYPE_ORANGE_1)
			doRemoveItem(item.uid, 1)
			Game.createItem(13174, 1, toPosition)
			doTeleportThing(cid, {x = 32660, y = 32193, z = 7})
			doSendMagicEffect(getCreaturePosition(cid), 45)
			Game.createItem(2768, 1, {x = 32662, y = 32190, z = 7}) -- small fir tree
			----------------------- SUMMON MERCHANT -----------------------------
			doSummonCreature("Travelling Merchant", {x = 32656, y = 32182, z = 7})
			doSummonCreature("Travelling Merchant", {x = 32660, y = 32181, z = 7})
			doSummonCreature("Travelling Merchant", {x = 32661, y = 32184, z = 7})
			doSummonCreature("Travelling Merchant", {x = 32662, y = 32181, z = 7})
			doSummonCreature("Travelling Merchant", {x = 32657, y = 32185, z = 7})
			----------------------------------------------------------------------
			addEvent(removeMonster, 5*60*1000)
			addEvent(removeTrap, 5*60*1000)
			end
		   end
	      end
	end
	return true
end

rottinWoodtrap:id(13173)
rottinWoodtrap:register()