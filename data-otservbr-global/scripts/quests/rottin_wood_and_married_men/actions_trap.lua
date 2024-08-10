function removeMonster()
	local TOP_LEFT_CORNER = { x = 32651, y = 32178, z = 7 }
	local BOTTOM_RIGHT_CORNER = { x = 32668, y = 32190, z = 7 }

	-- Iterate over the area defined by TOP_LEFT_CORNER and BOTTOM_RIGHT_CORNER
	for Py = TOP_LEFT_CORNER.y, BOTTOM_RIGHT_CORNER.y do
		for Px = TOP_LEFT_CORNER.x, BOTTOM_RIGHT_CORNER.x do
			local tile = Tile(Position({ x = Px, y = Py, z = 7 }))
			if tile then
				local monster = tile:getTopCreature()
				-- Check if there is a "Travelling Merchant" monster on this tile
				if monster and monster:isMonster() and monster:getName() == "Travelling Merchant" then
					-- Apply visual effect
					monster:getPosition():sendMagicEffect(CONST_ME_STONES)

					-- Remove the monster
					monster:remove()
				end
			end
		end
	end
	return true
end

function removeTrap()
	local TOP_LEFT_CORNER = { x = 32651, y = 32178, z = 7 }
	local BOTTOM_RIGHT_CORNER = { x = 32668, y = 32190, z = 7 }

	-- Iterate over the area defined by TOP_LEFT_CORNER and BOTTOM_RIGHT_CORNER
	for Py = TOP_LEFT_CORNER.y, BOTTOM_RIGHT_CORNER.y do
		for Px = TOP_LEFT_CORNER.x, BOTTOM_RIGHT_CORNER.x do
			local trap = getTileItemById({ x = Px, y = Py, z = 7 }, 12187)
			if trap and trap.uid > 0 then
				-- Update player's storage value
				setPlayerStorageValue(cid, Storage.Quest.U8_7.RottinWoodAndTheMarriedMen.Trap, -1)

				-- Remove the trap
				doRemoveItem(trap.uid, 1)

				-- Create item 12189 at the position where the trap was removed
				Game.createItem(12189, 1, { x = Px, y = Py, z = 7 })
			end
		end
	end

	-- Schedule the removal of items 12189 after a set time (e.g., 5 minutes)
	addEvent(removeItems, 5 * 60 * 1000)
	return true
end

function removeItems()
	local TOP_LEFT_CORNER = { x = 32651, y = 32178, z = 7 }
	local BOTTOM_RIGHT_CORNER = { x = 32668, y = 32190, z = 7 }

	-- Iterate over the area defined by TOP_LEFT_CORNER and BOTTOM_RIGHT_CORNER
	for Py = TOP_LEFT_CORNER.y, BOTTOM_RIGHT_CORNER.y do
		for Px = TOP_LEFT_CORNER.x, BOTTOM_RIGHT_CORNER.x do
			local item = getTileItemById({ x = Px, y = Py, z = 7 }, 12189)
			if item and item.uid > 0 then
				-- Remove item 12189
				doRemoveItem(item.uid, 1)
			end
		end
	end
	return true
end

local rottinWoodtrap = Action()
function rottinWoodtrap.onUse(cid, item, fromPosition, itemEx, toPosition, isHotkey)
	if item.itemid == 12186 then
		if itemEx.itemid == 10480 then
			-- Check the player's storage values to determine if the trap can be placed
			if (getPlayerStorageValue(cid, Storage.Quest.U8_7.RottinWoodAndTheMarriedMen.Mission03) == 5) and getPlayerStorageValue(cid, Storage.Quest.U8_7.RottinWoodAndTheMarriedMen.Trap) < 3 then
				doCreatureSay(cid, "You place the trap carefully on the ground. Between twigs and leaves it is almost invisible.", TALKTYPE_MONSTER_SAY)

				-- Remove the trap item from the player's inventory and place it on the ground
				doRemoveItem(item.uid, 1)
				Game.createItem(12187, 1, toPosition)

				-- Update the player's storage value to reflect the placement of the trap
				setPlayerStorageValue(cid, Storage.Quest.U8_7.RottinWoodAndTheMarriedMen.Trap, getPlayerStorageValue(cid, Storage.Quest.U8_7.RottinWoodAndTheMarriedMen.Trap) + 1)
			else
				if getPlayerStorageValue(cid, Storage.Quest.U8_7.RottinWoodAndTheMarriedMen.Trap) == 3 then
					doCreatureSay(cid, "It looks like the merchants are about to arrive, better hide somewhere where you can see what's going on in the area.", TALKTYPE_MONSTER_SAY)

					-- Remove the trap item and place it on the ground
					doRemoveItem(item.uid, 1)
					Game.createItem(12187, 1, toPosition)

					-- Teleport the player to a hiding spot and create a visual effect
					doTeleportThing(cid, { x = 32660, y = 32193, z = 7 })
					Player(cid):getPosition():sendMagicEffect(CONST_ME_STONES)

					-- Place a small fir tree at the specified location
					Game.createItem(2768, 1, { x = 32662, y = 32190, z = 7 }) -- small fir tree

					-- Summon the Travelling Merchant monsters in specified locations
					doSummonCreature("Travelling Merchant", { x = 32656, y = 32182, z = 7 })
					doSummonCreature("Travelling Merchant", { x = 32660, y = 32181, z = 7 })
					doSummonCreature("Travelling Merchant", { x = 32661, y = 32184, z = 7 })
					doSummonCreature("Travelling Merchant", { x = 32662, y = 32181, z = 7 })
					doSummonCreature("Travelling Merchant", { x = 32657, y = 32185, z = 7 })

					-- Schedule the removal of the monsters and traps after 5 minutes
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
