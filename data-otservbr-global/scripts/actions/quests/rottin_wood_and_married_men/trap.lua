function removeMonster()
	doRemoveItem(getTileItemById({ x = 32662, y = 32190, z = 7 }, 2768).uid, 1)
	Position(32662, 32190, 7):sendMagicEffect(CONST_ME_STONES)
	local TOP_LEFT_CORNER = { x = 32651, y = 32178, z = 7 }
	local BOTTOM_RIGHT_CORNER = { x = 32668, y = 32190, z = 7 }

	for Py = TOP_LEFT_CORNER.y, BOTTOM_RIGHT_CORNER.y do
		for Px = TOP_LEFT_CORNER.x, BOTTOM_RIGHT_CORNER.x do
			local tile = Tile(Position({ x = Px, y = Py, z = 7 }))
			if tile then
				local monster = tile:getTopCreature()
				if monster and monster:isMonster() and monster:getName() == "Travelling Merchant" then
					-- monster:remove()
					monster:getPosition():sendMagicEffect(CONST_ME_STONES)
					--setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Trap, -1)
				end
			end
		end
	end
	return true
end

function removeTrap()
	local TOP_LEFT_CORNER = { x = 32651, y = 32178, z = 7, stackpos = 253 }
	local BOTTOM_RIGHT_CORNER = { x = 32668, y = 32190, z = 7, stackpos = 253 }
	for Py = TOP_LEFT_CORNER.y, BOTTOM_RIGHT_CORNER.y do
		for Px = TOP_LEFT_CORNER.x, BOTTOM_RIGHT_CORNER.x do
			local trap = getTileItemById({ x = Px, y = Py, z = 7 }, 12187)
			if trap then
				setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Trap, -1)
				doRemoveItem(trap.uid, 1)
			end
		end
	end
	return true
end

local rottinWoodtrap = Action()
function rottinWoodtrap.onUse(cid, item, fromPosition, itemEx, toPosition, isHotkey)
	if item.itemid == 12186 then
		if itemEx.itemid == 10480 then
			if (getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Mission03) == 5) and getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Trap) < 3 then
				doCreatureSay(cid, "You place the trap carefully on the  ground. Between twigs and leaves it is almost invisible.", TALKTYPE_MONSTER_SAY)
				doRemoveItem(item.uid, 1)
				Game.createItem(12187, 1, toPosition)
				setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Trap, getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Trap) + 1)
			else
				if getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Trap) == 3 then
					doCreatureSay(cid, "It looks like the merchants are about to arrive, better hide somewhere where you can see whats going on in the area.", TALKTYPE_MONSTER_SAY)
					doRemoveItem(item.uid, 1)
					Game.createItem(12187, 1, toPosition)
					doTeleportThing(cid, { x = 32660, y = 32193, z = 7 })
					Player(cid):getPosition():sendMagicEffect(CONST_ME_STONES)
					Game.createItem(2768, 1, { x = 32662, y = 32190, z = 7 }) -- small fir tree
					----------------------- SUMMON MERCHANT -----------------------------
					doSummonCreature("Travelling Merchant", { x = 32656, y = 32182, z = 7 })
					doSummonCreature("Travelling Merchant", { x = 32660, y = 32181, z = 7 })
					doSummonCreature("Travelling Merchant", { x = 32661, y = 32184, z = 7 })
					doSummonCreature("Travelling Merchant", { x = 32662, y = 32181, z = 7 })
					doSummonCreature("Travelling Merchant", { x = 32657, y = 32185, z = 7 })
					----------------------------------------------------------------------
					addEvent(removeMonster, 5 * 60 * 1000)
					addEvent(removeTrap, 5 * 60 * 1000)
				end
			end
		end
	end
	return true
end

rottinWoodtrap:id(12186)
rottinWoodtrap:register()
