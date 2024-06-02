local axeBox = Action()

function axeBox.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not TwentyYearsACookQuest.Fryclops.BossZone:isInZone(player:getPosition()) then
		return true
	end

	if player:getStorageValue(Storage.Quest.U13_30.TwentyYearsACook.AxeBox) > os.time() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already got the flask.")
		return true
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You got an axe, unwieldy but sharp!")
	player:setStorageValue(Storage.Quest.U13_30.TwentyYearsACook.AxeBox, os.time() + (TwentyYearsACookQuest.Fryclops.TimeToDefeat * 1000))
	player:addItem(TwentyYearsACookQuest.Fryclops.Items.Axe, 1)
	return true
end

axeBox:id(TwentyYearsACookQuest.Fryclops.Items.AxeBox)
axeBox:register()

local fryclopsAxe = Action()

local function sendMagicEffectAroundFryclops()
	for i = 1, -1, -1 do
		for j = -1, 1, 1 do
			local yPosition = Position(TwentyYearsACookQuest.Fryclops.Catapult.FryclopsPosition.x + j, TwentyYearsACookQuest.Fryclops.Catapult.FryclopsPosition.y + i, TwentyYearsACookQuest.Fryclops.Catapult.FryclopsPosition.z)
			yPosition:sendMagicEffect(CONST_ME_POFF)
		end
	end
end

function fryclopsAxe.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target and not target:isItem() then
		return true
	end

	if target:getId() ~= TwentyYearsACookQuest.Fryclops.Items.CatapultRope then
		return true
	end

	if toPosition ~= TwentyYearsACookQuest.Fryclops.Catapult.RopePosition then
		return true
	end

	local tile = Tile(TwentyYearsACookQuest.Fryclops.Catapult.FryclopsPosition)
	if not tile then 
		return true
	end

	local creature = tile:getTopCreature()

	sendMagicEffectAroundFryclops()
	TwentyYearsACookQuest.Fryclops.Catapult.UpdateCatapultItems(true)

	if creature and creature:getName():lower() == "fryclops" then
		creature:say("WAAAAAaaaaaaaaa...a...a...a...a...a............!", TALKTYPE_MONSTER_SAY)
		creature:remove()
		local players = TwentyYearsACookQuest.Fryclops.BossZone:getPlayers()
		for i, playerInZone in pairs(players) do
			player:setStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine, 9)
		end
	end
end

fryclopsAxe:id(TwentyYearsACookQuest.Fryclops.Items.Axe)
fryclopsAxe:register()
