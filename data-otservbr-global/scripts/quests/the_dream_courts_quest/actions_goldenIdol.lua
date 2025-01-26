local altars = {
	[1] = { position = Position(32591, 32629, 9) },
	[2] = { position = Position(32591, 32621, 9) },
	[3] = { position = Position(32602, 32629, 9) },
	[4] = { position = Position(32602, 32621, 9) },
}

local blockedItem = 29300
local storageIdolCount = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.IdolCount
local finalStorage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Temple
local totalAltars = 4
local resetTime = 1 * 60 * 1000

local function removeIdol(position)
	local idol = Tile(position):getItemById(blockedItem)
	if idol then
		idol:remove()
	end
end

local actions_goldenIdol = Action()

function actions_goldenIdol.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return true
	end

	local tPos = target:getPosition()

	for _, altar in pairs(altars) do
		if tPos == altar.position then
			local checkTile = Tile(altar.position):getItemById(blockedItem)
			if not checkTile then
				item:remove(1)
				Game.createItem(blockedItem, 1, altar.position)
				tPos:sendMagicEffect(CONST_ME_POFF)
				player:say("**placing idol**", TALKTYPE_MONSTER_SAY)

				local currentCount = player:getStorageValue(storageIdolCount)

				if currentCount < 0 then
					currentCount = 0
				end
				player:setStorageValue(storageIdolCount, currentCount + 1)

				if currentCount + 1 == totalAltars then
					player:setStorageValue(finalStorage, 1)
					if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Tomb) == 1 and player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Cellar) == 1 and player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Temple) == 1 then
						player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline, 2)
					end
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have placed all the idols on the altars and unlocked the temple!")
				end

				addEvent(removeIdol, resetTime, altar.position)
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There is already an idol here. Try another altar.")
			end
		end
	end

	return true
end

actions_goldenIdol:id(29299)
actions_goldenIdol:register()
