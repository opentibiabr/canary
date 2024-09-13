local TCC_PILLARPETRIFIED = Position(31942, 32936, 10)
local ItemsCursed = {
	[11466] = { usedID = 21504, finalID = 21505 },
	[21504] = { usedID = 11466, finalID = 21505 },
	[21505] = { usedID = 21507, finalID = 21506 },
	[21507] = { usedID = 21505, finalID = 21506 },
}

local theCursedMedusa = Action()

function theCursedMedusa.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if (item.itemid == 21506) and (target.itemid == 10420) then
		if player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Oneeyedjoe) == 2 then
			local playerPos = player:getPosition()
			if not ((math.abs(playerPos.x - TCC_PILLARPETRIFIED.x) < 5) and (math.abs(playerPos.y - TCC_PILLARPETRIFIED.y) < 5) and (playerPos.z == TCC_PILLARPETRIFIED.z)) then
				return
			end
			player:setStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Oneeyedjoe, 3)
			item:remove(1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You unpetrify a banshee's scream near the evil crystal, your ears protected by wax. Thus the baleful artefact is destroyed.")
			local stone = Tile(TCC_PILLARPETRIFIED):getItemById(10797)
			doSendMagicEffect(stone:getPosition(), CONST_ME_POFF)
			stone:transform(10870)
			addEvent(function()
				stone:transform(10797)
			end, 5000)
		end
		return
	elseif item.itemid == 9106 then
		local topCreature = Tile(toPosition):getTopCreature()
		if not topCreature or not topCreature:isPlayer() then
			return
		end
		if (player == topCreature) and (player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Oneeyedjoe) < 2) then
			local playerPos = player:getPosition()
			if not ((math.abs(playerPos.x - TCC_PILLARPETRIFIED.x) < 5) and (math.abs(playerPos.y - TCC_PILLARPETRIFIED.y) < 5) and (playerPos.z == TCC_PILLARPETRIFIED.z)) then
				return
			end
			player:setStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Oneeyedjoe, 2)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You use the molten wax to plug your ears.")
			doSendMagicEffect(player:getPosition(), CONST_ME_YELLOWSMOKE)
			item:remove(1)
		end
		return
	end

	for index, value in pairs(ItemsCursed) do
		if item.itemid == index and target.itemid == value.usedID then
			if value.finalID == 21505 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You mixed the first ingredients to create a special ointment. But it isn't complete yet.")
			elseif value.finalID == 21506 then
				if player:getStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Questline) < 2 then
					player:setStorageValue(Storage.Quest.U10_70.TheCursedCrystal.Questline, 2)
				end
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You mixed the proper ingredients to create a special ointment. With this salve you may unpetrify a petrified object.")
			end

			item:remove(1)
			target:remove(1)
			player:addItem(value.finalID, 1)
			return true
		end
	end

	player:sendTextMessage(MESSAGE_FAILURE, "Sorry, not possible.")
end

theCursedMedusa:id(9106, 11466, 21504, 21505, 21507)
theCursedMedusa:register()
