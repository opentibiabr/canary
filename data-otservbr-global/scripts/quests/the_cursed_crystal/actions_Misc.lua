local cursedMiscItem = Action()

local MIN_POS_GO = Position(31957, 32935, 9)
local MAX_POS_GO = Position(31966, 32942, 9)

local validItems = { 4809, 4810, 4811, 4812, 4813 }

local function isInArea(pos, fromPos, toPos)
	return pos.x >= fromPos.x and pos.x <= toPos.x and pos.y >= fromPos.y and pos.y <= toPos.y and pos.z == fromPos.z
end

local function hasValidItem(position)
	local tile = Tile(position)
	if tile then
		for _, itemId in ipairs(validItems) do
			if tile:getItemById(itemId) then
				return true
			end
		end
	end
	return false
end

local function isVortexInArea(fromPos, toPos)
	for x = fromPos.x, toPos.x do
		for y = fromPos.y, toPos.y do
			local tile = Tile(Position(x, y, fromPos.z))
			if tile and tile:getItemById(7804) then
				return true
			end
		end
	end
	return false
end

function cursedMiscItem.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 5902 then
		if (target.itemid == 2535) or (target.itemid == 2537) or (target.itemid == 2539) or (target.itemid == 2541) then
			item:remove(1)
			player:addItem(9106, 1)
		end
	elseif item.itemid == 21554 then
		local playerPos = player:getPosition()

		if isInArea(playerPos, MIN_POS_GO, MAX_POS_GO) and hasValidItem(playerPos) then
			if not isVortexInArea(MIN_POS_GO, MAX_POS_GO) then
				Game.createItem(7804, 1, playerPos)
				local vortex = Tile(playerPos):getItemById(7804)

				if vortex then
					vortex:setActionId(35001)
					player:getPosition():sendMagicEffect(CONST_ME_SOUND_WHITE)
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "As you use the small bell, an unearthly sound rings out sweetly. At the same moment, the lake's waters begin to whirl.")

					addEvent(function()
						local vortexItem = Tile(playerPos):getItemById(7804)
						if vortexItem then
							vortexItem:remove()
						end
					end, 10000)
				end
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A vortex already exists in this area.")
			end
		end
	end

	return true
end

cursedMiscItem:id(5902, 21554)
cursedMiscItem:register()

local TCC_SKELETON_PAPER_POS = Position(31974, 32907, 8)
local TCC_SKELETON_BELL_POS = Position(32031, 32914, 8)

local theCursedMiscAction = Action()

function theCursedMiscAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.actionid == 40001 and item:getPosition() == TCC_SKELETON_PAPER_POS then
		if player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Oneeyedjoe) < 1 and player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.SheetOfPaper) < 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a sheet of paper.")
			local paperCursedCrystal = player:addItem(2820, 1)
			paperCursedCrystal:setAttribute(
				ITEM_ATTRIBUTE_TEXT,
				"I did it! I reached the crystal gardens! What beauty and splendor I have seen down there. Even more: I discovered a small subterranean lake - but Harry was there before me. And he did something strange: He ringed a small, transparent looking bell and immediately a big whirl appeared in the water. I suppose this is the mysterious way deeper into the caves we sought after for so long. But Harry, the coward, didn't dare to dive into the water. Instead he left the caverns and headed back to the surface. I must have this bell!"
			)
			player:setStorageValue(Storage.Quest.U10_70.TheCursedCrystal.SheetOfPaper, 1)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The pile of bones is empty.")
		end
	elseif item.actionid == 40001 and item:getPosition() == TCC_SKELETON_BELL_POS then
		if player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Oneeyedjoe) < 1 and player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.SmallCrystalBell) < 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a small crystal bell.")
			player:addItem(21554, 1)
			player:setStorageValue(Storage.Quest.U10_70.TheCursedCrystal.SmallCrystalBell, 1)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The pile of bones is empty.")
		end
	elseif item.actionid == 40002 and item.itemid == 21572 then
		if player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Oneeyedjoe) < 1 and player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.SheetOfPaper) > 0 and player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.SmallCrystalBell) > 0 then
			if player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Time) < os.time() then
				player:addItem(21504, 1)
				item:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You take some blood out of the hollow crystal. Hopefully it is actually a medusa's blood.")
				player:setStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Oneeyedjoe, 1)
			end
		end
	end

	return true
end

theCursedMiscAction:aid(40001, 40002)
theCursedMiscAction:register()
