local function placeMask(position, wmask, nmask)
	local item = Tile(position):getItemById(nmask)
	if item then
		item:transform(wmask)
	end
end

local maskId = 29276

local function resetArea()
	local infectedCount = 0
	local playerCount = 0
	local spectators = Game.getSpectators(Position(32206, 32045, 15), false, true, 14, 14, 14, 14)

	for _, p in pairs(spectators) do
		local player = Player(p:getId())
		if player then
			playerCount = playerCount + 1
			if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScar.LastBossCurse) >= 1 then
				infectedCount = infectedCount + 1
			end
		end
	end

	if playerCount == infectedCount then
		return true
	else
		return false
	end
end

local actions_dreamcatcher_curse = Action()

function actions_dreamcatcher_curse.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return true
	end

	if item.itemid == 29274 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can rip off a dream catcher!")
		item:transform(29275)
		local newItem = Game.createItem(maskId, 1, Position(item:getPosition().x, item:getPosition().y + 1, item:getPosition().z))
		if newItem then
			newItem:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
		end
		addEvent(placeMask, 10 * 1000, item:getPosition(), 29274, 29275)
	elseif item.itemid == 29276 then
		if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScar.LastBossCurse) < 1 then
			if (target ~= player) and target:isPlayer() then
				if target:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.NightmareCurse) >= 1 then
					target:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.NightmareCurse, 0)
					target:removeCondition(CONDITION_OUTFIT)
					target:unregisterEvent(Storage.Quest.U12_00.TheDreamCourts.NightmareCurse)
					target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have a feeling of dread.")
					player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.NightmareCurse, 1)
					player:registerEvent(Storage.Quest.U12_00.TheDreamCourts.NightmareCurse)
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You take the dreamcurse on yourself!")
					item:remove(1)
					local j = resetArea()
					if j then
						Game.setStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.LastBossCurse, 0)
					end
				else
					return true
				end
			else
				return true
			end
		else
			return true
		end
	end

	return true
end

actions_dreamcatcher_curse:id(29274, 29275, 29276)
actions_dreamcatcher_curse:register()
