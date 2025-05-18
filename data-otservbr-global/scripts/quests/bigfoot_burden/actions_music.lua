local cToneStorages = {
	Storage.Quest.U9_60.BigfootsBurden.MelodyTone1,
	Storage.Quest.U9_60.BigfootsBurden.MelodyTone2,
	Storage.Quest.U9_60.BigfootsBurden.MelodyTone3,
	Storage.Quest.U9_60.BigfootsBurden.MelodyTone4,
	Storage.Quest.U9_60.BigfootsBurden.MelodyTone5,
	Storage.Quest.U9_60.BigfootsBurden.MelodyTone6,
	Storage.Quest.U9_60.BigfootsBurden.MelodyTone7,
}

local Crystals = {
	{ x = 32776, y = 31804, z = 10 }, -- Dark Blue Cystal
	{ x = 32781, y = 31807, z = 10 }, -- Red Crystal
	{ x = 32777, y = 31812, z = 10 }, -- Green Crystal
	{ x = 32771, y = 31810, z = 10 }, -- Light Blue Crystal
}

local bigfootMusic = Action()
function bigfootMusic.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.QuestLine) == 21 then
		local value = player:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.MelodyStatus)
		if Position(Crystals[player:getStorageValue(cToneStorages[value])]) == item:getPosition() then
			player:setStorageValue(Storage.Quest.U9_60.BigfootsBurden.MelodyStatus, value + 1)
			if value + 1 == 8 then
				toPosition:sendMagicEffect(CONST_ME_HEARTS)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "That was the correct note! Now you know your soul melody!")
				player:setStorageValue(Storage.Quest.U9_60.BigfootsBurden.QuestLine, 22)
			else
				toPosition:sendMagicEffect(CONST_ME_SOUND_GREEN)
				player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
			end
		else
			player:setStorageValue(Storage.Quest.U9_60.BigfootsBurden.MelodyStatus, 1)
			toPosition:sendMagicEffect(CONST_ME_SOUND_RED)
		end
	end
	return true
end

for b = 1, #Crystals do
	bigfootMusic:position(Crystals[b])
end
bigfootMusic:register()
